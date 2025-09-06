import 'package:hive/hive.dart';
import '../../domain/entities/activity_day.dart';

part 'activity_day_model.g.dart';

@HiveType(typeId: 1)
class ActivityDayModel extends HiveObject {
  @HiveField(0)
  DateTime date;

  @HiveField(1)
  List<String> activities;

  @HiveField(2)
  String? mood;

  ActivityDayModel({
    required this.date,
    required this.activities,
    this.mood,
  });

  ActivityDay toEntity() => ActivityDay(
        date: date,
        activities: List.unmodifiable(activities),
        mood: mood,
      );

  static ActivityDayModel fromEntity(ActivityDay e) => ActivityDayModel(
        date: e.date,
        activities: List<String>.from(e.activities),
        mood: e.mood,
      );
}