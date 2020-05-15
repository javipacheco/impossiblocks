import 'dart:async';
import 'package:impossiblocks/models/models.dart';
import 'package:impossiblocks/services/local_preferences_service.dart';
import 'package:impossiblocks/services/services.dart';

class UserModule {
  final EntitiesService entityService = EntitiesService();
  final RepositoryService repositoryService = RepositoryService();
  final LocalPreferencesService localPreferencesService =
      LocalPreferencesService();

  UserModule();

  Future<bool> updatePoints(LeadboardGames leadboardGames, int points) async {
    return await localPreferencesService.updateRecordIfNecessary(
              leadboardGames, points);
  }

  Future<UserRepository> getCurrentUser() async {
    int userId = await localPreferencesService.getUserId();
    if (userId == null) {
      UserRepository first = await repositoryService.getFirstUser();
      userId = first.id;
      await localPreferencesService.setUserId(userId);
    }
    return await repositoryService.getUserWithId(userId);
  }

  Future<List<UserRepository>> getAllUsers() async {
    return await repositoryService.getAllUsers();
  }

  Future<List<UserState>> _converToRankedUser(LeadboardGames leadboardGame, List<UserRepository> users) async {
    var futureUsers = users.map((user) async {
      var userWithRecord = UserState.fromRepository(user);
      int record =
          await localPreferencesService.getRecordByUser(leadboardGame, user.id);
      return userWithRecord.copyWith(record: record);
    });
    List<UserState> userList = await Future.wait(futureUsers);

    userList.sort((a, b) => b.record.compareTo(a.record));
    return userList;
  }

  Future<List<UserState>> getAllUsersRanked(LeadboardGames leadboardGame) async {
    var users = await getAllUsers();
    return _converToRankedUser(leadboardGame, users);
  }

  Future<List<UserRankState>> getLeadboardsRank(int id) async {
    var users = await getAllUsers();

    var futureUserRank = [
      LeadboardGames.X3_3_ARCADE,
      LeadboardGames.X4_4_ARCADE,
      LeadboardGames.X5_5_ARCADE,
      LeadboardGames.X3_3_CLASSIC,
      LeadboardGames.X4_4_CLASSIC,
      LeadboardGames.X5_5_CLASSIC,
    ].map((leadboardGame) async {
      var usersRanked = await _converToRankedUser(leadboardGame, users);
      var userRanked = usersRanked.firstWhere((u) => u.id == id, orElse: () => null);
      int rank = userRanked != null ? usersRanked.indexOf(userRanked) + 1 : 0;
      return UserRankState(leadboardGame: leadboardGame, rank: rank);
    });

    return  await Future.wait(futureUserRank);
  }

  Future<List<LevelRepository>> getLevels() async {
    UserRepository user = await getCurrentUser();
    return await repositoryService.getAllLevelsWithUserId(user.id);
  }

  Future<void> saveLevel(int world, int number, int moves) async {
    UserRepository user = await getCurrentUser();

    LevelEntity levelEntity = await entityService.loadLevel(world, number);

    int stars = levelEntity.getStars(moves);

    LevelRepository level =
        await repositoryService.getLevel(user.id, world, number);
    if (level == null) {
      await repositoryService.addLevel(LevelRepository(
          id: 0, userId: user.id, world: world, number: number, stars: stars));
    } else {
      await repositoryService.updateLevel(level.copyWith(stars: stars));
    }
  }
}
