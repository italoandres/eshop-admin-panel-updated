import { Request, Response, NextFunction } from 'express';
import { AppError } from '../utils/AppError';
import { env, isDevelopment } from '../config/env';
import { ZodError } from 'zod';
import mongoose from 'mongoose';

/**
 * Middleware global de tratamento de erros
 */
export const errorHandler = (
  error: Error,
  req: Request,
  res: Response,
  next: NextFunction
) => {
  // Log do erro (em produção, usar sistema de logging profissional)
  console.error('❌ Erro:', error);

  // Erro operacional da aplicação
  if (error instanceof AppError) {
    return res.status(error.statusCode).json({
      status: 'error',
      message: error.message,
      ...(isDevelopment && { stack: error.stack }),
    });
  }

  // Erro de validação Zod
  if (error instanceof ZodError) {
    return res.status(400).json({
      status: 'error',
      message: 'Erro de validação',
      errors: error.errors.map((err) => ({
        field: err.path.join('.'),
        message: err.message,
      })),
    });
  }

  // Erro de validação do Mongoose
  if (error instanceof mongoose.Error.ValidationError) {
    const errors = Object.values(error.errors).map((err) => ({
      field: err.path,
      message: err.message,
    }));

    return res.status(400).json({
      status: 'error',
      message: 'Erro de validação',
      errors,
    });
  }

  // Erro de cast do Mongoose (ID inválido)
  if (error instanceof mongoose.Error.CastError) {
    return res.status(400).json({
      status: 'error',
      message: `ID inválido: ${error.value}`,
    });
  }

  // Erro de duplicação (unique constraint)
  if ((error as any).code === 11000) {
    const field = Object.keys((error as any).keyPattern)[0];
    return res.status(409).json({
      status: 'error',
      message: `${field} já está em uso`,
    });
  }

  // Erro desconhecido (500)
  return res.status(500).json({
    status: 'error',
    message: isDevelopment ? error.message : 'Erro interno do servidor',
    ...(isDevelopment && { stack: error.stack }),
  });
};

/**
 * Middleware para rotas não encontradas
 */
export const notFoundHandler = (req: Request, res: Response) => {
  res.status(404).json({
    status: 'error',
    message: `Rota não encontrada: ${req.method} ${req.originalUrl}`,
  });
};
