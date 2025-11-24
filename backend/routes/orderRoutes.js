const express = require('express');
const router = express.Router();
const { createOrder, getUserOrders, getStoreOrders, getOrderById, updateOrderStatus, getOrderStats, cancelOrder } = require('../controllers/orderController');

router.post('/', createOrder);
router.get('/user/:userId', getUserOrders);
router.get('/:id', getOrderById);
router.delete('/:id', cancelOrder);
router.get('/store/:storeId', getStoreOrders);
router.get('/store/:storeId/stats', getOrderStats);
router.patch('/:id/status', updateOrderStatus);

module.exports = router;
