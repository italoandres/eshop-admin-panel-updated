const Order = require('../models/Order');

const generateOrderNumber = () => {
  const timestamp = Date.now().toString(36).toUpperCase();
  const random = Math.random().toString(36).substring(2, 6).toUpperCase();
  return `ORD-${timestamp}-${random}`;
};

exports.createOrder = async (req, res) => {
  try {
    const { storeId, userId, customerInfo, items, subtotal, shippingFee, discount, total, paymentMethod, shippingAddress, notes } = req.body;
    if (!storeId || !userId || !customerInfo || !items || items.length === 0) {
      return res.status(400).json({ message: 'Campos obrigatórios faltando' });
    }
    const order = await Order.create({
      orderNumber: generateOrderNumber(),
      storeId, userId, customerInfo, items, subtotal,
      shippingFee: shippingFee || 0,
      discount: discount || 0,
      total, paymentMethod, shippingAddress, notes,
    });
    res.status(201).json(order);
  } catch (error) {
    res.status(400).json({ message: 'Erro ao criar pedido', error: error.message });
  }
};

exports.getUserOrders = async (req, res) => {
  try {
    const { userId } = req.params;
    const { page = 1, limit = 20 } = req.query;
    const skip = (parseInt(page) - 1) * parseInt(limit);
    const orders = await Order.find({ userId }).sort({ createdAt: -1 }).limit(parseInt(limit)).skip(skip);
    const total = await Order.countDocuments({ userId });
    res.json({ data: orders, meta: { totalPages: Math.ceil(total / parseInt(limit)), currentPage: parseInt(page), total } });
  } catch (error) {
    res.status(500).json({ message: 'Erro ao buscar pedidos', error: error.message });
  }
};

exports.getStoreOrders = async (req, res) => {
  try {
    const { storeId } = req.params;
    const { page = 1, limit = 20, status } = req.query;
    const query = { storeId };
    if (status) query.status = status;
    const skip = (parseInt(page) - 1) * parseInt(limit);
    const orders = await Order.find(query).sort({ createdAt: -1 }).limit(parseInt(limit)).skip(skip);
    const total = await Order.countDocuments(query);
    res.json({ data: orders, meta: { totalPages: Math.ceil(total / parseInt(limit)), currentPage: parseInt(page), total } });
  } catch (error) {
    res.status(500).json({ message: 'Erro ao buscar pedidos', error: error.message });
  }
};

exports.getOrderById = async (req, res) => {
  try {
    const order = await Order.findById(req.params.id);
    if (!order) return res.status(404).json({ message: 'Pedido não encontrado' });
    res.json(order);
  } catch (error) {
    res.status(500).json({ message: 'Erro ao buscar pedido', error: error.message });
  }
};

exports.updateOrderStatus = async (req, res) => {
  try {
    const { status, notes, trackingCode } = req.body;
    const order = await Order.findById(req.params.id);
    if (!order) return res.status(404).json({ message: 'Pedido não encontrado' });
    order.status = status;
    order.statusHistory.push({ status, timestamp: new Date(), notes: notes || '' });
    if (trackingCode) order.trackingCode = trackingCode;
    await order.save();
    res.json(order);
  } catch (error) {
    res.status(400).json({ message: 'Erro ao atualizar status', error: error.message });
  }
};

exports.getOrderStats = async (req, res) => {
  try {
    const { storeId } = req.params;
    const totalOrders = await Order.countDocuments({ storeId });
    const ordersByStatus = await Order.aggregate([{ $match: { storeId } }, { $group: { _id: '$status', count: { $sum: 1 } } }]);
    const revenueData = await Order.aggregate([{ $match: { storeId, paymentStatus: 'paid' } }, { $group: { _id: null, totalRevenue: { $sum: '$total' }, averageOrderValue: { $avg: '$total' } } }]);
    const recentOrders = await Order.find({ storeId }).sort({ createdAt: -1 }).limit(5).select('orderNumber status total createdAt');
    res.json({ totalOrders, ordersByStatus, revenue: revenueData[0] || { totalRevenue: 0, averageOrderValue: 0 }, recentOrders });
  } catch (error) {
    res.status(500).json({ message: 'Erro ao buscar estatísticas', error: error.message });
  }
};

exports.cancelOrder = async (req, res) => {
  try {
    const order = await Order.findById(req.params.id);
    if (!order) return res.status(404).json({ message: 'Pedido não encontrado' });
    if (['processing', 'shipped', 'delivered'].includes(order.status)) {
      return res.status(400).json({ message: 'Não é possível cancelar pedido neste status' });
    }
    order.status = 'cancelled';
    order.statusHistory.push({ status: 'cancelled', timestamp: new Date(), notes: 'Cancelado pelo cliente' });
    await order.save();
    res.json({ message: 'Pedido cancelado com sucesso', order });
  } catch (error) {
    res.status(500).json({ message: 'Erro ao cancelar pedido', error: error.message });
  }
};
