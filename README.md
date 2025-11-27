# E-Commerce App - Monorepo

Estrutura unificada do projeto com backend, admin panel e app mobile.

## 📁 Estrutura

```
ecommerce_app/
├── backend/          # API Node.js (Deploy: Render)
├── admin/            # Admin Panel React (Deploy: Netlify)
└── lib/              # App Flutter Mobile
```

## 🚀 Deploy

### Backend (Render)
- **Repositório**: Este monorepo
- **Root Directory**: `backend`
- **Build Command**: `npm install`
- **Start Command**: `node server.js`
- **URL**: https://eshop-backend-bfhw.onrender.com

### Admin Panel (Netlify)
- **Repositório**: Este monorepo
- **Base Directory**: `admin`
- **Build Command**: `npm install && npm run build`
- **Publish Directory**: `admin/dist`
- **URL**: https://sunny-lollipop-051661.netlify.app

### Mobile App (Flutter)
- Desenvolvimento local
- Build: `flutter build apk` ou `flutter build ios`

## 🔧 Desenvolvimento Local

### Backend
```bash
cd backend
npm install
npm start
```

### Admin
```bash
cd admin
npm install
npm run dev
```

### Mobile
```bash
flutter pub get
flutter run
```

## 📝 Workflow

1. Faça mudanças em qualquer pasta (backend, admin, ou lib)
2. Commit: `git add . && git commit -m "sua mensagem"`
3. Push: `git push origin main`
4. Deploy automático acontece para backend E admin

## ✅ Vantagens

- ✅ Um único repositório
- ✅ Um único `git push`
- ✅ Histórico unificado
- ✅ Sem confusão de repositórios
