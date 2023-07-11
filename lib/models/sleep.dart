class Sleep {
  final String? dateOfSleep;
  final String? startTime;
  final String? endTime;
  final double? duration;
  final double? efficiency;

  Sleep({
    required this.dateOfSleep,
    required this.startTime,
    required this.endTime,
    required this.duration,
    required this.efficiency,
  });

  factory Sleep.fromJson(Map<String?, dynamic> json) {
    return Sleep(
      dateOfSleep: json['dateOfSleep'],
      startTime: (json['startTime']),
      endTime: (json['endTime']),
      duration: (json['duration'] as num).toDouble(),
      efficiency: (json['efficiency'] as num).toDouble(),
    );
  }

  @override
  String toString() {
    return 'Sleep(dateOfSleep: $dateOfSleep, startTime: $startTime, endTime: $endTime, duration: $duration, efficiency: $efficiency)';
  }
}
/* int operator [](String key) {
    switch (key) {
      case 'dateOfSleep':
        return dateOfSleep as int;
      case 'startTime':
        return startTime as int;
      case 'endTime':
        return endTime as int;
      case 'duration':
        return duration as int;
      case 'efficiency':
        return efficiency;
      default:
        throw ArgumentError('Invalid key: $key');
    }*/