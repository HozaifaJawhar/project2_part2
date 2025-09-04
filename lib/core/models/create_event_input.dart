class CreateEventInput {
  final String name;
  final String description;
  final DateTime dateTime;
  final int minHours;
  final int maxHours;
  final String location;
  final int volunteersCount;
  final int departmentId;
  final String coverImagePath;
  CreateEventInput({
    required this.name,
    required this.description,
    required this.dateTime,
    required this.minHours,
    required this.maxHours,
    required this.location,
    required this.volunteersCount,
    required this.departmentId,
    required this.coverImagePath,
  });

  String get formattedDateTime {
    String two(int n) => n < 10 ? '0$n' : '$n';
    final y = dateTime.year;
    final m = two(dateTime.month);
    final d = two(dateTime.day);
    final hh = two(dateTime.hour);
    final mm = two(dateTime.minute);
    final ss = two(dateTime.second);
    return '$y-$m-$d $hh:$mm:$ss';
  }

  Map<String, String> toFields() {
    return {
      'name': name,
      'description': description,
      'date': formattedDateTime,
      'min_hours': minHours.toString(),
      'max_hours': maxHours.toString(),
      'location': location,
      'volunteers_count': volunteersCount.toString(), // <= مهم
      'department_id': departmentId.toString(),
    };
  }
}
