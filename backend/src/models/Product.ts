import mongoose, { Schema, Document } from 'mongoose';

export interface IProduct extends Document {
  name: string;
  description: string;
  price: number;
  originalPrice?: number;
  imageUrl: string;
  images: Array<{
    url: string;
    publicId?: string;
  }>;
  categories: string[];
  highlights: string[];
  sizeGuideType?: 'shoe' | 'clothes';
  sizeGuideContent?: string;
  priceTags?: Array<{
    price: number;
    label: string;
  }>;
  active: boolean;
  storeId: string;
  createdAt: Date;
  updatedAt: Date;
}

const productSchema = new Schema<IProduct>(
  {
    name: {
      type: String,
      required: [true, 'Nome do produto é obrigatório'],
      trim: true,
      minlength: [3, 'Nome deve ter no mínimo 3 caracteres'],
      maxlength: [200, 'Nome deve ter no máximo 200 caracteres'],
    },
    description: {
      type: String,
      required: [true, 'Descrição é obrigatória'],
      trim: true,
      minlength: [10, 'Descrição deve ter no mínimo 10 caracteres'],
      maxlength: [5000, 'Descrição deve ter no máximo 5000 caracteres'],
    },
    price: {
      type: Number,
      required: [true, 'Preço é obrigatório'],
      min: [0, 'Preço não pode ser negativo'],
    },
    originalPrice: {
      type: Number,
      min: [0, 'Preço original não pode ser negativo'],
    },
    imageUrl: {
      type: String,
      required: [true, 'Imagem principal é obrigatória'],
    },
    images: [
      {
        url: { type: String, required: true },
        publicId: { type: String },
      },
    ],
    categories: [
      {
        type: String,
        trim: true,
      },
    ],
    highlights: [
      {
        type: String,
        trim: true,
        maxlength: [100, 'Highlight deve ter no máximo 100 caracteres'],
      },
    ],
    sizeGuideType: {
      type: String,
      enum: ['shoe', 'clothes'],
    },
    sizeGuideContent: {
      type: String,
      trim: true,
    },
    priceTags: [
      {
        price: { type: Number, required: true },
        label: { type: String, required: true, trim: true },
      },
    ],
    active: {
      type: Boolean,
      default: true,
    },
    storeId: {
      type: String,
      required: [true, 'Store ID é obrigatório'],
      trim: true,
    },
  },
  {
    timestamps: true,
  }
);

// Virtual: Calcula desconto percentual
productSchema.virtual('discountPercentage').get(function () {
  if (this.originalPrice && this.price < this.originalPrice) {
    return Math.round(((this.originalPrice - this.price) / this.originalPrice) * 100);
  }
  return 0;
});

// Configuração para incluir virtuals no JSON
productSchema.set('toJSON', { virtuals: true });
productSchema.set('toObject', { virtuals: true });

// Índices para performance
productSchema.index({ storeId: 1, active: 1 });
productSchema.index({ storeId: 1, categories: 1 });
productSchema.index({ name: 'text', description: 'text' }); // Busca textual

export const Product = mongoose.model<IProduct>('Product', productSchema);
