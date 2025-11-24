import { Router } from 'express';
import {
  getProducts,
  getProductById,
  createProduct,
  updateProduct,
  deleteProduct,
  toggleProductStatus,
} from '../controllers/productController';
import { authenticate, requireAdmin } from '../middleware/auth';
import { uploadMultiple } from '../middleware/upload';

const router = Router();

// ===== ROTAS PÚBLICAS =====
// GET /api/products
router.get('/', getProducts);

// GET /api/products/:id
router.get('/:id', getProductById);

// ===== ROTAS PROTEGIDAS (Admin) =====
router.use(authenticate, requireAdmin);

// POST /api/products
router.post('/', uploadMultiple, createProduct);

// PUT /api/products/:id
router.put('/:id', uploadMultiple, updateProduct);

// DELETE /api/products/:id
router.delete('/:id', deleteProduct);

// PATCH /api/products/:id/toggle
router.patch('/:id/toggle', toggleProductStatus);

export default router;
