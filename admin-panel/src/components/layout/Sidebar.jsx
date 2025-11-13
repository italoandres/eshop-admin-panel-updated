import { Link, useLocation } from 'react-router-dom';

export default function Sidebar({ isOpen }) {
  const location = useLocation();

  const menuItems = [
    { path: '/dashboard', icon: '📊', label: 'Dashboard' },
    { path: '/banners', icon: '🎨', label: 'Banners' },
    { path: '/products', icon: '📦', label: 'Produtos', badge: 'Em breve' },
    { path: '/orders', icon: '🛒', label: 'Pedidos', badge: 'Em breve' },
    { path: '/customers', icon: '👥', label: 'Clientes', badge: 'Em breve' },
    { path: '/notifications', icon: '🔔', label: 'Notificações', badge: 'Em breve' },
    { path: '/reviews', icon: '⭐', label: 'Avaliações', badge: 'Em breve' },
    { path: '/settings', icon: '⚙️', label: 'Configurações', badge: 'Em breve' },
  ];

  if (!isOpen) return null;

  return (
    <aside className="w-64 bg-gray-900 text-white flex-shrink-0">
      <div className="p-6 border-b border-gray-800">
        <h1 className="text-2xl font-bold">🛍️ EShop Admin</h1>
        <p className="text-gray-400 text-sm mt-1">Painel Administrativo</p>
      </div>
      <nav className="mt-6">
        {menuItems.map((item) => (
          <Link
            key={item.path}
            to={item.path}
            className={`flex items-center justify-between px-6 py-3 hover:bg-gray-800 transition-colors ${
              location.pathname === item.path ? 'bg-gray-800 border-l-4 border-blue-500' : ''
            }`}
          >
            <div className="flex items-center">
              <span className="text-2xl mr-3">{item.icon}</span>
              <span>{item.label}</span>
            </div>
            {item.badge && (
              <span className="text-xs bg-gray-700 px-2 py-1 rounded">{item.badge}</span>
            )}
          </Link>
        ))}
      </nav>
    </aside>
  );
}
