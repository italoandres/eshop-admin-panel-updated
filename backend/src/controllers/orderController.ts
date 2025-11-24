import { Request, Response } from 'express';
import { z } from 'zod';
import { Order, OrderStatus } from '../models/Order';
import { NotFoundError, BadRequestError } from '../utils/AppError';
import { asyncHandler } from '../utils/asyncHandler';
import { env } from '../config/env';

// ===== SCHEMAS DE VALIDAÇÃO =====
const createOrderSchema = z.object({
  items: z
    .array(
      z.object({
        productId: z.string(),
        productName: z.string(),
        imageUrl: z.string(),
        price: z.number().min(0),
        quantity: z.number().int().min(1),
        size: z.string().optional(),
        color: z.string().optional(),
      })
    )
    .min(1, 'Pedido deve ter pelo menos 1 item'),
  subtotal: z.number().min(0),
  discount: z.number().min(0).optional(),
  shippingFee: z.number().min(0).optional(),
  total: z.number().min(0),
  paymentMethod: z.enum(['credit_card', 'debit_card', 'pix', 'boleto']),
  shippingAddress: z.object({
    street: z.string(),
    number: z.string(),
    complement: z.string().optional(),
    neighborhood: z.string(),
    city: z.string(),
    state: z.string(),
    zipCode: z.string(),
  }),
  customerInfo: z.object({
    name: z.string(),
    email: z.string().email(),
    phone: z.string(),
  }),
  notes: z.string().max(1000).optional(),
});

const updateStatusSchema = z.object({
  status: z.enum([
    'pending',
    'confirmed',
    'processing',
    'shipped',
    'delivered',
    'cancelled',
  ]),
  notes: z.string().optional(),
  trackingCode: z.string().optional(),
});

// ===== HELPERS =====
/**
 * Gera número único de pedido
 */
const generateOrderNumber = (): string => {
  const timestamp = Date.now().toString(36).toUpperCase();
  const random = Math.random().toString(36).substring(2, 6).toUpperCase();
  return `ORD-${timestamp}-${random}`;
};

// ===== CONTROLLERS =====

/**
 * GET /api/orders
 * Lista pedidos do usuário
 */
export const getMyOrders = asyncHandler(async (req: Request, res: Response) => {
  if (!req.user) {
    throw new BadRequestError('Usuário não autenticado');
  }

  const page = parseInt(req.query.page as string) || 1;
  const limit = parseInt(req.query.limit as string) || 20;
  const skip = (page - 1) * limit;

  const orders = await Order.find({ userId: req.user.id })
    .sort({ createdAt: -1 })
    .skip(skip)
    .limit(limit);

  const total = await Order.countDocuments({ userId: req.user.id });

  res.json({
    status: 'success',
    data: {
      orders,
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
 * GET /api/orders/:id
 * Busca um pedido específico
 */
export const getOrderById = asyncHandler(
  async (req: Request, res: Response) => {
    if (!req.user) {
      throw new BadRequestError('Usuário não autenticado');
    }

    const { id } = req.params;

    const order = await Order.findOne({
      _id: id,
      userId: req.user.id,
    });

    if (!order) {
      throw new NotFoundError('Pedido não encontrado');
    }

    res.json({
      status: 'success',
      data: { order },
    });
  }
);

/**
 * POST /api/orders
 * Cria um novo pedido
 */
export const createOrder = asyncHandler(async (req: Request, res: Response) => {
  if (!req.user) {
    throw new BadRequestError('Usuário não autenticado');
  }

  const data = createOrderSchema.parse(req.body);
  const storeId = (req.query.storeId as string) || env.DEFAULT_STORE_ID;

  // Gera número do pedido
  const orderNumber = generateOrderNumber();

  // Cria pedido
  const order = await Order.create({
    orderNumber,
    userId: req.user.id,
    storeId,
    ...data,
  });

  res.status(201).json({
    status: 'success',
    message: 'Pedido criado com sucesso',
    data: { order },
  });
});

// ===== ROTAS ADMIN =====

/**
 * GET /api/admin/orders
 * Lista todos os pedidos (Admin)
 */
export const getAllOrders = asyncHandler(
  async (req: Request, res: Response) => {
    const storeId = (req.query.storeId as string) || env.DEFAULT_STORE_ID;

    const page = parseInt(req.query.page as string) || 1;
    const limit = parseInt(req.query.limit as string) || 20;
    const skip = (page - 1) * limit;

    // Filtros
    const filters: any = { storeId };

    if (req.query.status) {
      filters.status = req.query.status;
    }

    if (req.query.paymentStatus) {
      filters.paymentStatus = req.query.paymentStatus;
    }

    const orders = await Order.find(filters)
      .sort({ createdAt: -1 })
      .skip(skip)
      .limit(limit);

    const total = await Order.countDocuments(filters);

    res.json({
      status: 'success',
      data: {
        orders,
        pagination: {
          page,
          limit,
          total,
          pages: Math.ceil(total / limit),
        },
      },
    });
  }
);

/**
 * GET /api/admin/orders/:id
 * Busca pedido específico (Admin)
 */
export const getOrderByIdAdmin = asyncHandler(
  async (req: Request, res: Response) => {
    const { id } = req.params;
    const storeId = (req.query.storeId as string) || env.DEFAULT_STORE_ID;

    const order = await Order.findOne({ _id: id, storeId });

    if (!order) {
      throw new NotFoundError('Pedido não encontrado');
    }

    res.json({
      status: 'success',
      data: { order },
    });
  }
);

/**
 * PATCH /api/admin/orders/:id/status
 * Atualiza status do pedido
 */
export const updateOrderStatus = asyncHandler(
  async (req: Request, res: Response) => {
    const { id } = req.params;
    const storeId = (req.query.storeId as string) || env.DEFAULT_STORE_ID;

    const data = updateStatusSchema.parse(req.body);

    const order = await Order.findOne({ _id: id, storeId });

    if (!order) {
      throw new NotFoundError('Pedido não encontrado');
    }

    // Atualiza status
    order.status = data.status;

    // Adiciona no histórico
    order.statusHistory.push({
      status: data.status,
      timestamp: new Date(),
      notes: data.notes,
    });

    // Se forneceu código de rastreamento
    if (data.trackingCode) {
      order.trackingCode = data.trackingCode;
    }

    await order.save();

    res.json({
      status: 'success',
      message: 'Status do pedido atualizado com sucesso',
      data: { order },
    });
  }
);

/**
 * GET /api/admin/orders/stats
 * Estatísticas de pedidos (Dashboard)
 */
export const getOrderStats = asyncHandler(
  async (req: Request, res: Response) => {
    const storeId = (req.query.storeId as string) || env.DEFAULT_STORE_ID;

    // Total de pedidos
    const totalOrders = await Order.countDocuments({ storeId });

    // Pedidos por status
    const ordersByStatus = await Order.aggregate([
      { $match: { storeId } },
      { $group: { _id: '$status', count: { $sum: 1 } } },
    ]);

    // Receita total
    const revenueData = await Order.aggregate([
      { $match: { storeId, paymentStatus: 'paid' } },
      {
        $group: {
          _id: null,
          totalRevenue: { $sum: '$total' },
          averageOrderValue: { $avg: '$total' },
        },
      },
    ]);

    // Pedidos recentes
    const recentOrders = await Order.find({ storeId })
      .sort({ createdAt: -1 })
      .limit(5)
      .select('orderNumber status total createdAt');

    res.json({
      status: 'success',
      data: {
        totalOrders,
        ordersByStatus,
        revenue: revenueData[0] || { totalRevenue: 0, averageOrderValue: 0 },
        recentOrders,
      },
    });
  }
);
