/// App configuration following SOLID principles
class AppConfig {
  static const String appName = 'Manage My Money';
  static const String appVersion = '1.0.0';
  static const int buildNumber = 1;
  
  // Firebase
  static const String firebaseProjectId = 'manage-my-money';
  
  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;
  
  // Cache
  static const Duration cacheExpiration = Duration(minutes: 30);
  
  // Validation
  static const int minPasswordLength = 6;
  static const int maxDescriptionLength = 500;
  static const double maxAmount = 999999999.99;
  
  // Date formats
  static const String dateFormat = 'dd/MM/yyyy';
  static const String dateTimeFormat = 'dd/MM/yyyy HH:mm';
  
  // Currency
  static const String currencySymbol = 'so\'m';
  static const String currencyCode = 'UZS';
  
  // Supported locales
  static const List<String> supportedLocales = ['uz', 'ru', 'en'];
  static const String defaultLocale = 'uz';
}
