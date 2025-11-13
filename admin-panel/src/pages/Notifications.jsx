export default function Notifications() {
  return (
    <div>
      <div className="flex justify-between items-center mb-6">
        <h1 className="text-3xl font-bold">Notificações</h1>
        <button className="bg-blue-600 text-white px-4 py-2 rounded hover:bg-blue-700">
          + Nova Notificação
        </button>
      </div>

      <div className="bg-white rounded-lg shadow-md p-6">
        <div className="text-center py-12">
          <div className="text-6xl mb-4">🔔</div>
          <h3 className="text-xl font-semibold mb-2">Módulo de Notificações</h3>
          <p className="text-gray-600 mb-4">
            Em breve você poderá enviar notificações push para os clientes aqui.
          </p>
          <div className="bg-green-50 border border-green-200 rounded-lg p-4 max-w-md mx-auto">
            <p className="text-sm text-green-800">
              <strong>Funcionalidades planejadas:</strong>
              <br />
              • Enviar notificações push
              <br />
              • Agendar notificações
              <br />
              • Segmentar por público
              <br />
              • Histórico de envios
              <br />
              • Estatísticas de abertura
            </p>
          </div>
        </div>
      </div>
    </div>
  );
}
