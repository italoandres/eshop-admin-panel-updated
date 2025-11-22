export default function Reviews() {
  return (
    <div>
      <h1 className="text-3xl font-bold mb-6">Avaliações</h1>

      <div className="bg-white rounded-lg shadow-md p-6">
        <div className="text-center py-12">
          <div className="text-6xl mb-4">⭐</div>
          <h3 className="text-xl font-semibold mb-2">Módulo de Avaliações</h3>
          <p className="text-gray-600 mb-4">
            Em breve você poderá gerenciar todas as avaliações dos produtos aqui.
          </p>
          <div className="bg-yellow-50 border border-yellow-200 rounded-lg p-4 max-w-md mx-auto">
            <p className="text-sm text-yellow-800">
              <strong>Funcionalidades planejadas:</strong>
              <br />
              • Visualizar todas as avaliações
              <br />
              • Moderar comentários
              <br />
              • Responder avaliações
              <br />
              • Filtrar por estrelas
              <br />
              • Estatísticas de satisfação
            </p>
          </div>
        </div>
      </div>
    </div>
  );
}
