/**
 * ImageCanvas Utility
 * 
 * Provides image manipulation functions for the logo editor.
 * Handles loading, cropping, and transforming images for circular preview.
 */

/**
 * Load an image file into an HTMLImageElement
 * @param {File} file - The image file to load
 * @returns {Promise<HTMLImageElement>} - Loaded image element
 */
export const loadImage = (file) => {
  return new Promise((resolve, reject) => {
    if (!file) {
      reject(new Error('No file provided'));
      return;
    }

    const reader = new FileReader();
    
    reader.onload = (e) => {
      const img = new Image();
      
      img.onload = () => {
        resolve(img);
      };
      
      img.onerror = () => {
        reject(new Error('Failed to load image'));
      };
      
      img.src = e.target.result;
    };
    
    reader.onerror = () => {
      reject(new Error('Failed to read file'));
    };
    
    reader.readAsDataURL(file);
  });
};

/**
 * Load an image from a base64 string
 * @param {string} base64 - Base64 encoded image
 * @returns {Promise<HTMLImageElement>} - Loaded image element
 */
export const loadImageFromBase64 = (base64) => {
  return new Promise((resolve, reject) => {
    const img = new Image();
    
    img.onload = () => {
      resolve(img);
    };
    
    img.onerror = () => {
      reject(new Error('Failed to load image from base64'));
    };
    
    img.src = base64;
  });
};

/**
 * Calculate initial zoom and position to fit image in container
 * @param {number} imageWidth - Original image width
 * @param {number} imageHeight - Original image height
 * @param {number} containerSize - Container diameter in pixels
 * @returns {{ zoom: number, position: { x: number, y: number } }}
 */
export const calculateInitialFit = (imageWidth, imageHeight, containerSize) => {
  // Calculate zoom to fit the image in the circular container
  // We want the smaller dimension to fit the container
  const imageAspect = imageWidth / imageHeight;
  
  let zoom;
  if (imageAspect >= 1) {
    // Landscape or square - fit by height
    zoom = containerSize / imageHeight;
  } else {
    // Portrait - fit by width
    zoom = containerSize / imageWidth;
  }
  
  // Ensure minimum zoom of 1.0
  zoom = Math.max(1.0, zoom);
  
  // Center the image
  const position = { x: 0, y: 0 };
  
  return { zoom, position };
};

/**
 * Constrain position to keep image covering the circular area
 * @param {{ x: number, y: number }} position - Attempted position
 * @param {number} imageWidth - Image width
 * @param {number} imageHeight - Image height
 * @param {number} zoom - Current zoom level
 * @param {number} containerSize - Container diameter
 * @returns {{ x: number, y: number }} - Constrained position
 */
export const constrainPosition = (position, imageWidth, imageHeight, zoom, containerSize) => {
  const scaledWidth = imageWidth * zoom;
  const scaledHeight = imageHeight * zoom;
  
  // Calculate the radius of the circular container
  const radius = containerSize / 2;
  
  // Maximum allowed offset from center
  // This ensures the circle is always covered by the image
  const maxOffsetX = Math.max(0, (scaledWidth - containerSize) / 2);
  const maxOffsetY = Math.max(0, (scaledHeight - containerSize) / 2);
  
  // Constrain position
  const constrainedX = Math.max(-maxOffsetX, Math.min(maxOffsetX, position.x));
  const constrainedY = Math.max(-maxOffsetY, Math.min(maxOffsetY, position.y));
  
  return { x: constrainedX, y: constrainedY };
};

/**
 * Calculate coverage percentage (for testing)
 * @param {{ x: number, y: number }} position - Image position
 * @param {number} imageWidth - Image width
 * @param {number} imageHeight - Image height
 * @param {number} zoom - Zoom level
 * @param {number} containerSize - Container diameter
 * @returns {number} - Coverage ratio (>= 1.0 means fully covered)
 */
export const calculateCoverage = (position, imageWidth, imageHeight, zoom, containerSize) => {
  const scaledWidth = imageWidth * zoom;
  const scaledHeight = imageHeight * zoom;
  const radius = containerSize / 2;
  
  // Calculate the bounds of the image relative to container center
  // Position is the offset from center, so we need to account for that
  const left = -scaledWidth / 2 + position.x;
  const right = scaledWidth / 2 + position.x;
  const top = -scaledHeight / 2 + position.y;
  const bottom = scaledHeight / 2 + position.y;
  
  // Check if all edges of the circle are covered
  // The circle extends from -radius to +radius in both directions
  const leftCovered = left <= -radius;
  const rightCovered = right >= radius;
  const topCovered = top <= -radius;
  const bottomCovered = bottom >= radius;
  
  // If all edges are covered, return 1.0 (fully covered)
  if (leftCovered && rightCovered && topCovered && bottomCovered) {
    return 1.0;
  }
  
  // Calculate partial coverage
  const horizontalCoverage = Math.min(1, (right - left) / containerSize);
  const verticalCoverage = Math.min(1, (bottom - top) / containerSize);
  
  return Math.min(horizontalCoverage, verticalCoverage);
};

/**
 * Crop image to circular shape with zoom and position
 * @param {HTMLImageElement} image - Source image
 * @param {number} zoom - Zoom level (1.0 - 3.0)
 * @param {{ x: number, y: number }} position - Image position offset
 * @param {number} outputSize - Output diameter in pixels
 * @returns {string} - Base64 encoded circular image
 */
export const cropToCircle = (image, zoom, position, outputSize) => {
  try {
    // Create canvas at 2x resolution for retina displays
    const canvas = document.createElement('canvas');
    const scale = 2;
    canvas.width = outputSize * scale;
    canvas.height = outputSize * scale;
    
    const ctx = canvas.getContext('2d');
    
    // Scale context for retina
    ctx.scale(scale, scale);
    
    // Calculate scaled dimensions
    const scaledWidth = image.width * zoom;
    const scaledHeight = image.height * zoom;
    
    // Calculate draw position (center the image, then apply offset)
    const drawX = (outputSize - scaledWidth) / 2 + position.x;
    const drawY = (outputSize - scaledHeight) / 2 + position.y;
    
    // Create circular clipping path
    ctx.beginPath();
    ctx.arc(outputSize / 2, outputSize / 2, outputSize / 2, 0, Math.PI * 2);
    ctx.closePath();
    ctx.clip();
    
    // Draw the image
    ctx.drawImage(image, drawX, drawY, scaledWidth, scaledHeight);
    
    // Convert to base64
    return canvas.toDataURL('image/png', 0.95);
  } catch (error) {
    console.error('Error cropping image:', error);
    throw new Error('Failed to crop image');
  }
};

/**
 * Calculate display dimensions maintaining aspect ratio
 * @param {number} width - Original width
 * @param {number} height - Original height
 * @param {number} zoom - Zoom level
 * @returns {{ width: number, height: number }}
 */
export const calculateDisplayDimensions = (width, height, zoom) => {
  // Handle invalid zoom values
  const validZoom = isFinite(zoom) && !isNaN(zoom) ? zoom : 1.0;
  
  return {
    width: width * validZoom,
    height: height * validZoom
  };
};

/**
 * Clamp zoom value to valid range
 * @param {number} zoom - Input zoom value
 * @param {number} min - Minimum zoom (default 1.0)
 * @param {number} max - Maximum zoom (default 3.0)
 * @returns {number} - Clamped zoom value
 */
export const clampZoom = (zoom, min = 1.0, max = 3.0) => {
  // Handle NaN, Infinity, and other invalid values
  if (!isFinite(zoom) || isNaN(zoom)) {
    return min;
  }
  return Math.max(min, Math.min(max, zoom));
};

/**
 * Create a mock image for testing
 * @param {number} width - Image width
 * @param {number} height - Image height
 * @param {string} color - Fill color (default: '#cccccc')
 * @returns {Promise<HTMLImageElement>}
 */
export const createMockImage = (width, height, color = '#cccccc') => {
  return new Promise((resolve) => {
    const canvas = document.createElement('canvas');
    canvas.width = width;
    canvas.height = height;
    
    const ctx = canvas.getContext('2d');
    ctx.fillStyle = color;
    ctx.fillRect(0, 0, width, height);
    
    // Add some pattern to make it visible
    ctx.fillStyle = '#999999';
    ctx.fillRect(width / 4, height / 4, width / 2, height / 2);
    
    const img = new Image();
    img.onload = () => resolve(img);
    img.src = canvas.toDataURL();
  });
};

export default {
  loadImage,
  loadImageFromBase64,
  calculateInitialFit,
  constrainPosition,
  calculateCoverage,
  cropToCircle,
  calculateDisplayDimensions,
  clampZoom,
  createMockImage
};
