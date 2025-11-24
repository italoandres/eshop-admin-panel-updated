import { Request, Response } from 'express';
import { z } from 'zod';
import { User } from '../models/User';
import { generateTokens, verifyRefreshToken } from '../services/tokenService';
import {
  BadRequestError,
  UnauthorizedError,
  ConflictError,
} from '../utils/AppError';
import { asyncHandler } from '../utils/asyncHandler';
import { env } from '../config/env';

// ===== SCHEMAS DE VALIDAÇÃO =====
const registerSchema = z.object({
  name: z.string().min(2, 'Nome deve ter no mínimo 2 caracteres'),
  email: z.string().email('Email inválido'),
  password: z.string().min(6, 'Senha deve ter no mínimo 6 caracteres'),
  phone: z.string().optional(),
});

const loginSchema = z.object({
  email: z.string().email('Email inválido'),
  password: z.string().min(1, 'Senha é obrigatória'),
});

const refreshTokenSchema = z.object({
  refreshToken: z.string().min(1, 'Refresh token é obrigatório'),
});

// ===== CONTROLLERS =====

/**
 * POST /api/auth/register
 * Registra um novo usuário
 */
export const register = asyncHandler(async (req: Request, res: Response) => {
  // Valida dados de entrada
  const data = registerSchema.parse(req.body);

  // Verifica se email já existe
  const existingUser = await User.findOne({ email: data.email });
  if (existingUser) {
    throw new ConflictError('Email já está em uso');
  }

  // Cria usuário
  const user = await User.create({
    name: data.name,
    email: data.email,
    password: data.password,
    phone: data.phone,
    storeId: env.DEFAULT_STORE_ID, // Define loja padrão
  });

  // Gera tokens
  const tokens = generateTokens({
    id: user._id.toString(),
    email: user.email,
    name: user.name,
    role: user.role,
    storeId: user.storeId,
  });

  res.status(201).json({
    status: 'success',
    message: 'Usuário registrado com sucesso',
    data: {
      user: {
        id: user._id,
        name: user.name,
        email: user.email,
        phone: user.phone,
        role: user.role,
        storeId: user.storeId,
        createdAt: user.createdAt,
      },
      tokens,
    },
  });
});

/**
 * POST /api/auth/login
 * Faz login de um usuário
 */
export const login = asyncHandler(async (req: Request, res: Response) => {
  // Valida dados de entrada
  const data = loginSchema.parse(req.body);

  // Busca usuário (incluindo senha)
  const user = await User.findOne({ email: data.email }).select('+password');

  if (!user) {
    throw new UnauthorizedError('Email ou senha incorretos');
  }

  // Verifica senha
  const isPasswordValid = await user.comparePassword(data.password);

  if (!isPasswordValid) {
    throw new UnauthorizedError('Email ou senha incorretos');
  }

  // Gera tokens
  const tokens = generateTokens({
    id: user._id.toString(),
    email: user.email,
    name: user.name,
    role: user.role,
    storeId: user.storeId,
  });

  res.json({
    status: 'success',
    message: 'Login realizado com sucesso',
    data: {
      user: {
        id: user._id,
        name: user.name,
        email: user.email,
        phone: user.phone,
        role: user.role,
        storeId: user.storeId,
      },
      tokens,
    },
  });
});

/**
 * POST /api/auth/refresh
 * Renova o access token usando refresh token
 */
export const refreshToken = asyncHandler(async (req: Request, res: Response) => {
  // Valida dados de entrada
  const data = refreshTokenSchema.parse(req.body);

  try {
    // Verifica refresh token
    const decoded = verifyRefreshToken(data.refreshToken);

    // Busca usuário atualizado
    const user = await User.findById(decoded.id);

    if (!user) {
      throw new UnauthorizedError('Usuário não encontrado');
    }

    // Gera novos tokens
    const tokens = generateTokens({
      id: user._id.toString(),
      email: user.email,
      name: user.name,
      role: user.role,
      storeId: user.storeId,
    });

    res.json({
      status: 'success',
      message: 'Token renovado com sucesso',
      data: {
        tokens,
      },
    });
  } catch (error) {
    throw new UnauthorizedError('Refresh token inválido ou expirado');
  }
});

/**
 * GET /api/auth/me
 * Retorna dados do usuário autenticado
 */
export const getMe = asyncHandler(async (req: Request, res: Response) => {
  if (!req.user) {
    throw new UnauthorizedError('Usuário não autenticado');
  }

  // Busca usuário completo
  const user = await User.findById(req.user.id);

  if (!user) {
    throw new UnauthorizedError('Usuário não encontrado');
  }

  res.json({
    status: 'success',
    data: {
      user: {
        id: user._id,
        name: user.name,
        email: user.email,
        phone: user.phone,
        role: user.role,
        storeId: user.storeId,
        createdAt: user.createdAt,
      },
    },
  });
});

/**
 * POST /api/auth/logout
 * Logout (no servidor stateless, apenas retorna sucesso)
 */
export const logout = asyncHandler(async (req: Request, res: Response) => {
  // Em um sistema stateless com JWT, o logout é feito no cliente
  // (removendo os tokens do localStorage/SecureStorage)
  // Aqui apenas confirmamos a ação

  res.json({
    status: 'success',
    message: 'Logout realizado com sucesso',
  });
});
