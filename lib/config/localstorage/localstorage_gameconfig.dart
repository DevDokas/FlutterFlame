import 'package:hive/hive.dart';

part 'localstorage_gameconfig.g.dart';

@HiveType(typeId: 0)
class LocalStorageGameConfig extends HiveObject {
  @HiveField(0)
  int? menuScoreLevel;

  LocalStorageGameConfig(this.menuScoreLevel);
}