import axios from 'axios';

const API_URL = 'http://localhost:4000/api';
const ADMIN_TOKEN = 'eshop_admin_token_2024';

const api = axios.create({
  baseURL: API_URL,
  headers: {
    'Content-Type': 'application/json',
  },
});

api.interceptors.request.use((config) => {
  const token = localStorage.getItem('adminToken') || ADMIN_TOKEN;
  if (token) {
    config.headers.Authorization = `Bearer ${token}`;
  }
  return config;
});

export default api;
