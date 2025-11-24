import multer from 'multer';
import { BadRequestError } from '../utils/AppError';

// Configuração do Multer para armazenar em memória (buffer)
const storage = multer.memoryStorage();

// Filtro para aceitar apenas imagens
const fileFilter = (
  req: Express.Request,
  file: Express.Multer.File,
  cb: multer.FileFilterCallback
) => {
  // Tipos permitidos
  const allowedMimes = ['image/jpeg', 'image/jpg', 'image/png', 'image/webp'];

  if (allowedMimes.includes(file.mimetype)) {
    cb(null, true);
  } else {
    cb(
      new BadRequestError(
        'Tipo de arquivo inválido. Apenas JPEG, PNG e WebP são permitidos.'
      )
    );
  }
};

// Configuração do Multer
export const upload = multer({
  storage,
  fileFilter,
  limits: {
    fileSize: 5 * 1024 * 1024, // 5MB máximo por arquivo
  },
});

// Middleware para upload de uma imagem
export const uploadSingle = upload.single('image');

// Middleware para upload de múltiplas imagens
export const uploadMultiple = upload.array('images', 10); // Máximo 10 imagens
