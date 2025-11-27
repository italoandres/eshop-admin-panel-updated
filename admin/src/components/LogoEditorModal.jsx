import { useState, useEffect } from 'react';
import CircularPreview from './CircularPreview';
import ZoomSlider from './ZoomSlider';
import { 
  loadImage, 
  calculateInitialFit, 
  constrainPosition, 
  cropToCircle 
} from '../utils/imageCanvas';

/**
 * LogoEditorModal Component
 * 
 * Main modal for editing logo with zoom and position controls.
 * Integrates CircularPreview and ZoomSlider components.
 * 
 * @param {Object} props
 * @param {boolean} props.isOpen - Whether the modal is open
 * @param {Function} props.onClose - Callback to close the modal
 * @param {Function} props.onSave - Callback with cropped image base64
 * @param {File} props.imageFile - The image file to edit
 */
export default function LogoEditorModal({ isOpen, onClose, onSave, imageFile }) {
  const [imageData, setImageData] = useState(null);
  const [originalImage, setOriginalImage] = useState(null);
  const [zoom, setZoom] = useState(1.0);
  const [position, setPosition] = useState({ x: 0, y: 0 });
  const [isLoading, setIsLoading] = useState(false);
  const [error, setError] = useState(null);

  const PREVIEW_SIZE = 300;
  const OUTPUT_SIZE = 800;

  // Load image when file changes
  useEffect(() => {
    if (!imageFile || !isOpen) {
      console.log('LogoEditor: No file or modal closed');
      return;
    }

    console.log('LogoEditor: Loading image file:', imageFile.name, 'Size:', imageFile.size, 'Type:', imageFile.type);
    
    // Limpar estado anterior antes de carregar nova imagem
    setImageData(null);
    setOriginalImage(null);
    setIsLoading(true);
    setError(null);

    loadImage(imageFile)
      .then((img) => {
        console.log('LogoEditor: Image loaded successfully', img.width, 'x', img.height);
        setOriginalImage(img);
        
        // Create base64 for preview
        const canvas = document.createElement('canvas');
        canvas.width = img.width;
        canvas.height = img.height;
        const ctx = canvas.getContext('2d');
        ctx.drawImage(img, 0, 0);
        const base64 = canvas.toDataURL('image/png');
        console.log('LogoEditor: Base64 created, length:', base64.length, 'starts with:', base64.substring(0, 50));
        setImageData(base64);

        // Calculate initial fit
        const initialFit = calculateInitialFit(img.width, img.height, PREVIEW_SIZE);
        console.log('LogoEditor: Initial fit calculated:', initialFit);
        console.log('LogoEditor: SETTING ZOOM TO:', initialFit.zoom);
        console.log('LogoEditor: Current zoom before set:', zoom);
        setZoom(initialFit.zoom);
        setPosition(initialFit.position);
        console.log('LogoEditor: setZoom and setPosition called');
        
        setIsLoading(false);
      })
      .catch((err) => {
        console.error('LogoEditor: Failed to load image:', err);
        setError('Erro ao carregar imagem. Tente outro arquivo.');
        setIsLoading(false);
      });
  }, [imageFile, isOpen]);

  // Reset state when modal closes
  useEffect(() => {
    if (!isOpen) {
      setImageData(null);
      setOriginalImage(null);
      setZoom(1.0);
      setPosition({ x: 0, y: 0 });
      setError(null);
    }
  }, [isOpen]);

  const handleZoomChange = (newZoom) => {
    console.log('LogoEditor: handleZoomChange called, newZoom:', newZoom, 'current zoom:', zoom);
    setZoom(newZoom);
    
    // Recalculate constrained position with new zoom
    if (originalImage) {
      const constrained = constrainPosition(
        position,
        originalImage.width,
        originalImage.height,
        newZoom,
        PREVIEW_SIZE
      );
      setPosition(constrained);
    }
  };

  const handleDragMove = ({ deltaX, deltaY }) => {
    if (!originalImage) return;

    console.log('LogoEditor: handleDragMove called', { deltaX, deltaY, currentPosition: position });

    const newPosition = {
      x: position.x + deltaX,
      y: position.y + deltaY,
    };

    // Constrain position to keep circle covered
    const constrained = constrainPosition(
      newPosition,
      originalImage.width,
      originalImage.height,
      zoom,
      PREVIEW_SIZE
    );

    console.log('LogoEditor: New position', { newPosition, constrained });
    setPosition(constrained);
  };

  const handleSave = async () => {
    if (!originalImage) return;

    setIsLoading(true);
    setError(null);

    try {
      // Generate cropped circular image
      const croppedBase64 = cropToCircle(
        originalImage,
        zoom,
        position,
        OUTPUT_SIZE,
        PREVIEW_SIZE  // Pass preview size for proper scaling
      );

      // Call parent callback with cropped image
      await onSave(croppedBase64);
      
      // Close modal on success
      onClose();
    } catch (err) {
      console.error('Failed to save logo:', err);
      setError('Erro ao processar imagem. Tente novamente.');
    } finally {
      setIsLoading(false);
    }
  };

  const handleCancel = () => {
    onClose();
  };

  const handleKeyDown = (e) => {
    if (e.key === 'Escape') {
      handleCancel();
    }
  };

  // Focus management - focus first button when modal opens
  useEffect(() => {
    if (isOpen && !isLoading) {
      // Small delay to ensure modal is rendered
      const timer = setTimeout(() => {
        const firstButton = document.querySelector('[aria-label="Cancelar edição"]');
        if (firstButton) {
          firstButton.focus();
        }
      }, 100);
      return () => clearTimeout(timer);
    }
  }, [isOpen, isLoading]);

  if (!isOpen) return null;

  return (
    <div
      className="fixed inset-0 z-50 flex items-center justify-center bg-black/50 backdrop-blur-sm animate-fadeIn"
      onClick={handleCancel}
      onKeyDown={handleKeyDown}
      role="dialog"
      aria-modal="true"
      aria-labelledby="logo-editor-title"
    >
      <div
        className="bg-white rounded-lg shadow-xl max-w-2xl w-full mx-4 p-4 sm:p-6 transform transition-all animate-scaleIn max-h-[90vh] overflow-y-auto"
        onClick={(e) => e.stopPropagation()}
      >
        {/* Header */}
        <div className="flex items-center justify-between mb-6">
          <h2 id="logo-editor-title" className="text-2xl font-bold text-gray-800">
            Editar Logo
          </h2>
          <button
            onClick={handleCancel}
            className="text-gray-400 hover:text-gray-600 transition"
            aria-label="Fechar"
          >
            <svg
              className="w-6 h-6"
              fill="none"
              stroke="currentColor"
              viewBox="0 0 24 24"
            >
              <path
                strokeLinecap="round"
                strokeLinejoin="round"
                strokeWidth={2}
                d="M6 18L18 6M6 6l12 12"
              />
            </svg>
          </button>
        </div>

        {/* Error Message */}
        {error && (
          <div className="mb-4 p-4 bg-red-100 border border-red-300 text-red-700 rounded-lg">
            {error}
          </div>
        )}

        {/* Content */}
        <div className="space-y-6">
          {/* Preview */}
          <div className="flex justify-center">
            {isLoading ? (
              <div className="flex items-center justify-center" style={{ width: PREVIEW_SIZE, height: PREVIEW_SIZE }}>
                <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-600"></div>
              </div>
            ) : (
              <CircularPreview
                imageData={imageData}
                zoom={zoom}
                position={position}
                size={PREVIEW_SIZE}
                onDragMove={handleDragMove}
              />
            )}
          </div>

          {/* Zoom Control */}
          {imageData && !isLoading && (
            <div className="px-4">
              <ZoomSlider
                value={zoom}
                min={0.05}
                max={3.0}
                step={0.01}
                onChange={handleZoomChange}
              />
            </div>
          )}

          {/* Instructions */}
          {imageData && !isLoading && (
            <div className="text-center text-sm text-gray-600">
              <p>Arraste a imagem para posicionar</p>
              <p>Use o controle de zoom para ajustar o tamanho</p>
            </div>
          )}

          {/* Actions */}
          <div className="flex gap-3 justify-end pt-4 border-t">
            <button
              onClick={handleCancel}
              disabled={isLoading}
              className="px-6 py-2 bg-gray-200 text-gray-700 rounded-lg hover:bg-gray-300 focus:outline-none focus:ring-2 focus:ring-gray-400 focus:ring-offset-2 transition-all duration-150 disabled:opacity-50 disabled:cursor-not-allowed"
              aria-label="Cancelar edição"
            >
              Cancelar
            </button>
            <button
              onClick={handleSave}
              disabled={isLoading || !imageData}
              className="px-6 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-offset-2 transition-all duration-150 disabled:opacity-50 disabled:cursor-not-allowed flex items-center gap-2"
              aria-label="Salvar logo editada"
            >
              {isLoading ? (
                <>
                  <div className="animate-spin rounded-full h-4 w-4 border-b-2 border-white"></div>
                  Processando...
                </>
              ) : (
                'Salvar Logo'
              )}
            </button>
          </div>
        </div>
      </div>
    </div>
  );
}
