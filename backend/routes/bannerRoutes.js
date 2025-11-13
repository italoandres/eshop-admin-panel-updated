const express = require('express');
const router = express.Router();
const {
  getBanners,
  getAllBanners,
  createBanner,
  updateBanner,
  deleteBanner,
} = require('../controllers/bannerController');
const authMiddleware = require('../middleware/auth');

// Rotas públicas (para o app Flutter)
router.get('/stores/:storeId/banners', getBanners);

// Rotas protegidas (para o admin)
router.get('/admin/stores/:storeId/banners', authMiddleware, getAllBanners);
router.post('/stores/:storeId/banners', authMiddleware, createBanner);
router.put('/stores/:storeId/banners/:id', authMiddleware, updateBanner);
router.delete('/stores/:storeId/banners/:id', authMiddleware, deleteBanner);

module.exports = router;
