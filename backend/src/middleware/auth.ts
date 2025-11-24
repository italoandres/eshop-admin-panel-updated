import { Request, Response, NextFunction } from 'express';
import { UnauthorizedError, ForbiddenError } from '../utils/AppError';
import { verifyAccessToken } from '../services/tokenService';
import { asyncHandler } from '../utils/asyncHandler';

/**
 * Middleware: Verifica se usuário está autenticado
 */
export const authenticate = asyncHandler(
  async (req: Request, res: Response, next: NextFunction) => {
    // Extrai token do header Authorization
    const authHeader = req.headers.authorization;

    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      throw new UnauthorizedError('Token não fornecido');
    }

    const token = authHeader.substring(7); // Remove "Bearer "

    try {
      // Verifica e decodifica o token
      const decoded = verifyAccessToken(token);

      // Adiciona dados do usuário na requisição
      req.user = {
        id: decoded.id,
        email: decoded.email,
        name: decoded.name,
        role: decoded.role,
        storeId: decoded.storeId,
      };

      next();
    } catch (error) {
      throw new UnauthorizedError('Token inválido ou expirado');
    }
  }
);

/**
 * Middleware: Verifica se usuário é admin
 */
export const requireAdmin = asyncHandler(
  async (req: Request, res: Response, next: NextFunction) => {
    if (!req.user) {
      throw new UnauthorizedError('Usuário não autenticado');
    }

    if (req.user.role !== 'admin') {
      throw new ForbiddenError('Acesso restrito a administradores');
    }

    next();
  }
);

/**
 * Middleware: Verifica se usuário tem acesso à loja
 * (Opcional - útil se quiser suportar multi-tenant no futuro)
 */
export const requireStoreAccess = (storeIdParam: string = 'storeId') => {
  return asyncHandler(async (req: Request, res: Response, next: NextFunction) => {
    if (!req.user) {
      throw new UnauthorizedError('Usuário não autenticado');
    }

    const requestedStoreId = req.params[storeIdParam];

    // Admin tem acesso a todas as lojas
    if (req.user.role === 'admin') {
      return next();
    }

    // Usuário normal só acessa sua própria loja
    if (req.user.storeId && req.user.storeId !== requestedStoreId) {
      throw new ForbiddenError('Acesso negado a esta loja');
    }

    next();
  });
};
