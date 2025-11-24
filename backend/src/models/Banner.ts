import mongoose, { Schema, Document } from 'mongoose';

export interface IBanner extends Document {
  title: string;
  imageUrl: string;
  cloudinaryPublicId?: string;
  targetUrl?: string;
  description?: string;
  order: number;
  active: boolean;
  storeId: string;
  createdAt: Date;
  updatedAt: Date;
}

const bannerSchema = new Schema<IBanner>(
  {
    title: {
      type: String,
      required: [true, 'Título é obrigatório'],
      trim: true,
      maxlength: [100, 'Título deve ter no máximo 100 caracteres'],
    },
    imageUrl: {
      type: String,
      required: [true, 'URL da imagem é obrigatória'],
    },
    cloudinaryPublicId: {
      type: String,
      trim: true,
    },
    targetUrl: {
      type: String,
      trim: true,
    },
    description: {
      type: String,
      trim: true,
      maxlength: [500, 'Descrição deve ter no máximo 500 caracteres'],
    },
    order: {
      type: Number,
      default: 0,
    },
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

// Índices para performance
bannerSchema.index({ storeId: 1, active: 1 });
bannerSchema.index({ storeId: 1, order: 1 });

export const Banner = mongoose.model<IBanner>('Banner', bannerSchema);
