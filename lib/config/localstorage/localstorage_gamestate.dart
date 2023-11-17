import 'package:hive/hive.dart';

part 'localstorage_gamestate.g.dart';
part 'listlocalstorage_gamestate.g.dart';

@HiveType(typeId: 1)
class LocalStorageGameState extends HiveObject {
  @HiveField(0)
  String? levelName;

  @HiveField(1)
  String? bestTime;

  @HiveField(2)
  int? bestCollect;

  LocalStorageGameState(this.levelName, this.bestTime, this.bestCollect);
}