import { Request, Response, NextFunction, RequestHandler } from 'express';

/**
 * Wrapper para capturar erros assíncronos em controllers
 * Evita try-catch em todos os métodos
 */
export const asyncHandler = (fn: RequestHandler): RequestHandler => {
  return (req: Request, res: Response, next: NextFunction) => {
    Promise.resolve(fn(req, res, next)).catch(next);
  };
};
