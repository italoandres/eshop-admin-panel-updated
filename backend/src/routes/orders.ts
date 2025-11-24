import { Router } from 'express';
import {
  getMyOrders,
  getOrderById,
  createOrder,
  getAllOrders,
  getOrderByIdAdmin,
  updateOrderStatus,
  getOrderStats,
} from '../controllers/orderController';
import { authenticate, requireAdmin } from '../middleware/auth';

const router = Router();

// ===== ROTAS DO USUÁRIO (requerem autenticação) =====
router.use(authenticate);

// GET /api/orders
router.get('/', getMyOrders);

// GET /api/orders/:id
router.get('/:id', getOrderById);

// POST /api/orders
router.post('/', createOrder);

// ===== ROTAS ADMIN =====
router.use(requireAdmin);

// GET /api/admin/orders
router.get('/admin/all', getAllOrders);

// GET /api/admin/orders/stats
router.get('/admin/stats', getOrderStats);

// GET /api/admin/orders/:id
router.get('/admin/:id', getOrderByIdAdmin);

// PATCH /api/admin/orders/:id/status
router.patch('/admin/:id/status', updateOrderStatus);

export default router;
