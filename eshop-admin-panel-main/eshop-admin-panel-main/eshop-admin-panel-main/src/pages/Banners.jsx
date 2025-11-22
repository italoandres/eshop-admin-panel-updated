import { useState } from 'react';
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { bannerService } from '../services/bannerService';
import BannerCard from '../components/banners/BannerCard';
import BannerForm from '../components/banners/BannerForm';

export default function Banners() {
  const [isFormOpen, setIsFormOpen] = useState(false);
  const [editingBanner, setEditingBanner] = useState(null);
  const queryClient = useQueryClient();

  const { data: banners, isLoading } = useQuery({
    queryKey: ['banners'],
    queryFn: bannerService.getAll,
  });

  // Garantir que banners seja sempre um array
  const bannersArray = Array.isArray(banners) ? banners : (banners?.banners || []);

  const deleteMutation = useMutation({
    mutationFn: bannerService.delete,
    onSuccess: () => {
      queryClient.invalidateQueries(['banners']);
      alert('Banner deletado com sucesso!');
    },
    onError: (error) => {
      alert('Erro ao deletar banner: ' + error.message);
    },
  });

  const handleEdit = (banner) => {
    setEditingBanner(banner);
    setIsFormOpen(true);
  };

  const handleDelete = (id) => {
    if (confirm('Tem certeza que deseja deletar este banner?')) {
      deleteMutation.mutate(id);
    }
  };

  return (
    <div>
      <div className="flex justify-between items-center mb-6">
        <h1 className="text-3xl font-bold">Gerenciar Banners</h1>
        <button
          onClick={() => {
            setEditingBanner(null);
            setIsFormOpen(true);
          }}
          className="bg-blue-600 text-white px-6 py-3 rounded-lg hover:bg-blue-700 transition font-semibold shadow-md"
        >
          + Novo Banner
        </button>
      </div>

      {isLoading ? (
        <div className="flex justify-center items-center h-64">
          <div className="text-xl text-gray-600">Carregando banners...</div>
        </div>
      ) : bannersArray && bannersArray.length > 0 ? (
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
          {bannersArray.map((banner) => (
            <BannerCard
              key={banner._id}
              banner={banner}
              onEdit={() => handleEdit(banner)}
              onDelete={() => handleDelete(banner._id)}
            />
          ))}
        </div>
      ) : (
        <div className="bg-white rounded-lg shadow p-12 text-center">
          <div className="text-6xl mb-4">🎨</div>
          <h3 className="text-xl font-semibold mb-2">Nenhum banner cadastrado</h3>
          <p className="text-gray-600 mb-6">
            Comece criando seu primeiro banner para o carrossel do app
          </p>
          <button
            onClick={() => {
              setEditingBanner(null);
              setIsFormOpen(true);
            }}
            className="bg-blue-600 text-white px-6 py-3 rounded-lg hover:bg-blue-700 transition"
          >
            Criar Primeiro Banner
          </button>
        </div>
      )}

      {isFormOpen && (
        <BannerForm
          banner={editingBanner}
          onClose={() => {
            setIsFormOpen(false);
            setEditingBanner(null);
          }}
          onSuccess={() => {
            queryClient.invalidateQueries(['banners']);
            setIsFormOpen(false);
            setEditingBanner(null);
          }}
        />
      )}
    </div>
  );
}
