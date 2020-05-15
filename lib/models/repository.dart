import "package:equatable/equatable.dart";

class UserRepository extends Equatable {
  static String table = "Users";

  final int id;
  final int color;
  final int avatar;
  final String name;
  final int coins;

  UserRepository({this.id, this.color, this.avatar, this.name, this.coins}) : super([id, color, avatar, name, coins]);

  UserRepository copyWith({int id, int color, int avatar, String name, int coins}) {
    return UserRepository(
        id: id ?? this.id,
        color: color ?? this.color,
        avatar: avatar ?? this.avatar,
        name: name ?? this.name,
        coins: coins ?? this.coins,);
  }

  factory UserRepository.fromMap(Map<String, dynamic> json) =>
      new UserRepository(
        id: json["id"],
        color: json["color"],
        avatar: json["avatar"],
        name: json["name"],
        coins: json["coins"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "color": color,
        "name": name,
        "avatar": avatar,
        "coins": coins,
      };

  Map<String, dynamic> toMapWithoutId() => {"color": color, "avatar": avatar, "name": name, "coins": coins};

  String toString() {
    return 'UserRepository{id: $id, color: $color, avatar: $avatar, name: $name, coins: $coins}';
  }
}

class LevelRepository extends Equatable {
  static String table = "Levels";

  final int id;
  final int userId;
  final int world;
  final int number;
  final int stars;

  LevelRepository({this.id, this.userId, this.world, this.number, this.stars}) : super([id, userId, world, number, stars]);

  LevelRepository copyWith({int id, int userId, int number, int stars}) {
    return LevelRepository(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        world: world ?? this.world,
        number: number ?? this.number,
        stars: stars ?? this.stars);
  }

  factory LevelRepository.fromMap(Map<String, dynamic> json) =>
      new LevelRepository(
        id: json["id"],
        userId: json["userId"],
        world: json["world"],
        number: json["number"],
        stars: json["stars"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "userId": userId,
        "world": world,
        "number": number,
        "stars": stars,
      };

  Map<String, dynamic> toMapWithoutId() => {
        "userId": userId,
        "number": number,
        "world": world,
        "stars": stars,
      };

  String toString() {
    return 'LevelRepository{id: $id, userId: $userId, world: $world, number: $number, stars: $stars}';
  }
}
