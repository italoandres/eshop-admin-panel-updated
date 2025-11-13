import '../app_config.dart';

// IMPORTANTE: Altere o IP para o IP da sua máquina na rede local
// Para descobrir seu IP:
// Windows: ipconfig
// Mac/Linux: ifconfig
// Procure por "IPv4" ou "inet"

const devConfig = AppConfig(
  // Identidade
  appName: 'EShop Dev',
  packageName: 'com.sameeraperera.eshop.dev',
  storeId: 'store_001',
  
  // API
  apiBaseUrl: 'https://e-commerce-mock-api-d8zv.onrender.com',
  bannerApiUrl: 'http://192.168.0.103:4000', // ← ALTERE ESTE IP!
  apiKey: '',
  
  // Contato
  supportEmail: 'suporte@eshop.com',
  supportWhatsApp: '+5511999999999',
  supportPhone: '+5511888888888',
  
  // Redes Sociais
  instagram: '@eshop',
  facebook: 'eshopoficial',
  website: 'https://www.eshop.com',
  
  // Negócio
  companyName: 'EShop Comércio Ltda',
  cnpj: '00.000.000/0001-00',
  address: 'Rua Exemplo, 123 - São Paulo, SP',
  
  // URLs
  privacyPolicyUrl: 'https://www.eshop.com/privacidade',
  termsOfServiceUrl: 'https://www.eshop.com/termos',
  
  // Funcionalidades
  enableCoupons: true,
  enableReviews: true,
  enableChat: false,
  freeShippingThreshold: 100.0,
  
  // Pagamento
  paymentMethods: ['pix', 'credit_card', 'debit_card'],
  
  // Firebase
  firebaseProjectId: 'eshop-dev',
  
  // Google Maps
  googleMapsApiKey: '',
);
