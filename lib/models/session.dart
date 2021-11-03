 // You have to add this manually, for some reason it cannot be added automatically
import 'package:hive/hive.dart';
import 'package:spotter/enums/part.dart';
import 'package:spotter/models/session_exercise.dart';

part 'session.g.dart';

 @HiveType(typeId: 2)
class Session extends HiveObject{
  @HiveField(0)
  var exerciseEntries = <SessionExercise>[];

  @HiveField(1)
  dynamic _lastSession;

  @HiveField(2)
  List<Part> part = [];

  @HiveField(3)
  int duration = 0;

  @HiveField(4)
  String date = DateTime.now().toString();

  Session();
}
