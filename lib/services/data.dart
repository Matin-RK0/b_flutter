import 'package:hive/hive.dart';
part 'data.g.dart';

@HiveType(typeId: 1)
class HiveDataBase extends HiveObject {
  @HiveField(0)
  final int currentSongIndex;

  HiveDataBase({
      required this.currentSongIndex,
      });
      
}
