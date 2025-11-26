# Design Document

## Overview

This feature transforms the logo upload experience in the admin panel from a simple file input to an interactive, modern editor with real-time circular preview and positioning controls. The design follows patterns established by social media platforms (Facebook, LinkedIn) for profile picture editing, providing an intuitive and professional user experience.

The implementation will create a new React component (`LogoEditor`) that handles image manipulation, preview rendering, and coordinate/zoom data management. The component will integrate seamlessly with the existing Settings page and maintain compatibility with the current Cloudinary backend infrastructure.

## Architecture

### Component Structure

```
Settings.jsx (existing)
├── LogoEditorModal (new)
│   ├── CircularPreview (new)
│   ├── ZoomSlider (new)
│   ├── ImageCanvas (new)
│   └── EditorControls (new)
└── LogoPreviewCard (modified)
```

### Data Flow

1. **Upload Flow**:
   - User selects image file → File loaded into memory
   - Image displayed in modal editor → User adjusts zoom/position
   - User clicks save → Canvas generates cropped circular image as base64
   - Base64 sent to backend → Cloudinary processes and stores
   - Settings updated with new logo URL

2. **State Management**:
   ```javascript
   {
     isEditorOpen: boolean,
     originalImage: File | null,
     imageData: string (base64),
     zoom: number (1.0 - 3.0),
     position: { x: number, y: number },
     croppedImage: string (base64)
   }
   ```

## Components and Interfaces

### 1. LogoEditorModal Component

**Purpose**: Main modal container for the logo editing experience

**Props**:
```typescript
interface LogoEditorModalProps {
  isOpen: boolean;
  onClose: () => void;
  onSave: (croppedImageBase64: string) => Promise<void>;
  initialImage?: string;
}
```

**State**:
```typescript
interface EditorState {
  imageData: string;
  zoom: number;
  position: { x: number; y: number };
  isDragging: boolean;
  dragStart: { x: number; y: number };
}
```

**Key Methods**:
- `handleImageLoad()`: Initialize image in canvas
- `handleZoomChange(value: number)`: Update zoom level
- `handleMouseDown/Move/Up()`: Handle drag interactions
- `generateCroppedImage()`: Create final circular crop
- `handleSave()`: Export and upload cropped image

### 2. CircularPreview Component

**Purpose**: Renders the circular viewport with the positioned/zoomed image

**Props**:
```typescript
interface CircularPreviewProps {
  imageData: string;
  zoom: number;
  position: { x: number; y: number };
  size: number; // diameter in pixels
  onDragStart: (e: MouseEvent) => void;
  onDragMove: (e: MouseEvent) => void;
  onDragEnd: (e: MouseEvent) => void;
}
```

**Implementation Details**:
- Uses HTML5 Canvas for rendering
- Applies circular clipping path
- Handles mouse/touch events for dragging
- Renders at 2x resolution for retina displays

### 3. ZoomSlider Component

**Purpose**: Provides zoom control interface

**Props**:
```typescript
interface ZoomSliderProps {
  value: number;
  min: number;
  max: number;
  step: number;
  onChange: (value: number) => void;
}
```

**Features**:
- Range: 1.0x to 3.0x
- Step: 0.1
- Visual feedback with percentage display
- Keyboard support (arrow keys)

### 4. ImageCanvas Utility

**Purpose**: Helper class for image manipulation operations

**Methods**:
```typescript
class ImageCanvas {
  static loadImage(file: File): Promise<HTMLImageElement>
  static cropToCircle(
    image: HTMLImageElement,
    zoom: number,
    position: { x: number; y: number },
    outputSize: number
  ): string // returns base64
  static calculateInitialFit(
    imageWidth: number,
    imageHeight: number,
    containerSize: number
  ): { zoom: number; position: { x: number; y: number } }
}
```

## Data Models

### EditorConfiguration

```typescript
interface EditorConfiguration {
  previewSize: number; // 300px
  outputSize: number; // 800px (for Cloudinary)
  minZoom: number; // 1.0
  maxZoom: number; // 3.0
  zoomStep: number; // 0.1
  allowedFormats: string[]; // ['image/png', 'image/jpeg', 'image/jpg']
  maxFileSize: number; // 5MB
}
```

### CropData

```typescript
interface CropData {
  zoom: number;
  position: { x: number; y: number };
  originalDimensions: { width: number; height: number };
  croppedDimensions: { width: number; height: number };
}
```

## Correctness Properties

*A property is a characteristic or behavior that should hold true across all valid executions of a system-essentially, a formal statement about what the system should do. Properties serve as the bridge between human-readable specifications and machine-verifiable correctness guarantees.*

### Property 1: Image aspect ratio preservation

*For any* uploaded image, when displayed in the editor, the aspect ratio SHALL remain unchanged regardless of zoom or position adjustments.

**Validates: Requirements 1.2**

### Property 2: Circular crop consistency

*For any* image with applied zoom and position settings, generating the cropped output multiple times SHALL produce identical results.

**Validates: Requirements 4.4**

### Property 3: Zoom bounds enforcement

*For any* zoom adjustment, the resulting zoom value SHALL be within the range [1.0, 3.0] inclusive.

**Validates: Requirements 2.3**

### Property 4: Position constraint satisfaction

*For any* drag operation, the image position SHALL be constrained such that the circular preview area is always covered by the image.

**Validates: Requirements 3.3**

### Property 5: File format validation

*For any* file upload attempt, the system SHALL accept only files with MIME types in the allowed formats list.

**Validates: Requirements 4.1**

### Property 6: State preservation on cancel

*For any* editor session, clicking cancel SHALL restore the previous logo state without applying any changes.

**Validates: Requirements 7.3**

### Property 7: Output size consistency

*For any* saved logo, the generated image SHALL have dimensions of 800x800 pixels regardless of the original image size.

**Validates: Requirements 4.4**

### Property 8: Real-time preview synchronization

*For any* zoom or position change, the preview SHALL update within 16ms (60fps) to maintain smooth interaction.

**Validates: Requirements 2.2, 3.2**

## Error Handling

### Client-Side Errors

1. **Invalid File Type**
   - Detection: Check MIME type on file selection
   - Response: Show error message, prevent editor from opening
   - Message: "Por favor, selecione uma imagem PNG ou JPG"

2. **File Too Large**
   - Detection: Check file.size > 5MB
   - Response: Show error message, prevent editor from opening
   - Message: "Imagem muito grande. Máximo 5MB"

3. **Image Load Failure**
   - Detection: Image.onerror event
   - Response: Show error message, close editor
   - Message: "Erro ao carregar imagem. Tente outro arquivo"

4. **Canvas Rendering Error**
   - Detection: Try-catch around canvas operations
   - Response: Log error, show fallback message
   - Message: "Erro ao processar imagem. Tente novamente"

### Server-Side Errors

1. **Upload Failure**
   - Detection: API response status !== 200
   - Response: Keep editor open, show error message
   - Message: Display server error message or "Erro ao fazer upload"
   - Recovery: Allow user to retry

2. **Cloudinary Error**
   - Detection: Backend returns Cloudinary error
   - Response: Show error message, keep editor open
   - Message: "Erro ao processar imagem no servidor"
   - Recovery: Allow user to retry or cancel

### Edge Cases

1. **Very Small Images** (< 100x100px)
   - Behavior: Allow upload, may appear pixelated
   - Warning: Show quality warning in editor

2. **Very Large Images** (> 4000x4000px)
   - Behavior: Resize client-side before processing
   - Note: Maintain aspect ratio during resize

3. **Network Interruption During Upload**
   - Behavior: Show timeout error after 30s
   - Recovery: Allow retry with same cropped image

## Testing Strategy

### Unit Tests

1. **ImageCanvas Utility Tests**
   - Test `loadImage()` with valid/invalid files
   - Test `cropToCircle()` output dimensions
   - Test `calculateInitialFit()` for various aspect ratios
   - Test circular clipping path generation

2. **Component Tests**
   - Test LogoEditorModal open/close behavior
   - Test ZoomSlider value changes
   - Test CircularPreview rendering
   - Test drag interaction handlers

3. **Integration Tests**
   - Test complete upload flow (select → edit → save)
   - Test cancel flow (select → edit → cancel)
   - Test error scenarios (invalid file, upload failure)
   - Test Settings page integration

### Property-Based Tests

Property-based tests will use `fast-check` library to verify correctness properties across randomized inputs.

**Configuration**: Each property test will run 100 iterations with randomized inputs.

**Test 1: Aspect Ratio Preservation**
```javascript
// Feature: logo-editor-preview, Property 1: Image aspect ratio preservation
fc.assert(
  fc.property(
    fc.integer({ min: 100, max: 4000 }), // width
    fc.integer({ min: 100, max: 4000 }), // height
    fc.float({ min: 1.0, max: 3.0 }), // zoom
    (width, height, zoom) => {
      const originalRatio = width / height;
      const displayed = calculateDisplayDimensions(width, height, zoom);
      const displayedRatio = displayed.width / displayed.height;
      return Math.abs(originalRatio - displayedRatio) < 0.001;
    }
  ),
  { numRuns: 100 }
);
```

**Test 2: Zoom Bounds**
```javascript
// Feature: logo-editor-preview, Property 3: Zoom bounds enforcement
fc.assert(
  fc.property(
    fc.float({ min: -10, max: 10 }), // arbitrary zoom input
    (inputZoom) => {
      const clampedZoom = clampZoom(inputZoom);
      return clampedZoom >= 1.0 && clampedZoom <= 3.0;
    }
  ),
  { numRuns: 100 }
);
```

**Test 3: Output Size Consistency**
```javascript
// Feature: logo-editor-preview, Property 7: Output size consistency
fc.assert(
  fc.property(
    fc.integer({ min: 100, max: 4000 }), // original width
    fc.integer({ min: 100, max: 4000 }), // original height
    fc.float({ min: 1.0, max: 3.0 }), // zoom
    fc.record({ x: fc.float(), y: fc.float() }), // position
    async (width, height, zoom, position) => {
      const mockImage = createMockImage(width, height);
      const cropped = await ImageCanvas.cropToCircle(mockImage, zoom, position, 800);
      const img = await loadImageFromBase64(cropped);
      return img.width === 800 && img.height === 800;
    }
  ),
  { numRuns: 100 }
);
```

**Test 4: Circular Crop Consistency**
```javascript
// Feature: logo-editor-preview, Property 2: Circular crop consistency
fc.assert(
  fc.property(
    fc.integer({ min: 100, max: 2000 }),
    fc.integer({ min: 100, max: 2000 }),
    fc.float({ min: 1.0, max: 3.0 }),
    fc.record({ x: fc.float({ min: -100, max: 100 }), y: fc.float({ min: -100, max: 100 }) }),
    async (width, height, zoom, position) => {
      const mockImage = createMockImage(width, height);
      const crop1 = await ImageCanvas.cropToCircle(mockImage, zoom, position, 800);
      const crop2 = await ImageCanvas.cropToCircle(mockImage, zoom, position, 800);
      return crop1 === crop2;
    }
  ),
  { numRuns: 100 }
);
```

**Test 5: Position Constraints**
```javascript
// Feature: logo-editor-preview, Property 4: Position constraint satisfaction
fc.assert(
  fc.property(
    fc.integer({ min: 100, max: 2000 }),
    fc.integer({ min: 100, max: 2000 }),
    fc.float({ min: 1.0, max: 3.0 }),
    fc.record({ x: fc.float({ min: -500, max: 500 }), y: fc.float({ min: -500, max: 500 }) }),
    (width, height, zoom, attemptedPosition) => {
      const constrainedPos = constrainPosition(attemptedPosition, width, height, zoom, 300);
      const coverage = calculateCoverage(constrainedPos, width, height, zoom, 300);
      return coverage >= 1.0; // Circle is fully covered
    }
  ),
  { numRuns: 100 }
);
```

### Manual Testing Checklist

- [ ] Upload various image sizes (small, medium, large)
- [ ] Upload various aspect ratios (square, portrait, landscape)
- [ ] Test zoom slider at min, max, and middle values
- [ ] Test dragging image to all corners
- [ ] Test save with different zoom/position combinations
- [ ] Test cancel without saving
- [ ] Test with slow network (throttling)
- [ ] Test on different browsers (Chrome, Firefox, Safari)
- [ ] Test on mobile devices (responsive behavior)
- [ ] Verify Cloudinary receives correct image data

## Implementation Notes

### Technology Stack

- **React**: Component framework (already in use)
- **HTML5 Canvas**: Image manipulation and rendering
- **Tailwind CSS**: Styling (already in use)
- **Axios**: API communication (already in use)

### Performance Considerations

1. **Image Loading**: Use `createObjectURL` for instant preview
2. **Canvas Rendering**: Debounce drag events to maintain 60fps
3. **Memory Management**: Revoke object URLs when component unmounts
4. **Large Images**: Resize to max 2000px before loading into canvas

### Accessibility

1. **Keyboard Navigation**: Support Tab, Enter, Escape keys
2. **Screen Readers**: Add ARIA labels to controls
3. **Focus Management**: Trap focus within modal when open
4. **Visual Feedback**: Clear hover/focus states on all interactive elements

### Browser Compatibility

- **Minimum**: Chrome 90+, Firefox 88+, Safari 14+, Edge 90+
- **Canvas API**: Widely supported, no polyfills needed
- **File API**: Widely supported, no polyfills needed
- **Drag Events**: Fallback to click-based positioning if needed

## UI/UX Specifications

### Modal Layout

```
┌─────────────────────────────────────────┐
│  Editar Logo                        [X] │
├─────────────────────────────────────────┤
│                                         │
│         ┌─────────────────┐             │
│         │                 │             │
│         │   ╭─────────╮   │             │
│         │   │         │   │             │
│         │   │  IMAGE  │   │  ← Circular │
│         │   │         │   │    Preview  │
│         │   ╰─────────╯   │             │
│         │                 │             │
│         └─────────────────┘             │
│                                         │
│  Zoom: [━━━━━●━━━━━] 1.5x              │
│                                         │
│  [Cancelar]           [Salvar Logo]    │
│                                         │
└─────────────────────────────────────────┘
```

### Color Scheme

- **Modal Background**: `bg-white`
- **Overlay**: `bg-black/50`
- **Preview Border**: `border-gray-300`
- **Slider Track**: `bg-gray-200`
- **Slider Thumb**: `bg-blue-600`
- **Save Button**: `bg-blue-600 hover:bg-blue-700`
- **Cancel Button**: `bg-gray-200 hover:bg-gray-300`

### Dimensions

- **Modal Width**: 600px (max-width on mobile: 95vw)
- **Preview Circle**: 300px diameter
- **Output Image**: 800x800px
- **Slider Width**: 280px

### Animations

- **Modal Open/Close**: Fade + scale (200ms ease-out)
- **Zoom Changes**: Smooth transition (100ms)
- **Drag**: No transition (immediate feedback)
- **Button Hover**: Color transition (150ms)

## Integration with Existing Code

### Changes to Settings.jsx

1. **Remove**:
   - "Tamanho recomendado" text
   - "Posicionamento no App" radio buttons
   - Direct file input handling

2. **Add**:
   - Import LogoEditorModal component
   - State for editor open/close
   - Handler to open editor on file selection
   - Handler to receive cropped image from editor

3. **Modify**:
   - Logo preview to show circular version
   - Upload button to open editor instead of direct upload

### Backend Compatibility

No backend changes required. The editor will:
- Generate base64 image (same as current implementation)
- Send to existing `/store-settings/:storeId/logo` endpoint
- Cloudinary will process as usual with 800x800 transformation

## Deployment Considerations

1. **Build Size**: New component adds ~15KB gzipped
2. **Browser Testing**: Test on target browsers before deploy
3. **Rollback Plan**: Keep old Settings.jsx as backup
4. **Feature Flag**: Consider adding flag to toggle new editor
5. **Monitoring**: Track upload success rate and error types

## Future Enhancements

1. **Rotation**: Add image rotation control
2. **Filters**: Add brightness/contrast adjustments
3. **Multiple Shapes**: Support square, rounded square options
4. **Undo/Redo**: Add history for zoom/position changes
5. **Presets**: Quick zoom presets (fit, fill, custom)
6. **Grid Overlay**: Show alignment grid in editor
7. **Touch Gestures**: Pinch-to-zoom on mobile devices
