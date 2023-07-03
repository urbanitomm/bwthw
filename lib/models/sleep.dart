class Sleep {
  final DateTime startTime;
  final int efficiency;

  Sleep({required this.startTime, required this.efficiency}); //
  factory Sleep.fromJson(Map<String, dynamic> json) {
    return Sleep(startTime: json['startTime'], efficiency: json['efficiency']);
  }

  int operator [](String key) {
    switch (key) {
      case 'startTime':
        return startTime as int;
      case 'efficiency':
        return efficiency;
      default:
        throw ArgumentError('Invalid key: $key');
    }
  }

  @override
  String toString() {
    return 'HeartRate(startTime: $startTime, efficiency: $efficiency)';
  } //toString
}//HeartRate