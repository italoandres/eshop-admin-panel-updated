import React, { useState, useEffect } from 'react';
import { Plus, Edit2, Trash2, Power, TrendingUp } from 'lucide-react';
import axios from 'axios';
import RuleForm from '../components/discounts/RuleForm';
import API_BASE_URL from '../config/api';

const API_URL = `${API_BASE_URL}/discount-rules`;

const ProgressiveDiscounts = () => {
  const [rules, setRules] = useState([]);
  const [loading, setLoading] = useState(true);
  const [filter, setFilter] = useState('all');
  const [showForm, setShowForm] = useState(false);
  const [editingRule, setEditingRule] = useState(null);

  useEffect(() => {
    fetchRules();
  }, [filter]);

  const fetchRules = async () => {
    try {
      setLoading(true);
      const params = filter !== 'all' ? { status: filter } : {};
      const response = await axios.get(API_URL, { params });
      setRules(response.data.rules || []);
    } catch (error) {
      console.error('Erro ao buscar regras:', error);
      alert('Erro ao carregar promoções');
    } finally {
      setLoading(false);
    }
  };

  const handleDelete = async (id) => {
    if (!window.confirm('Tem certeza que deseja deletar esta promoção?')) return;
    
    try {
      await axios.delete(`${API_URL}/${id}`);
      alert('Promoção deletada com sucesso!');
      fetchRules();
    } catch (error) {
      console.error('Erro ao deletar:', error);
      alert('Erro ao deletar promoção');
    }
  };

  const handleToggle = async (id) => {
    try {
      await axios.patch(`${API_URL}/${id}/toggle`);
      fetchRules();
    } catch (error) {
      console.error('Erro ao alternar:', error);
      alert('Erro ao alternar status');
    }
  };

  return (
    <div className="p-6">
      {/* Header */}
      <div className="flex justify-between items-center mb-6">
        <div>
          <h1 className="text-3xl font-bold text-gray-800">Descontos Progressivos</h1>
          <p className="text-gray-600 mt-1">Gerencie promoções que aumentam com a quantidade</p>
        </div>
        <button
          onClick={() => {
            setEditingRule(null);
            setShowForm(true);
          }}
          className="bg-blue-600 hover:bg-blue-700 text-white px-6 py-3 rounded-lg flex items-center gap-2 transition-colors"
        >
          <Plus size={20} />
          Nova Promoção
        </button>
      </div>

      {/* Filters */}
      <div className="bg-white rounded-lg shadow-sm p-4 mb-6">
        <div className="flex gap-4">
          <button
            onClick={() => setFilter('all')}
            className={`px-4 py-2 rounded-lg transition-colors ${
              filter === 'all'
                ? 'bg-blue-600 text-white'
                : 'bg-gray-100 text-gray-700 hover:bg-gray-200'
            }`}
          >
            Todas
          </button>
          <button
            onClick={() => setFilter('active')}
            className={`px-4 py-2 rounded-lg transition-colors ${
              filter === 'active'
                ? 'bg-green-600 text-white'
                : 'bg-gray-100 text-gray-700 hover:bg-gray-200'
            }`}
          >
            Ativas
          </button>
          <button
            onClick={() => setFilter('inactive')}
            className={`px-4 py-2 rounded-lg transition-colors ${
              filter === 'inactive'
                ? 'bg-red-600 text-white'
                : 'bg-gray-100 text-gray-700 hover:bg-gray-200'
            }`}
          >
            Inativas
          </button>
        </div>
      </div>

      {/* Loading */}
      {loading && (
        <div className="text-center py-12">
          <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-600 mx-auto"></div>
          <p className="text-gray-600 mt-4">Carregando...</p>
        </div>
      )}

      {/* Rules List */}
      {!loading && rules.length === 0 && (
        <div className="bg-white rounded-lg shadow-sm p-12 text-center">
          <TrendingUp size={48} className="mx-auto text-gray-400 mb-4" />
          <h3 className="text-xl font-semibold text-gray-700 mb-2">
            Nenhuma promoção encontrada
          </h3>
          <p className="text-gray-600 mb-6">
            Crie sua primeira promoção de desconto progressivo!
          </p>
          <button
            onClick={() => setShowForm(true)}
            className="bg-blue-600 hover:bg-blue-700 text-white px-6 py-3 rounded-lg inline-flex items-center gap-2"
          >
            <Plus size={20} />
            Criar Promoção
          </button>
        </div>
      )}

      {!loading && rules.length > 0 && (
        <div className="grid gap-4">
          {rules.map((rule) => (
            <RuleCard
              key={rule._id}
              rule={rule}
              onEdit={() => {
                setEditingRule(rule);
                setShowForm(true);
              }}
              onDelete={() => handleDelete(rule._id)}
              onToggle={() => handleToggle(rule._id)}
            />
          ))}
        </div>
      )}

      {/* Form Modal */}
      {showForm && (
        <RuleForm
          rule={editingRule}
          onClose={() => {
            setShowForm(false);
            setEditingRule(null);
          }}
          onSuccess={() => {
            setShowForm(false);
            setEditingRule(null);
            fetchRules();
          }}
        />
      )}
    </div>
  );
};

// Rule Card Component
const RuleCard = ({ rule, onEdit, onDelete, onToggle }) => {
  return (
    <div className="bg-white rounded-lg shadow-sm p-6 hover:shadow-md transition-shadow">
      <div className="flex justify-between items-start">
        <div className="flex-1">
          <div className="flex items-center gap-3 mb-2">
            <h3 className="text-xl font-semibold text-gray-800">{rule.name}</h3>
            <span
              className={`px-3 py-1 rounded-full text-sm font-medium ${
                rule.isActive
                  ? 'bg-green-100 text-green-800'
                  : 'bg-red-100 text-red-800'
              }`}
            >
              {rule.isActive ? '🟢 Ativa' : '🔴 Inativa'}
            </span>
          </div>
          
          {rule.description && (
            <p className="text-gray-600 mb-4">{rule.description}</p>
          )}

          <div className="flex items-center gap-2 text-sm text-gray-500 mb-4">
            <span>Produto ID: {rule.productId}</span>
            <span>•</span>
            <span>{rule.tiers.length} níveis</span>
          </div>

          {/* Tiers Preview */}
          <div className="flex flex-wrap gap-2">
            {rule.tiers.map((tier, index) => (
              <div
                key={index}
                className="bg-gradient-to-r from-blue-50 to-blue-100 px-4 py-2 rounded-lg border border-blue-200"
              >
                <span className="font-semibold text-blue-900">
                  {tier.quantity}x
                </span>
                <span className="text-blue-700 mx-1">→</span>
                <span className="font-bold text-blue-900">
                  -{tier.discountPercent}%
                </span>
              </div>
            ))}
          </div>
        </div>

        {/* Actions */}
        <div className="flex gap-2 ml-4">
          <button
            onClick={onToggle}
            className="p-2 hover:bg-gray-100 rounded-lg transition-colors"
            title={rule.isActive ? 'Desativar' : 'Ativar'}
          >
            <Power size={20} className={rule.isActive ? 'text-green-600' : 'text-gray-400'} />
          </button>
          <button
            onClick={onEdit}
            className="p-2 hover:bg-blue-50 rounded-lg transition-colors"
            title="Editar"
          >
            <Edit2 size={20} className="text-blue-600" />
          </button>
          <button
            onClick={onDelete}
            className="p-2 hover:bg-red-50 rounded-lg transition-colors"
            title="Deletar"
          >
            <Trash2 size={20} className="text-red-600" />
          </button>
        </div>
      </div>
    </div>
  );
};

// Continua no próximo append...
export default ProgressiveDiscounts;
