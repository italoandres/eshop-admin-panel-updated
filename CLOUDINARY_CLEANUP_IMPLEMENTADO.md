# ✅ Cloudinary Cleanup Implementado

## O que foi feito

Adicionei limpeza automática de imagens do Cloudinary no `bannerController.js`:

### 1. **deleteBanner** - Limpa imagem ao deletar banner
- Quando um banner é deletado, a imagem correspondente no Cloudinary também é removida
- Evita acúmulo de imagens órfãs no Cloudinary
- Economiza espaço de armazenamento

### 2. **updateBanner** - Limpa imagem antiga ao atualizar
- Quando um banner é atualizado com uma nova imagem (base64)
- A imagem antiga do Cloudinary é deletada automaticamente
- Mantém apenas a imagem atual em uso

### 3. **extractPublicId** - Helper function
- Extrai o `publicId` de uma URL do Cloudinary
- Formato: `https://res.cloudinary.com/{cloud}/image/upload/v{version}/{folder}/{publicId}.{ext}`
- Retorna: `{folder}/{publicId}` (ex: `eshop/banners/abc123`)

## Benefícios

✅ **Economia de espaço**: Não acumula imagens antigas no Cloudinary  
✅ **Organização**: Mantém apenas imagens em uso  
✅ **Custo**: Reduz custos de armazenamento no Cloudinary  
✅ **Automático**: Não requer intervenção manual  

## Código Adicionado

```javascript
// No deleteBanner
if (banner.imageUrl && banner.imageUrl.includes('cloudinary.com')) {
  const publicId = extractPublicId(banner.imageUrl);
  if (publicId) {
    await deleteImage(publicId);
    console.log('🗑️ Imagem deletada do Cloudinary:', publicId);
  }
}

// No updateBanner (quando nova imagem é enviada)
if (oldImageUrl && oldImageUrl.includes('cloudinary.com')) {
  const publicId = extractPublicId(oldImageUrl);
  if (publicId) {
    await deleteImage(publicId);
    console.log('🗑️ Imagem antiga deletada do Cloudinary');
  }
}
```

## Próximos Passos

1. Testar deletando um banner no admin panel
2. Testar atualizando a imagem de um banner
3. Verificar no Cloudinary se as imagens foram removidas
4. Fazer commit das mudanças

## Observações

- A função só deleta imagens que estão no Cloudinary (verifica se a URL contém 'cloudinary.com')
- Imagens base64 antigas não são afetadas (não estão no Cloudinary)
- Erros na deleção são logados mas não impedem a operação principal
