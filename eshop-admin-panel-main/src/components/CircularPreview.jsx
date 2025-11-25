import { useRef, useEffect, useState } from 'react';

/**
 * CircularPreview Component
 * 
 * Renders a circular preview of an image with zoom and position controls.
 * Supports drag-to-reposition functionality.
 * 
 * @param {Object} props
 * @param {string} props.imageData - Base64 or URL of the image
 * @param {number} props.zoom - Zoom level (1.0 - 3.0)
 * @param {{ x: number, y: number }} props.position - Image position offset
 * @param {number} props.size - Diameter of the circular preview in pixels
 * @param {Function} props.onDragStart - Callback when drag starts
 * @param {Function} props.onDragMove - Callback during drag with delta
 * @param {Function} props.onDragEnd - Callback when drag ends
 */
export default function CircularPreview({
  imageData,
  zoom,
  position,
  size = 300,
  onDragStart,
  onDragMove,
  onDragEnd,
}) {
  const canvasRef = useRef(null);
  const containerRef = useRef(null);
  const [isDragging, setIsDragging] = useState(false);
  const [dragStart, setDragStart] = useState({ x: 0, y: 0 });
  const imageRef = useRef(null);

  // Load image when imageData changes
  useEffect(() => {
    if (!imageData) {
      console.log('CircularPreview: No imageData, clearing canvas');
      // Clear canvas when no image
      const canvas = canvasRef.current;
      if (canvas) {
        const ctx = canvas.getContext('2d');
        if (ctx) {
          ctx.clearRect(0, 0, canvas.width, canvas.height);
        }
      }
      imageRef.current = null;
      return;
    }

    console.log('CircularPreview: Loading image from base64');
    console.log('  - Length:', imageData.length);
    console.log('  - Starts with:', imageData.substring(0, 50));
    console.log('  - Canvas ref exists:', !!canvasRef.current);
    
    const img = new Image();
    img.onload = () => {
      console.log('CircularPreview: Image loaded successfully');
      console.log('  - Dimensions:', img.width, 'x', img.height);
      console.log('  - Natural dimensions:', img.naturalWidth, 'x', img.naturalHeight);
      imageRef.current = img;
      drawCanvas();
    };
    img.onerror = (e) => {
      console.error('CircularPreview: Failed to load image', e);
      console.error('  - Image src length:', imageData.length);
      console.error('  - Image src preview:', imageData.substring(0, 100));
      imageRef.current = null;
    };
    img.src = imageData;
  }, [imageData]);

  // Redraw canvas when zoom or position changes
  useEffect(() => {
    console.log('CircularPreview: useEffect triggered - zoom:', zoom, 'position:', position);
    drawCanvas();
  }, [zoom, position, size, imageData]);

  const drawCanvas = () => {
    console.log('CircularPreview: drawCanvas called');
    const canvas = canvasRef.current;
    if (!canvas) {
      console.log('  - No canvas ref');
      return;
    }

    const ctx = canvas.getContext('2d');
    if (!ctx) {
      console.error('  - Failed to get canvas context');
      return;
    }

    console.log('  - Canvas context obtained');
    console.log('  - Size:', size);
    console.log('  - Zoom:', zoom);
    console.log('  - Position:', position);
    console.log('  - Has image:', !!imageRef.current);

    // Set canvas size (2x for retina displays)
    const scale = 2;
    canvas.width = size * scale;
    canvas.height = size * scale;
    canvas.style.width = `${size}px`;
    canvas.style.height = `${size}px`;

    // Scale context for retina
    ctx.scale(scale, scale);

    // Clear canvas with white background
    ctx.fillStyle = '#ffffff';
    ctx.fillRect(0, 0, size, size);

    // If no image, just draw empty circle
    if (!imageRef.current) {
      console.log('  - Drawing empty circle (no image)');
      ctx.beginPath();
      ctx.arc(size / 2, size / 2, size / 2, 0, Math.PI * 2);
      ctx.strokeStyle = '#d1d5db';
      ctx.lineWidth = 2;
      ctx.stroke();
      return;
    }

    try {
      const img = imageRef.current;
      console.log('  - Drawing image:', img.width, 'x', img.height);

      // Calculate scaled dimensions
      const scaledWidth = img.width * zoom;
      const scaledHeight = img.height * zoom;

      // Calculate draw position (center the image, then apply offset)
      const drawX = (size - scaledWidth) / 2 + position.x;
      const drawY = (size - scaledHeight) / 2 + position.y;

      console.log('  - Scaled dimensions:', scaledWidth, 'x', scaledHeight);
      console.log('  - Draw position:', drawX, ',', drawY);

      // Create circular clipping path
      ctx.save();
      ctx.beginPath();
      ctx.arc(size / 2, size / 2, size / 2, 0, Math.PI * 2);
      ctx.closePath();
      ctx.clip();

      // Draw the image
      ctx.drawImage(img, drawX, drawY, scaledWidth, scaledHeight);
      console.log('  - Image drawn successfully');

      ctx.restore();

      // Draw circular border
      ctx.beginPath();
      ctx.arc(size / 2, size / 2, size / 2, 0, Math.PI * 2);
      ctx.strokeStyle = '#d1d5db'; // gray-300
      ctx.lineWidth = 2;
      ctx.stroke();
    } catch (error) {
      console.error('  - Error rendering canvas:', error);
    }
  };

  const handleMouseDown = (e) => {
    e.preventDefault();
    setIsDragging(true);
    setDragStart({ x: e.clientX, y: e.clientY });
    if (onDragStart) {
      onDragStart(e);
    }
  };

  const handleMouseMove = (e) => {
    if (!isDragging) return;

    const deltaX = e.clientX - dragStart.x;
    const deltaY = e.clientY - dragStart.y;

    setDragStart({ x: e.clientX, y: e.clientY });

    if (onDragMove) {
      onDragMove({ deltaX, deltaY });
    }
  };

  const handleMouseUp = (e) => {
    if (!isDragging) return;

    setIsDragging(false);
    if (onDragEnd) {
      onDragEnd(e);
    }
  };

  const handleTouchStart = (e) => {
    if (e.touches.length !== 1) return;
    
    const touch = e.touches[0];
    setIsDragging(true);
    setDragStart({ x: touch.clientX, y: touch.clientY });
    if (onDragStart) {
      onDragStart(e);
    }
  };

  const handleTouchMove = (e) => {
    if (!isDragging || e.touches.length !== 1) return;

    e.preventDefault();
    const touch = e.touches[0];
    const deltaX = touch.clientX - dragStart.x;
    const deltaY = touch.clientY - dragStart.y;

    setDragStart({ x: touch.clientX, y: touch.clientY });

    if (onDragMove) {
      onDragMove({ deltaX, deltaY });
    }
  };

  const handleTouchEnd = (e) => {
    if (!isDragging) return;

    setIsDragging(false);
    if (onDragEnd) {
      onDragEnd(e);
    }
  };

  // Add global mouse move and up listeners when dragging
  useEffect(() => {
    if (isDragging) {
      document.addEventListener('mousemove', handleMouseMove);
      document.addEventListener('mouseup', handleMouseUp);
      document.addEventListener('touchmove', handleTouchMove, { passive: false });
      document.addEventListener('touchend', handleTouchEnd);

      return () => {
        document.removeEventListener('mousemove', handleMouseMove);
        document.removeEventListener('mouseup', handleMouseUp);
        document.removeEventListener('touchmove', handleTouchMove);
        document.removeEventListener('touchend', handleTouchEnd);
      };
    }
  }, [isDragging, dragStart]);

  return (
    <div
      ref={containerRef}
      className="relative inline-block"
      style={{ width: size, height: size }}
    >
      <canvas
        ref={canvasRef}
        className={`rounded-full ${isDragging ? 'cursor-grabbing' : 'cursor-grab'}`}
        onMouseDown={handleMouseDown}
        onTouchStart={handleTouchStart}
        style={{
          touchAction: 'none',
          userSelect: 'none',
        }}
      />
      
      {!imageData && (
        <div className="absolute inset-0 flex items-center justify-center bg-gray-100 rounded-full border-2 border-dashed border-gray-300">
          <div className="text-center text-gray-400">
            <svg
              className="mx-auto h-12 w-12 mb-2"
              fill="none"
              stroke="currentColor"
              viewBox="0 0 24 24"
            >
              <path
                strokeLinecap="round"
                strokeLinejoin="round"
                strokeWidth={2}
                d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z"
              />
            </svg>
            <p className="text-sm">Selecione uma imagem</p>
          </div>
        </div>
      )}
    </div>
  );
}
