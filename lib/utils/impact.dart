class Impact {
  static String baseUrl = 'https://impact.dei.unipd.it/bwthw/';
  static String pingEndpoint = 'gate/v1/ping/';
  static String tokenEndpoint = 'gate/v1/token/';
  static String refreshEndpoint = 'gate/v1/refresh/';

  static String username = 'k9gBulGQvB'; //k9gBulGQvB
  static String password = '12345678!'; //12345678!

  static String patientUsername = 'Jpefaq6m58';
  // create a varible called startdate that is a string and set it to DateTime.now() in the format %Y-%m-%d.
  static String startDate =
      '2023-06-26'; //DateTime.now().toString().substring(0, 10);
  // create a varible called enddate that is a string and set it to DateTime.now() before 6 days in the format %Y-%m-%d.
  static String endDate =
      '2023-06-28'; //DateTime.now().subtract(const Duration(days: 6)).toString().substring(0, 10);

  // Heart Rate
  static String hrWeekRangeEndpoint =
      '/data/v1/heart_rate/patients/$patientUsername/daterange/start_date/$startDate/end_date/$endDate/';
  static String hrEndpoint =
      '/data/v1/heart_rate/patients/$patientUsername/day/$startDate/';
  // Resting Heart Rate
  static String restingHrDateRangeEndpoint =
      '/data/v1/resting_heart_rate/patients/$patientUsername/daterange/start_date/$startDate/end_date/$endDate/';
  static String restingHrEndpoint =
      '/data/v1/resting_heart_rate/patients/$patientUsername/day/$startDate/';
}//Impact