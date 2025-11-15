class AppConfig {
  // Identidade
  final String appName;
  final String packageName;
  final String storeId;
  final String storeName;
  final String logoUrl;
  
  // API
  final String apiBaseUrl;
  final String bannerApiUrl;
  final String apiKey;
  
  // Contato
  final String supportEmail;
  final String supportWhatsApp;
  final String supportPhone;
  
  // Redes Sociais
  final String? instagram;
  final String? facebook;
  final String? website;
  
  // Negócio
  final String companyName;
  final String cnpj;
  final String address;
  
  // URLs
  final String privacyPolicyUrl;
  final String termsOfServiceUrl;
  
  // Funcionalidades
  final bool enableCoupons;
  final bool enableReviews;
  final bool enableChat;
  final double freeShippingThreshold;
  
  // Pagamento
  final List<String> paymentMethods;
  
  // Firebase
  final String firebaseProjectId;
  
  // Google Maps
  final String googleMapsApiKey;

  const AppConfig({
    required this.appName,
    required this.packageName,
    required this.storeId,
    this.storeName = 'Minha Loja',
    this.logoUrl = '',
    required this.apiBaseUrl,
    required this.bannerApiUrl,
    required this.apiKey,
    required this.supportEmail,
    required this.supportWhatsApp,
    required this.supportPhone,
    this.instagram,
    this.facebook,
    this.website,
    required this.companyName,
    required this.cnpj,
    required this.address,
    required this.privacyPolicyUrl,
    required this.termsOfServiceUrl,
    this.enableCoupons = true,
    this.enableReviews = true,
    this.enableChat = false,
    this.freeShippingThreshold = 100.0,
    required this.paymentMethods,
    required this.firebaseProjectId,
    required this.googleMapsApiKey,
  });
}
