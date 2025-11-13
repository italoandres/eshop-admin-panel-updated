import { useQuery } from '@tanstack/react-query';
import { bannerService } from '../services/bannerService';

export default function Dashboard() {
  const { data: banners } = useQuery({
    queryKey: ['banners'],
    queryFn: bannerService.getAll,
  });

  const stats = [
    { icon: '🎨', label: 'Banners Ativos', value: banners?.filter(b => b.isActive).length || 0, color: 'bg-blue-500' },
    { icon: '📦', label: 'Produtos', value: '0', color: 'bg-green-500' },
    { icon: '🛒', label: 'Pedidos', value: '0', color: 'bg-yellow-500' },
    { icon: '👥', label: 'Clientes', value: '0', color: 'bg-purple-500' },
  ];

  return (
    <div>
      <h1 className="text-3xl font-bold mb-6">Dashboard</h1>

      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
        {stats.map((stat, index) => (
          <div key={index} className="bg-white rounded-lg shadow p-6">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-gray-600 text-sm">{stat.label}</p>
                <p className="text-3xl font-bold mt-2">{stat.value}</p>
              </div>
              <div className={`${stat.color} text-white text-4xl p-4 rounded-lg`}>
                {stat.icon}
              </div>
            </div>
          </div>
        ))}
      </div>

      <div className="bg-white rounded-lg shadow p-6">
        <h2 className="text-xl font-bold mb-4">Bem-vindo ao EShop Admin! 👋</h2>
        <p className="text-gray-600">
          Use o menu lateral para navegar entre as diferentes seções do painel administrativo.
        </p>
      </div>
    </div>
  );
}
