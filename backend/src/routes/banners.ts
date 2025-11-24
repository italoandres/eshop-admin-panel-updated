import { Router } from 'express';
import {
  getBannersForApp,
  getAllBannersForAdmin,
  getBannerById,
  createBanner,
  updateBanner,
  deleteBanner,
  toggleBannerStatus,
} from '../controllers/bannerController';
import { authenticate, requireAdmin } from '../middleware/auth';
import { uploadSingle } from '../middleware/upload';

const router = Router({ mergeParams: true }); // mergeParams para acessar :storeId

// ===== ROTAS PÚBLICAS (App) =====
// GET /api/stores/:storeId/banners
router.get('/', getBannersForApp);

// ===== ROTAS PROTEGIDAS (Admin) =====
// Todas as rotas abaixo exigem autenticação de admin
router.use(authenticate, requireAdmin);

// GET /api/admin/stores/:storeId/banners
router.get('/all', getAllBannersForAdmin);

// GET /api/admin/stores/:storeId/banners/:id
router.get('/:id', getBannerById);

// POST /api/admin/stores/:storeId/banners
// Aceita tanto multipart/form-data (arquivo) quanto JSON (imageUrl)
router.post('/', uploadSingle, createBanner);

// PUT /api/admin/stores/:storeId/banners/:id
router.put('/:id', uploadSingle, updateBanner);

// DELETE /api/admin/stores/:storeId/banners/:id
router.delete('/:id', deleteBanner);

// PATCH /api/admin/stores/:storeId/banners/:id/toggle
router.patch('/:id/toggle', toggleBannerStatus);

export default router;
