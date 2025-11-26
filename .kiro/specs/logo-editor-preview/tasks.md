# Implementation Plan

- [x] 1. Create ImageCanvas utility class



  - Create `eshop-admin-panel-main/src/utils/imageCanvas.js` with image manipulation functions
  - Implement `loadImage()` method to load File into HTMLImageElement
  - Implement `cropToCircle()` method to generate circular cropped image as base64
  - Implement `calculateInitialFit()` method to determine initial zoom and position
  - Implement helper functions for coordinate calculations
  - _Requirements: 4.1, 4.2, 4.3_



- [ ] 1.1 Write property test for ImageCanvas utility
  - **Property 1: Image aspect ratio preservation**

  - **Validates: Requirements 1.2**

- [x] 1.2 Write property test for circular crop consistency

  - **Property 2: Circular crop consistency**



  - **Validates: Requirements 4.4**

- [ ] 1.3 Write property test for output size
  - **Property 7: Output size consistency**
  - **Validates: Requirements 4.4**

- [x] 2. Create ZoomSlider component







  - Create `eshop-admin-panel-main/src/components/ZoomSlider.jsx`
  - Implement range slider with min (1.0), max (3.0), step (0.1)
  - Add visual feedback showing current zoom percentage
  - Add keyboard support for arrow keys
  - Style with Tailwind CSS matching admin panel design

  - _Requirements: 2.1, 2.2, 2.3_

- [x] 2.1 Write property test for zoom bounds




  - **Property 3: Zoom bounds enforcement**

  - **Validates: Requirements 2.3**





- [ ] 3. Create CircularPreview component
  - Create `eshop-admin-panel-main/src/components/CircularPreview.jsx`
  - Implement canvas-based circular preview with 300px diameter
  - Add circular clipping path for image rendering
  - Implement mouse drag handlers (onMouseDown, onMouseMove, onMouseUp)

  - Add touch event support for mobile devices

  - Render at 2x resolution for retina displays
  - _Requirements: 1.1, 1.2, 3.1, 3.2_





- [ ] 3.1 Write property test for position constraints
  - **Property 4: Position constraint satisfaction**




  - **Validates: Requirements 3.3**



- [x] 3.2 Write property test for real-time preview performance



  - **Property 8: Real-time preview synchronization**
  - **Validates: Requirements 2.2, 3.2**

- [ ] 4. Create LogoEditorModal component
  - Create `eshop-admin-panel-main/src/components/LogoEditorModal.jsx`

  - Implement modal container with overlay and close button
  - Add state management for zoom, position, isDragging
  - Integrate CircularPreview component
  - Integrate ZoomSlider component



  - Implement drag interaction logic
  - Add save and cancel buttons
  - Implement `generateCroppedImage()` using ImageCanvas utility
  - Add loading state during save operation
  - _Requirements: 1.1, 2.1, 3.1, 6.1, 6.2, 7.1, 7.2_

- [ ] 4.1 Write property test for state preservation on cancel
  - **Property 6: State preservation on cancel**


  - **Validates: Requirements 7.3**

- [ ] 5. Update Settings.jsx to integrate LogoEditorModal
  - Import LogoEditorModal component
  - Add state for `isEditorOpen` and `selectedImageFile`
  - Modify `handleLogoChange()` to open editor instead of direct preview
  - Remove "Tamanho recomendado" text from UI
  - Remove "Posicionamento no App" radio buttons section
  - Update logo preview to show circular version



  - Implement `handleEditorSave()` to receive cropped image from modal
  - Update `handleUploadLogo()` to use cropped image from editor
  - _Requirements: 5.1, 5.2, 5.3, 6.3, 6.4_

- [ ] 5.1 Write property test for file format validation
  - **Property 5: File format validation**
  - **Validates: Requirements 4.1**

- [ ] 6. Add error handling and validation
  - Add file type validation (PNG, JPG only) in Settings.jsx
  - Add file size validation (max 5MB) in Settings.jsx
  - Add error handling for image load failures in ImageCanvas
  - Add error handling for canvas rendering errors in CircularPreview
  - Add error handling for upload failures in LogoEditorModal
  - Display user-friendly error messages in Portuguese
  - Add loading states and disabled button states
  - _Requirements: 6.5_

- [x] 6.1 Write unit tests for error scenarios



  - Test invalid file type handling
  - Test file size limit enforcement
  - Test image load failure handling
  - Test upload failure recovery
  - _Requirements: 6.5_

- [ ] 7. Style and polish UI
  - Apply Tailwind CSS styling to all new components
  - Add modal open/close animations (fade + scale, 200ms)
  - Add smooth transitions for zoom changes (100ms)
  - Add hover states for buttons
  - Ensure responsive design for mobile devices
  - Add focus management and keyboard navigation
  - Add ARIA labels for accessibility
  - Test on different screen sizes
  - _Requirements: 5.3, 5.4_

- [ ] 8. Test complete integration
  - Test full upload flow: select image → edit → save
  - Test cancel flow: select image → edit → cancel
  - Test with various image sizes (small, medium, large)
  - Test with various aspect ratios (square, portrait, landscape)
  - Test zoom at min, max, and middle values
  - Test dragging to all corners of preview
  - Verify Cloudinary receives correct 800x800 image
  - Test error scenarios (invalid file, network failure)
  - _Requirements: All_

- [ ] 9. Checkpoint - Ensure all tests pass
  - Ensure all tests pass, ask the user if questions arise.
