class Impact{

  static String baseUrl = 'https://impact.dei.unipd.it/bwthw/';
  static String pingEndpoint = 'gate/v1/ping/';
  static String tokenEndpoint = 'gate/v1/token/';
  static String refreshEndpoint = 'gate/v1/refresh/';

  static String username = '#MYUSERNAME#';
  static String password = '#MYPASSWORD#';
  static String patientUsername = 'Jpefaq6m58';
  static String startDate = '2021-01-01';
  static String endDate = '2021-12-31';
  static String day = '2021-01-01';

  // Heart Rate
  static String hrDateRangeEndpoint = '/data/v1/heart_rate/patients/$patientUsername/daterange/start_date/$startDate/end_date/$endDate/';
  static String hrEndpoint = '/data/v1/heart_rate/patients/$patientUsername/day/$day/';
  // Resting Heart Rate
  static String restingHrDateRangeEndpoint = '/data/v1/resting_heart_rate/patients/$patientUsername/daterange/start_date/$startDate/end_date/$endDate/';
  static String restingHrEndpoint = '/data/v1/resting_heart_rate/patients/$patientUsername/day/$day/';

}//Impact