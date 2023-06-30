class HeartRate {
  final String time;
  final int value;
  final int confidence;

  HeartRate(
      {required this.time, required this.value, required this.confidence}); //
  factory HeartRate.fromJson(Map<String, dynamic> json) {
    return HeartRate(
        time: json['time'],
        value: json['value'],
        confidence: json['confidence']);
  }

  int operator [](String key) {
    switch (key) {
      case 'time':
        return time as int;
      case 'value':
        return value;
      case 'confidence':
        return confidence;
      default:
        throw ArgumentError('Invalid key: $key');
    }
  }

  @override
  String toString() {
    return 'HeartRate(time: $time, value: $value, confidence: $confidence)';
  } //toString
}//HeartRate