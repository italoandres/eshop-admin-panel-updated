/// Configurações da API
class ApiConfig {
  // URL base da API
  // Produção: Backend deployado no Render
  // Desenvolvimento local: 'http://localhost:4001'
  static const String baseUrl = 'https://eshop-backend-bfhw.onrender.com';
  
  // Endpoints
  static const String bannersEndpoint = '/api/stores';
  static const String productsEndpoint = '/api/products';
  static const String storeSettingsEndpoint = '/api/store-settings';
  
  // Store ID padrão
  static const String defaultStoreId = 'store_001';
  
  // Timeout para requisições
  static const Duration timeout = Duration(seconds: 30);
  
  // Headers padrão
  static Map<String, String> get defaultHeaders => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };
  
  // Admin token (para operações protegidas)
  static const String adminToken = 'eshop_admin_token_2024';
  
  static Map<String, String> get adminHeaders => {
        ...defaultHeaders,
        'Authorization': 'Bearer $adminToken',
      };
}
