class ActivityDay {
  final DateTime date; // truncated (Y/M/D)
  final List<String> activities; // unique IDs
  final String? mood; // latest mood
  const ActivityDay({
    required this.date,
    required this.activities,
    this.mood,
  });

  ActivityDay copyWith({
    DateTime? date,
    List<String>? activities,
    String? mood,
  }) =>
      ActivityDay(
        date: date ?? this.date,
        activities: activities ?? this.activities,
        mood: mood ?? this.mood,
      );
}