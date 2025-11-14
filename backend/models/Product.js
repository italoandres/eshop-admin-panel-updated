const mongoose = require('mongoose');

const priceTagSchema = new mongoose.Schema({
  name: { type: String, required: true }, // ex: "Preço Normal", "Promoção"
  price: { type: Number, required: true }
});

const categorySchema = new mongoose.Schema({
  name: { type: String, required: true },
  image: { type: String, required: true }
});

const shippingInfoSchema = new mongoose.Schema({
  isFree: { type: Boolean, default: false },
  shippingCost: { type: Number, default: 0 },
  estimatedDeliveryStart: { type: Date },
  estimatedDeliveryEnd: { type: Date }
});

const promotionSchema = new mongoose.Schema({
  id: { type: String },
  title: { type: String },
  description: { type: String },
  minPurchase: { type: Number },
  discount: { type: Number }
});

const productSchema = new mongoose.Schema({
  name: { type: String, required: true },
  description: { type: String, required: true },
  priceTags: [priceTagSchema],
  categories: [categorySchema],
  images: [{ type: String }],
  
  // Campos para tela de detalhes
  originalPrice: { type: Number },
  discountPercentage: { type: Number },
  rating: { type: Number, default: 0 },
  reviewCount: { type: Number, default: 0 },
  soldCount: { type: Number, default: 0 },
  shippingInfo: shippingInfoSchema,
  activePromotion: promotionSchema,
  
  createdAt: { type: Date, default: Date.now },
  updatedAt: { type: Date, default: Date.now }
});

// Middleware para atualizar updatedAt
productSchema.pre('save', function(next) {
  this.updatedAt = Date.now();
  next();
});

module.exports = mongoose.model('Product', productSchema);
