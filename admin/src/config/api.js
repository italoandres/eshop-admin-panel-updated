// Configuração da API
const API_BASE_URL = import.meta.env.VITE_API_URL || 'https://eshop-backend-bfhw.onrender.com/api';

export const API_CONFIG = {
  baseURL: API_BASE_URL,
  timeout: 10000,
  headers: {
    'Content-Type': 'application/json',
  },
};

export const API_ENDPOINTS = {
  banners: `${API_BASE_URL}/banners`,
  products: `${API_BASE_URL}/products`,
  discountRules: `${API_BASE_URL}/discount-rules`,
  storeSettings: `${API_BASE_URL}/store-settings`,
  orders: `${API_BASE_URL}/orders`,
  customers: `${API_BASE_URL}/customers`,
};

export default API_BASE_URL;
