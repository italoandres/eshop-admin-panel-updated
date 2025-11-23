export default function Orders() {
  return (
    <div>
      <h1 className="text-3xl font-bold mb-6">Pedidos</h1>

      <div className="bg-white rounded-lg shadow-md p-6">
        <div className="text-center py-12">
          <div className="text-6xl mb-4">🛒</div>
          <h3 className="text-xl font-semibold mb-2">Módulo de Pedidos</h3>
          <p className="text-gray-600 mb-4">
            Em breve você poderá acompanhar todos os pedidos dos clientes aqui.
          </p>
          <div className="bg-orange-50 border border-orange-200 rounded-lg p-4 max-w-md mx-auto">
            <p className="text-sm text-orange-800">
              <strong>Funcionalidades planejadas:</strong>
              <br />
              • Visualizar todos os pedidos
              <br />
              • Atualizar status de entrega
              <br />
              • Filtrar por status
              <br />
              • Detalhes do pedido
              <br />
              • Histórico de pedidos
            </p>
          </div>
        </div>
      </div>
    </div>
  );
}
