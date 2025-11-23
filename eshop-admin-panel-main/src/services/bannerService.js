import api from './api';

const STORE_ID = 'eshop_001';

export const bannerService = {
  getAll: async () => {
    const response = await api.get(`/admin/stores/${STORE_ID}/banners`);
    return response.data;
  },

  create: async (banner) => {
    const response = await api.post(`/admin/stores/${STORE_ID}/banners`, banner);
    return response.data;
  },

  update: async (id, banner) => {
    const response = await api.put(`/admin/stores/${STORE_ID}/banners/${id}`, banner);
    return response.data;
  },

  delete: async (id) => {
    const response = await api.delete(`/admin/stores/${STORE_ID}/banners/${id}`, banner);
    return response.data;
  },
};
