import { Router } from 'express';
import {
  register,
  login,
  refreshToken,
  getMe,
  logout,
} from '../controllers/authController';
import { authenticate } from '../middleware/auth';

const router = Router();

/**
 * Rotas públicas (sem autenticação)
 */
router.post('/register', register);
router.post('/login', login);
router.post('/refresh', refreshToken);

/**
 * Rotas protegidas (requerem autenticação)
 */
router.get('/me', authenticate, getMe);
router.post('/logout', authenticate, logout);

export default router;
