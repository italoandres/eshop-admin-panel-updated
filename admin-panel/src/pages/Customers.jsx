export default function Customers() {
  return (
    <div>
      <h1 className="text-3xl font-bold mb-6">Clientes</h1>

      <div className="bg-white rounded-lg shadow-md p-6">
        <div className="text-center py-12">
          <div className="text-6xl mb-4">👥</div>
          <h3 className="text-xl font-semibold mb-2">Módulo de Clientes</h3>
          <p className="text-gray-600 mb-4">
            Em breve você poderá gerenciar todos os clientes da sua loja aqui.
          </p>
          <div className="bg-purple-50 border border-purple-200 rounded-lg p-4 max-w-md mx-auto">
            <p className="text-sm text-purple-800">
              <strong>Funcionalidades planejadas:</strong>
              <br />
              • Visualizar lista de clientes
              <br />
              • Detalhes do cliente
              <br />
              • Histórico de compras
              <br />
              • Endereços cadastrados
              <br />
              • Estatísticas por cliente
            </p>
          </div>
        </div>
      </div>
    </div>
  );
}
