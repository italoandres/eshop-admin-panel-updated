import { Request, Response } from 'express';
import { z } from 'zod';
import { Banner } from '../models/Banner';
import { uploadImage, deleteImage } from '../services/cloudinaryService';
import { NotFoundError, BadRequestError } from '../utils/AppError';
import { asyncHandler } from '../utils/asyncHandler';
import { env } from '../config/env';

// ===== SCHEMAS DE VALIDAÇÃO =====
const createBannerSchema = z.object({
  title: z.string().min(1, 'Título é obrigatório').max(100),
  targetUrl: z.string().url('URL inválida').optional().or(z.literal('')),
  description: z.string().max(500).optional(),
  order: z.number().int().min(0).optional(),
  active: z.boolean().optional(),
});

const updateBannerSchema = createBannerSchema.partial();

// ===== CONTROLLERS =====

/**
 * GET /api/stores/:storeId/banners
 * Lista banners ativos para o app (público)
 */
export const getBannersForApp = asyncHandler(
  async (req: Request, res: Response) => {
    const storeId = req.params.storeId || env.DEFAULT_STORE_ID;

    const banners = await Banner.find({ storeId, active: true })
      .sort({ order: 1, createdAt: -1 })
      .select('-cloudinaryPublicId'); // Não expõe publicId

    res.json({
      status: 'success',
      data: { banners },
    });
  }
);

/**
 * GET /api/admin/stores/:storeId/banners
 * Lista todos os banners para o admin
 */
export const getAllBannersForAdmin = asyncHandler(
  async (req: Request, res: Response) => {
    const storeId = req.params.storeId || env.DEFAULT_STORE_ID;

    const banners = await Banner.find({ storeId }).sort({
      order: 1,
      createdAt: -1,
    });

    res.json({
      status: 'success',
      data: { banners },
    });
  }
);

/**
 * GET /api/admin/stores/:storeId/banners/:id
 * Busca um banner específico
 */
export const getBannerById = asyncHandler(
  async (req: Request, res: Response) => {
    const { storeId, id } = req.params;

    const banner = await Banner.findOne({ _id: id, storeId });

    if (!banner) {
      throw new NotFoundError('Banner não encontrado');
    }

    res.json({
      status: 'success',
      data: { banner },
    });
  }
);

/**
 * POST /api/admin/stores/:storeId/banners
 * Cria um novo banner
 */
export const createBanner = asyncHandler(
  async (req: Request, res: Response) => {
    const storeId = req.params.storeId || env.DEFAULT_STORE_ID;

    // Valida dados
    const data = createBannerSchema.parse(req.body);

    // Verifica se tem arquivo ou URL de imagem
    if (!req.file && !req.body.imageUrl) {
      throw new BadRequestError(
        'Imagem é obrigatória (envie arquivo ou imageUrl)'
      );
    }

    let imageUrl = req.body.imageUrl;
    let cloudinaryPublicId: string | undefined;

    // Se enviou arquivo, faz upload
    if (req.file) {
      const uploaded = await uploadImage(req.file, `banners/${storeId}`);
      imageUrl = uploaded.url;
      cloudinaryPublicId = uploaded.publicId;
    }
    // Se enviou base64 ou URL externa
    else if (imageUrl && imageUrl.startsWith('data:')) {
      const uploaded = await uploadImage(imageUrl, `banners/${storeId}`);
      imageUrl = uploaded.url;
      cloudinaryPublicId = uploaded.publicId;
    }

    // Cria banner
    const banner = await Banner.create({
      ...data,
      imageUrl,
      cloudinaryPublicId,
      storeId,
    });

    res.status(201).json({
      status: 'success',
      message: 'Banner criado com sucesso',
      data: { banner },
    });
  }
);

/**
 * PUT /api/admin/stores/:storeId/banners/:id
 * Atualiza um banner
 */
export const updateBanner = asyncHandler(
  async (req: Request, res: Response) => {
    const { storeId, id } = req.params;

    // Valida dados
    const data = updateBannerSchema.parse(req.body);

    // Busca banner
    const banner = await Banner.findOne({ _id: id, storeId });

    if (!banner) {
      throw new NotFoundError('Banner não encontrado');
    }

    let imageUrl = banner.imageUrl;
    let cloudinaryPublicId = banner.cloudinaryPublicId;

    // Se enviou novo arquivo, substitui imagem
    if (req.file) {
      // Deleta imagem antiga (se existir)
      if (banner.cloudinaryPublicId) {
        await deleteImage(banner.cloudinaryPublicId);
      }

      // Upload da nova
      const uploaded = await uploadImage(req.file, `banners/${storeId}`);
      imageUrl = uploaded.url;
      cloudinaryPublicId = uploaded.publicId;
    }
    // Se enviou nova URL base64
    else if (req.body.imageUrl && req.body.imageUrl.startsWith('data:')) {
      // Deleta imagem antiga
      if (banner.cloudinaryPublicId) {
        await deleteImage(banner.cloudinaryPublicId);
      }

      const uploaded = await uploadImage(req.body.imageUrl, `banners/${storeId}`);
      imageUrl = uploaded.url;
      cloudinaryPublicId = uploaded.publicId;
    }
    // Se enviou URL normal, apenas atualiza
    else if (req.body.imageUrl) {
      imageUrl = req.body.imageUrl;
    }

    // Atualiza banner
    Object.assign(banner, {
      ...data,
      imageUrl,
      cloudinaryPublicId,
    });

    await banner.save();

    res.json({
      status: 'success',
      message: 'Banner atualizado com sucesso',
      data: { banner },
    });
  }
);

/**
 * DELETE /api/admin/stores/:storeId/banners/:id
 * Deleta um banner
 */
export const deleteBanner = asyncHandler(
  async (req: Request, res: Response) => {
    const { storeId, id } = req.params;

    const banner = await Banner.findOne({ _id: id, storeId });

    if (!banner) {
      throw new NotFoundError('Banner não encontrado');
    }

    // Deleta imagem do Cloudinary
    if (banner.cloudinaryPublicId) {
      await deleteImage(banner.cloudinaryPublicId);
    }

    // Deleta banner do banco
    await banner.deleteOne();

    res.json({
      status: 'success',
      message: 'Banner deletado com sucesso',
    });
  }
);

/**
 * PATCH /api/admin/stores/:storeId/banners/:id/toggle
 * Ativa/desativa um banner
 */
export const toggleBannerStatus = asyncHandler(
  async (req: Request, res: Response) => {
    const { storeId, id } = req.params;

    const banner = await Banner.findOne({ _id: id, storeId });

    if (!banner) {
      throw new NotFoundError('Banner não encontrado');
    }

    banner.active = !banner.active;
    await banner.save();

    res.json({
      status: 'success',
      message: `Banner ${banner.active ? 'ativado' : 'desativado'} com sucesso`,
      data: { banner },
    });
  }
);
