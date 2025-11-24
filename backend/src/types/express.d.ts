import { Request } from 'express';

declare global {
  namespace Express {
    interface Request {
      user?: {
        id: string;
        email: string;
        name: string;
        storeId?: string;
        role?: 'user' | 'admin';
      };
      file?: Express.Multer.File;
      files?: Express.Multer.File[];
    }
  }
}
