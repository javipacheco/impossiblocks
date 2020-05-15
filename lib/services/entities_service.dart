import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'package:impossiblocks/models/models.dart';

class EntitiesService {
  Future<WorldListEntity> loadWorlds() async {
    String jsonString = await rootBundle.loadString('assets/levels/worlds.json');
    final jsonResponse = json.decode(jsonString);
    return new WorldListEntity.fromJson(jsonResponse);
  }

  Future<LevelEntity> loadLevel(int world, int level) async {
    String jsonString = await rootBundle.loadString('assets/levels/world_${world}_level_$level.json');
    final jsonResponse = json.decode(jsonString);
    return new LevelEntity.fromJson(jsonResponse);
  }
}
