export default function Products() {
  return (
    <div>
      <div className="flex justify-between items-center mb-6">
        <h1 className="text-3xl font-bold">Produtos</h1>
        <button className="bg-blue-600 text-white px-4 py-2 rounded hover:bg-blue-700">
          + Novo Produto
        </button>
      </div>

      <div className="bg-white rounded-lg shadow-md p-6">
        <div className="text-center py-12">
          <div className="text-6xl mb-4">📦</div>
          <h3 className="text-xl font-semibold mb-2">Módulo de Produtos</h3>
          <p className="text-gray-600 mb-4">
            Em breve você poderá gerenciar todos os produtos da sua loja aqui.
          </p>
          <div className="bg-blue-50 border border-blue-200 rounded-lg p-4 max-w-md mx-auto">
            <p className="text-sm text-blue-800">
              <strong>Funcionalidades planejadas:</strong>
              <br />
              • Adicionar novos produtos
              <br />
              • Editar informações e preços
              <br />
              • Gerenciar estoque
              <br />
              • Upload de imagens
              <br />
              • Categorias e tags
            </p>
          </div>
        </div>
      </div>
    </div>
  );
}
