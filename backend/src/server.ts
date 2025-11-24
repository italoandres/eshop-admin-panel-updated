import express, { Application } from 'express';
import cors from 'cors';
import helmet from 'helmet';
import morgan from 'morgan';
import rateLimit from 'express-rate-limit';
import { env, isDevelopment } from './config/env';
import { connectDatabase } from './config/database';
import './config/cloudinary'; // Inicializa Cloudinary
import { errorHandler, notFoundHandler } from './middleware/errorHandler';

// Importar rotas
import authRoutes from './routes/auth';
import bannerRoutes from './routes/banners';
import productRoutes from './routes/products';
import orderRoutes from './routes/orders';

const app: Application = express();

// ===== MIDDLEWARES DE SEGURANÇA =====
app.use(helmet()); // Headers de segurança

// CORS
const corsOrigins = env.CORS_ORIGIN.split(',').map((origin) => origin.trim());
app.use(
  cors({
    origin: corsOrigins,
    credentials: true,
    methods: ['GET', 'POST', 'PUT', 'PATCH', 'DELETE'],
    allowedHeaders: ['Content-Type', 'Authorization'],
  })
);

// Rate limiting (previne abuso de API)
const limiter = rateLimit({
  windowMs: env.RATE_LIMIT_WINDOW_MS,
  max: env.RATE_LIMIT_MAX_REQUESTS,
  message: 'Muitas requisições deste IP, tente novamente mais tarde',
  standardHeaders: true,
  legacyHeaders: false,
});
app.use('/api/', limiter);

// ===== MIDDLEWARES GERAIS =====
app.use(express.json({ limit: '10mb' })); // Parse JSON
app.use(express.urlencoded({ extended: true, limit: '10mb' })); // Parse URL-encoded

// Logging (apenas em desenvolvimento)
if (isDevelopment) {
  app.use(morgan('dev'));
}

// ===== HEALTH CHECK =====
app.get('/health', (req, res) => {
  res.json({
    status: 'ok',
    timestamp: new Date().toISOString(),
    environment: env.NODE_ENV,
    uptime: process.uptime(),
  });
});

// ===== ROTAS DA API =====
app.get('/api', (req, res) => {
  res.json({
    message: '🛍️  EShop Backend API',
    version: '1.0.0',
    documentation: '/api/docs',
    endpoints: {
      auth: '/api/auth',
      banners: '/api/stores/:storeId/banners',
      products: '/api/products',
      orders: '/api/orders',
    },
  });
});

// Rotas
app.use('/api/auth', authRoutes);
app.use('/api/stores/:storeId/banners', bannerRoutes);
app.use('/api/admin/stores/:storeId/banners', bannerRoutes);
app.use('/api/products', productRoutes);
app.use('/api/orders', orderRoutes);

// ===== TRATAMENTO DE ERROS =====
app.use(notFoundHandler); // 404
app.use(errorHandler); // Erro global

// ===== INICIALIZAÇÃO =====
const startServer = async () => {
  try {
    // Conecta ao banco de dados
    await connectDatabase();

    // Inicia o servidor
    const port = env.PORT;
    app.listen(port, () => {
      console.log('\n🚀 ===== SERVIDOR INICIADO ===== 🚀');
      console.log(`📍 URL: http://localhost:${port}`);
      console.log(`🌍 Ambiente: ${env.NODE_ENV}`);
      console.log(`🏪 Loja: ${env.STORE_NAME} (${env.DEFAULT_STORE_ID})`);
      console.log(`📦 MongoDB: Conectado`);
      console.log(`☁️  Cloudinary: Configurado`);
      console.log('=====================================\n');
    });
  } catch (error) {
    console.error('❌ Erro ao iniciar servidor:', error);
    process.exit(1);
  }
};

// Inicia o servidor
startServer();

export default app;
