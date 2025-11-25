import { useState, useEffect } from 'react';

/**
 * ZoomSlider Component
 * 
 * Provides a slider control for adjusting image zoom level
 * with visual feedback and keyboard support.
 * 
 * @param {Object} props
 * @param {number} props.value - Current zoom value (1.0 - 3.0)
 * @param {number} props.min - Minimum zoom value (default: 1.0)
 * @param {number} props.max - Maximum zoom value (default: 3.0)
 * @param {number} props.step - Zoom step increment (default: 0.1)
 * @param {Function} props.onChange - Callback when zoom changes
 */
export default function ZoomSlider({ 
  value, 
  min = 1.0, 
  max = 3.0, 
  step = 0.1, 
  onChange 
}) {
  const [localValue, setLocalValue] = useState(value);

  // Sync with external value changes
  useEffect(() => {
    setLocalValue(value);
  }, [value]);

  const handleChange = (e) => {
    const newValue = parseFloat(e.target.value);
    setLocalValue(newValue);
    onChange(newValue);
  };

  const handleKeyDown = (e) => {
    if (e.key === 'ArrowLeft' || e.key === 'ArrowDown') {
      e.preventDefault();
      const newValue = Math.max(min, localValue - step);
      setLocalValue(newValue);
      onChange(newValue);
    } else if (e.key === 'ArrowRight' || e.key === 'ArrowUp') {
      e.preventDefault();
      const newValue = Math.min(max, localValue + step);
      setLocalValue(newValue);
      onChange(newValue);
    }
  };

  // Calculate percentage for visual feedback
  const percentage = ((localValue - min) / (max - min)) * 100;

  return (
    <div className="w-full">
      <div className="flex items-center justify-between mb-2">
        <label className="text-sm font-medium text-gray-700">
          Zoom
        </label>
        <span className="text-sm font-semibold text-blue-600">
          {localValue.toFixed(1)}x
        </span>
      </div>
      
      <div className="relative">
        {/* Track background */}
        <div className="h-2 bg-gray-200 rounded-full overflow-hidden">
          {/* Progress fill */}
          <div 
            className="h-full bg-blue-600 transition-all duration-100"
            style={{ width: `${percentage}%` }}
          />
        </div>
        
        {/* Slider input */}
        <input
          type="range"
          min={min}
          max={max}
          step={step}
          value={localValue}
          onChange={handleChange}
          onKeyDown={handleKeyDown}
          className="absolute top-0 left-0 w-full h-2 opacity-0 cursor-pointer"
          aria-label="Zoom level"
          aria-valuemin={min}
          aria-valuemax={max}
          aria-valuenow={localValue}
          aria-valuetext={`${localValue.toFixed(1)}x zoom`}
        />
        
        {/* Custom thumb */}
        <div 
          className="absolute top-1/2 -translate-y-1/2 w-5 h-5 bg-white border-2 border-blue-600 rounded-full shadow-md pointer-events-none transition-all duration-100"
          style={{ left: `calc(${percentage}% - 10px)` }}
        />
      </div>
      
      {/* Min/Max labels */}
      <div className="flex justify-between mt-1">
        <span className="text-xs text-gray-500">{min.toFixed(1)}x</span>
        <span className="text-xs text-gray-500">{max.toFixed(1)}x</span>
      </div>
    </div>
  );
}
