class RestingHeartRate {
  final String time;
  final int value;
  //final String error;

  RestingHeartRate({required this.time, required this.value}); //
  factory RestingHeartRate.fromJson(Map<String, dynamic> json) {
    return RestingHeartRate(time: json['time'], value: json['value']);
  }

  int operator [](String key) {
    switch (key) {
      case 'time':
        return time as int;
      case 'value':
        return value;
      //case 'error':
      //  return error as int;
      default:
        throw ArgumentError('Invalid key: $key');
    }
  }

  @override
  String toString() {
    return 'HeartRate(time: $time, value: $value)'; //, error: $error
  } //toString
}//HeartRate