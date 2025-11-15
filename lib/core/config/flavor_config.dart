import 'app_config.dart';

enum Flavor {
  dev,
  production,
}

class FlavorConfig {
  static Flavor? _currentFlavor;
  static AppConfig? _config;

  static Flavor get currentFlavor => _currentFlavor ?? Flavor.dev;
  static AppConfig get config => _config!;

  static void setFlavor(Flavor flavor, AppConfig config) {
    _currentFlavor = flavor;
    _config = config;
  }

  static bool get isDev => currentFlavor == Flavor.dev;
  static bool get isProd => currentFlavor == Flavor.production;
  
  static String get appName => config.appName;
  static String get storeId => config.storeId;
  static String get storeName => config.storeName;
  static String get logoUrl => config.logoUrl;
  static String get apiBaseUrl => config.apiBaseUrl;
  static String get bannerApiUrl => config.bannerApiUrl;
}
