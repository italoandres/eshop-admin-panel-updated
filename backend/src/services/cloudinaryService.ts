import { cloudinary } from '../config/cloudinary';
import { UploadApiResponse } from 'cloudinary';
import { BadRequestError } from '../utils/AppError';

/**
 * Faz upload de uma imagem para o Cloudinary
 * @param file - Buffer ou caminho do arquivo
 * @param folder - Pasta no Cloudinary (ex: 'banners', 'products')
 * @returns URL da imagem hospedada
 */
export const uploadImage = async (
  file: Express.Multer.File | string,
  folder: string = 'eshop'
): Promise<{ url: string; publicId: string }> => {
  try {
    let result: UploadApiResponse;

    // Se for um arquivo do Multer
    if (typeof file !== 'string' && file.buffer) {
      result = await new Promise((resolve, reject) => {
        const uploadStream = cloudinary.uploader.upload_stream(
          {
            folder,
            resource_type: 'image',
            transformation: [
              { width: 1200, height: 600, crop: 'limit' }, // Limita tamanho máximo
              { quality: 'auto:good' }, // Otimização automática
              { fetch_format: 'auto' }, // Formato otimizado (WebP quando suportado)
            ],
          },
          (error, result) => {
            if (error) reject(error);
            else resolve(result!);
          }
        );

        uploadStream.end(file.buffer);
      });
    }
    // Se for uma URL ou base64
    else {
      result = await cloudinary.uploader.upload(file as string, {
        folder,
        resource_type: 'image',
        transformation: [
          { width: 1200, height: 600, crop: 'limit' },
          { quality: 'auto:good' },
          { fetch_format: 'auto' },
        ],
      });
    }

    return {
      url: result.secure_url,
      publicId: result.public_id,
    };
  } catch (error: any) {
    console.error('Erro ao fazer upload para Cloudinary:', error);
    throw new BadRequestError(
      'Erro ao fazer upload da imagem. Verifique o formato e tamanho.'
    );
  }
};

/**
 * Deleta uma imagem do Cloudinary
 * @param publicId - ID público da imagem
 */
export const deleteImage = async (publicId: string): Promise<void> => {
  try {
    await cloudinary.uploader.destroy(publicId);
    console.log(`✅ Imagem deletada: ${publicId}`);
  } catch (error: any) {
    console.error('Erro ao deletar imagem do Cloudinary:', error);
    // Não lança erro - se falhar, não bloqueia a operação
  }
};

/**
 * Faz upload de múltiplas imagens
 * @param files - Array de arquivos
 * @param folder - Pasta no Cloudinary
 * @returns Array de URLs e publicIds
 */
export const uploadMultipleImages = async (
  files: Express.Multer.File[],
  folder: string = 'eshop'
): Promise<Array<{ url: string; publicId: string }>> => {
  try {
    const uploadPromises = files.map((file) => uploadImage(file, folder));
    return await Promise.all(uploadPromises);
  } catch (error) {
    throw new BadRequestError('Erro ao fazer upload de múltiplas imagens');
  }
};

/**
 * Deleta múltiplas imagens do Cloudinary
 * @param publicIds - Array de IDs públicos
 */
export const deleteMultipleImages = async (
  publicIds: string[]
): Promise<void> => {
  try {
    const deletePromises = publicIds.map((id) => deleteImage(id));
    await Promise.all(deletePromises);
  } catch (error) {
    console.error('Erro ao deletar múltiplas imagens:', error);
  }
};
