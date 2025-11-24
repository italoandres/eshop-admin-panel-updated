import { Request, Response } from 'express';
import { z } from 'zod';
import { Product } from '../models/Product';
import {
  uploadImage,
  uploadMultipleImages,
  deleteImage,
  deleteMultipleImages,
} from '../services/cloudinaryService';
import { NotFoundError, BadRequestError } from '../utils/AppError';
import { asyncHandler } from '../utils/asyncHandler';
import { env } from '../config/env';

// ===== SCHEMAS DE VALIDAÇÃO =====
const createProductSchema = z.object({
  name: z.string().min(3).max(200),
  description: z.string().min(10).max(5000),
  price: z.number().min(0),
  originalPrice: z.number().min(0).optional(),
  categories: z.array(z.string()).optional(),
  highlights: z.array(z.string().max(100)).optional(),
  sizeGuideType: z.enum(['shoe', 'clothes']).optional(),
  sizeGuideContent: z.string().optional(),
  priceTags: z
    .array(
      z.object({
        price: z.number(),
        label: z.string(),
      })
    )
    .optional(),
  active: z.boolean().optional(),
});

const updateProductSchema = createProductSchema.partial();

// ===== CONTROLLERS =====

/**
 * GET /api/products
 * Lista produtos (com paginação e filtros)
 */
export const getProducts = asyncHandler(async (req: Request, res: Response) => {
  const storeId = req.query.storeId as string || env.DEFAULT_STORE_ID;

  // Paginação
  const page = parseInt(req.query.page as string) || 1;
  const limit = parseInt(req.query.limit as string) || 20;
  const skip = (page - 1) * limit;

  // Filtros
  const filters: any = { storeId };

  // Filtro por ativo (por padrão, só mostra ativos)
  const showAll = req.query.showAll === 'true';
  if (!showAll) {
    filters.active = true;
  }

  // Filtro por categoria
  if (req.query.category) {
    filters.categories = req.query.category;
  }

  // Busca textual
  if (req.query.search) {
    filters.$text = { $search: req.query.search as string };
  }

  // Busca produtos
  const products = await Product.find(filters)
    .sort({ createdAt: -1 })
    .skip(skip)
    .limit(limit)
    .select('-images.publicId'); // Não expõe publicIds

  // Conta total
  const total = await Product.countDocuments(filters);

  res.json({
    status: 'success',
    data: {
      products,
      pagination: {
        page,
        limit,
        total,
        pages: Math.ceil(total / limit),
      },
    },
  });
});

/**
 * GET /api/products/:id
 * Busca um produto específico
 */
export const getProductById = asyncHandler(
  async (req: Request, res: Response) => {
    const { id } = req.params;
    const storeId = req.query.storeId as string || env.DEFAULT_STORE_ID;

    const product = await Product.findOne({ _id: id, storeId }).select(
      '-images.publicId'
    );

    if (!product) {
      throw new NotFoundError('Produto não encontrado');
    }

    res.json({
      status: 'success',
      data: { product },
    });
  }
);

/**
 * POST /api/products
 * Cria um novo produto
 */
export const createProduct = asyncHandler(
  async (req: Request, res: Response) => {
    const storeId = (req.query.storeId as string) || env.DEFAULT_STORE_ID;

    // Parse body se vier como string (quando tem multipart)
    let data;
    if (typeof req.body.data === 'string') {
      data = createProductSchema.parse(JSON.parse(req.body.data));
    } else {
      data = createProductSchema.parse(req.body);
    }

    // Verifica se tem imagens
    if (!req.files || !Array.isArray(req.files) || req.files.length === 0) {
      throw new BadRequestError('Pelo menos uma imagem é obrigatória');
    }

    // Upload de imagens
    const uploadedImages = await uploadMultipleImages(
      req.files as Express.Multer.File[],
      `products/${storeId}`
    );

    // Primeira imagem é a principal
    const imageUrl = uploadedImages[0].url;

    // Cria produto
    const product = await Product.create({
      ...data,
      imageUrl,
      images: uploadedImages,
      storeId,
    });

    res.status(201).json({
      status: 'success',
      message: 'Produto criado com sucesso',
      data: { product },
    });
  }
);

/**
 * PUT /api/products/:id
 * Atualiza um produto
 */
export const updateProduct = asyncHandler(
  async (req: Request, res: Response) => {
    const { id } = req.params;
    const storeId = (req.query.storeId as string) || env.DEFAULT_STORE_ID;

    // Parse body
    let data;
    if (typeof req.body.data === 'string') {
      data = updateProductSchema.parse(JSON.parse(req.body.data));
    } else {
      data = updateProductSchema.parse(req.body);
    }

    // Busca produto
    const product = await Product.findOne({ _id: id, storeId });

    if (!product) {
      throw new NotFoundError('Produto não encontrado');
    }

    // Se enviou novas imagens, substitui as antigas
    if (req.files && Array.isArray(req.files) && req.files.length > 0) {
      // Deleta imagens antigas
      const oldPublicIds = product.images
        .filter((img) => img.publicId)
        .map((img) => img.publicId!);

      if (oldPublicIds.length > 0) {
        await deleteMultipleImages(oldPublicIds);
      }

      // Upload das novas
      const uploadedImages = await uploadMultipleImages(
        req.files as Express.Multer.File[],
        `products/${storeId}`
      );

      product.imageUrl = uploadedImages[0].url;
      product.images = uploadedImages;
    }

    // Atualiza campos
    Object.assign(product, data);
    await product.save();

    res.json({
      status: 'success',
      message: 'Produto atualizado com sucesso',
      data: { product },
    });
  }
);

/**
 * DELETE /api/products/:id
 * Deleta um produto
 */
export const deleteProduct = asyncHandler(
  async (req: Request, res: Response) => {
    const { id } = req.params;
    const storeId = (req.query.storeId as string) || env.DEFAULT_STORE_ID;

    const product = await Product.findOne({ _id: id, storeId });

    if (!product) {
      throw new NotFoundError('Produto não encontrado');
    }

    // Deleta imagens do Cloudinary
    const publicIds = product.images
      .filter((img) => img.publicId)
      .map((img) => img.publicId!);

    if (publicIds.length > 0) {
      await deleteMultipleImages(publicIds);
    }

    // Deleta produto
    await product.deleteOne();

    res.json({
      status: 'success',
      message: 'Produto deletado com sucesso',
    });
  }
);

/**
 * PATCH /api/products/:id/toggle
 * Ativa/desativa um produto
 */
export const toggleProductStatus = asyncHandler(
  async (req: Request, res: Response) => {
    const { id } = req.params;
    const storeId = (req.query.storeId as string) || env.DEFAULT_STORE_ID;

    const product = await Product.findOne({ _id: id, storeId });

    if (!product) {
      throw new NotFoundError('Produto não encontrado');
    }

    product.active = !product.active;
    await product.save();

    res.json({
      status: 'success',
      message: `Produto ${product.active ? 'ativado' : 'desativado'} com sucesso`,
      data: { product },
    });
  }
);
