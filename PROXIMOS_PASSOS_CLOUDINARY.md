# 🚀 Próximos Passos - Integração Cloudinary

## 📋 Resumo do Status Atual

✅ **Funcionando:**
- Banners com upload para Cloudinary
- Backend rodando no Render
- MongoDB conectado

⚠️ **Pendente:**
- Upload de logo da loja
- Upload de imagens de produtos (múltiplas)
- Upload de imagens de variantes de produtos

---

## 🎯 Plano de Ação

### Fase 1: Logo da Loja (1-2 horas)

#### Backend
**Arquivo:** `backend/controllers/storeSettingsController.js`

```javascript
const { uploadImage, isBase64Image } = require('../services/cloudinaryService');

// Adicionar no método de update/create
exports.updateStoreSettings = async (req, res) => {
  try {
    const { storeId } = req.params;
    let { logoUrl, ...otherFields } = req.body;

    // Upload de logo para Cloudinary
    if (logoUrl && isBase64Image(logoUrl)) {
      console.log('📤 Upload de logo para Cloudinary...');
      try {
        const uploadResult = await uploadImage(logoUrl, 'eshop/logos');
        logoUrl = uploadResult.url;
        console.log('✅ Logo uploaded:', logoUrl);
      } catch (error) {
        console.error('❌ Erro no upload do logo:', error.message);
        return res.status(500).json({ 
          message: 'Erro ao fazer upload do logo', 
          error: error.message 
        });
      }
    }

    // Atualizar ou criar configurações
    const settings = await StoreSettings.findOneAndUpdate(
      { storeId },
      { storeId, logoUrl, ...otherFields },
      { new: true, upsert: true }
    );

    res.json(settings);
  } catch (error) {
    console.error('Error updating store settings:', error);
    res.status(500).json({ message: 'Erro ao atualizar configurações', error: error.message });
  }
};
```

#### Flutter App
**Criar tela de upload de logo:**
1. Adicionar `image_picker` no `pubspec.yaml`
2. Criar botão para selecionar imagem
3. Converter para base64
4. Enviar para backend

**Exemplo:**
```dart
import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

Future<void> uploadLogo() async {
  final picker = ImagePicker();
  final image = await picker.pickImage(source: ImageSource.gallery);
  
  if (image != null) {
    final bytes = await File(image.path).readAsBytes();
    final base64Image = 'data:image/png;base64,${base64Encode(bytes)}';
    
    // Enviar para backend
    await _storeSettingsRepository.updateLogo(storeId, base64Image);
  }
}
```

---

### Fase 2: Imagens de Produtos (2-3 horas)

#### Backend
**Arquivo:** `backend/controllers/productController.js`

```javascript
const { uploadImage, isBase64Image } = require('../services/cloudinaryService');

exports.createProduct = async (req, res) => {
  try {
    let { images, variants, ...productData } = req.body;

    console.log('=== CREATE PRODUCT ===');
    console.log('Images count:', images?.length || 0);
    console.log('Variants count:', variants?.length || 0);

    // 1. Upload de imagens principais
    if (images && images.length > 0) {
      console.log('📤 Uploading main images...');
      const uploadPromises = images.map(async (img) => {
        if (isBase64Image(img)) {
          const result = await uploadImage(img, 'eshop/products');
          return result.url;
        }
        return img; // Já é URL
      });
      images = await Promise.all(uploadPromises);
      console.log('✅ Main images uploaded:', images.length);
    }

    // 2. Upload de imagens das variantes
    if (variants && variants.length > 0) {
      console.log('📤 Uploading variant images...');
      for (let variant of variants) {
        if (variant.images && variant.images.length > 0) {
          const variantUploadPromises = variant.images.map(async (img) => {
            if (isBase64Image(img.url)) {
              const result = await uploadImage(img.url, `eshop/products/${variant.color}`);
              return { ...img, url: result.url };
            }
            return img;
          });
          variant.images = await Promise.all(variantUploadPromises);
        }
      }
      console.log('✅ Variant images uploaded');
    }

    // 3. Criar produto
    const product = await Product.create({
      ...productData,
      images,
      variants
    });

    console.log('✅ Product created:', product._id);
    res.status(201).json(product);
  } catch (error) {
    console.error('❌ Error creating product:', error.message);
    res.status(400).json({ 
      message: 'Erro ao criar produto', 
      error: error.message 
    });
  }
};

// Mesmo para updateProduct
exports.updateProduct = async (req, res) => {
  try {
    const { id } = req.params;
    let { images, variants, ...productData } = req.body;

    const product = await Product.findById(id);
    if (!product) {
      return res.status(404).json({ message: 'Produto não encontrado' });
    }

    // Upload de novas imagens (mesmo código acima)
    if (images && images.length > 0) {
      const uploadPromises = images.map(async (img) => {
        if (isBase64Image(img)) {
          const result = await uploadImage(img, 'eshop/products');
          return result.url;
        }
        return img;
      });
      images = await Promise.all(uploadPromises);
    }

    if (variants && variants.length > 0) {
      for (let variant of variants) {
        if (variant.images && variant.images.length > 0) {
          const variantUploadPromises = variant.images.map(async (img) => {
            if (isBase64Image(img.url)) {
              const result = await uploadImage(img.url, `eshop/products/${variant.color}`);
              return { ...img, url: result.url };
            }
            return img;
          });
          variant.images = await Promise.all(variantUploadPromises);
        }
      }
    }

    // Atualizar produto
    Object.assign(product, { ...productData, images, variants });
    await product.save();

    res.json(product);
  } catch (error) {
    console.error('Error updating product:', error);
    res.status(400).json({ message: 'Erro ao atualizar produto', error: error.message });
  }
};
```

#### Flutter App
**Criar tela de cadastro de produtos:**
1. Adicionar seleção múltipla de imagens
2. Preview das imagens selecionadas
3. Suporte para variantes (cor + imagens)
4. Converter todas para base64
5. Enviar para backend

---

### Fase 3: Testar e Validar (1 hora)

#### Checklist de Testes

**Logo:**
- [ ] Upload de logo funciona
- [ ] Logo aparece no app
- [ ] Logo está no Cloudinary (pasta `eshop/logos`)
- [ ] URL do Cloudinary está salva no MongoDB

**Produtos:**
- [ ] Upload de múltiplas imagens funciona
- [ ] Imagens aparecem na listagem
- [ ] Imagens aparecem nos detalhes
- [ ] Variantes com imagens diferentes funcionam
- [ ] Todas as imagens estão no Cloudinary (pasta `eshop/products`)

**Performance:**
- [ ] Imagens carregam rápido
- [ ] Não há erro de timeout
- [ ] Logs do Render mostram uploads bem-sucedidos

---

## 🔧 Comandos Úteis

### Copiar código atualizado para repositório de deploy
```powershell
# 1. Atualizar arquivo no backend local
# (fazer suas modificações em backend/controllers/...)

# 2. Copiar para repositório de deploy
Copy-Item "backend\controllers\productController.js" "C:\Users\ItaloLior\OneDrive\Documentos\eco\eshop-backend-temp\controllers\" -Force

# 3. Fazer commit e push
Push-Location "C:\Users\ItaloLior\OneDrive\Documentos\eco\eshop-backend-temp"
git add controllers/productController.js
git commit -m "feat: Add Cloudinary upload for product images"
git push origin main
Pop-Location
```

### Verificar logs do Render
1. Acesse: https://dashboard.render.com
2. Clique no serviço do backend
3. Vá em "Logs"
4. Procure por mensagens de upload do Cloudinary

---

## 📝 Estrutura de Pastas no Cloudinary

```
eshop/
├── banners/          ✅ Funcionando
│   └── banner_123.jpg
├── logos/            ⚠️ A implementar
│   └── logo_eshop.png
└── products/         ⚠️ A implementar
    ├── product_456.jpg
    ├── product_456_2.jpg
    └── Azul/         (variante)
        └── azul_1.jpg
```

---

## ⚠️ Pontos de Atenção

1. **Tamanho das imagens:** Cloudinary aceita até 10MB por imagem (free tier)
2. **Limite de uploads:** 25k transformações/mês (free tier)
3. **Timeout:** Uploads grandes podem demorar, considerar loading no app
4. **Erro handling:** Sempre ter fallback se Cloudinary falhar
5. **Validação:** Validar formato de imagem antes de enviar (jpg, png, webp)

---

## 🎯 Ordem Recomendada de Implementação

1. **Logo da loja** (mais simples, 1 imagem apenas)
2. **Imagens principais de produtos** (múltiplas imagens)
3. **Imagens de variantes** (mais complexo)
4. **Testes completos**
5. **Otimizações de UX** (preview, crop, etc)

---

## 💡 Dicas

- Sempre testar localmente antes de fazer push
- Verificar logs do Render após cada deploy
- Manter backup das imagens antigas (caso algo dê errado)
- Documentar cada mudança no código
- Fazer commits pequenos e frequentes

---

**Boa sorte na próxima sessão! 🚀**
