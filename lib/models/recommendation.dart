
import 'package:hive/hive.dart';
import 'package:spotter/enums/part.dart';

@HiveType()
class recommendation {

  @HiveField(0)
  String day;
  @HiveField(1)
  Part part;

  recommendation({required this.day, required this.part});
}