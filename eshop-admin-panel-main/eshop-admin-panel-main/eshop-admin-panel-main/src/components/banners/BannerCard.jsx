export default function BannerCard({ banner, onEdit, onDelete }) {
  return (
    <div className="bg-white rounded-lg shadow-md overflow-hidden hover:shadow-lg transition-shadow">
      <div className="relative h-48 bg-gray-200">
        <img
          src={banner.imageUrl}
          alt={banner.title}
          className="w-full h-full object-cover"
          onError={(e) => {
            e.target.src = 'https://via.placeholder.com/400x200?text=Imagem+Indisponível';
          }}
        />
        <div className="absolute top-2 right-2">
          <span
            className={`px-3 py-1 rounded-full text-xs font-semibold ${
              banner.isActive
                ? 'bg-green-500 text-white'
                : 'bg-gray-500 text-white'
            }`}
          >
            {banner.isActive ? 'Ativo' : 'Inativo'}
          </span>
        </div>
      </div>

      <div className="p-4">
        <h3 className="font-bold text-lg mb-2 truncate">{banner.title}</h3>
        <p className="text-gray-600 text-sm mb-3 line-clamp-2">
          {banner.description}
        </p>

        <div className="flex items-center justify-between text-sm text-gray-500 mb-4">
          <span>Ordem: {banner.order}</span>
          {banner.link && (
            <a
              href={banner.link}
              target="_blank"
              rel="noopener noreferrer"
              className="text-blue-500 hover:underline"
            >
              🔗 Link
            </a>
          )}
        </div>

        <div className="flex gap-2">
          <button
            onClick={onEdit}
            className="flex-1 bg-blue-500 text-white py-2 rounded hover:bg-blue-600 transition"
          >
            ✏️ Editar
          </button>
          <button
            onClick={onDelete}
            className="flex-1 bg-red-500 text-white py-2 rounded hover:bg-red-600 transition"
          >
            🗑️ Deletar
          </button>
        </div>
      </div>
    </div>
  );
}
