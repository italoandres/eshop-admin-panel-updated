# Implementation Plan

- [x] 1. Integrate Cloudinary upload into storeSettingsController



  - Modify `updateStoreSettings` method to detect and upload base64 logos
  - Modify `uploadLogo` method to detect and upload base64 logos
  - Add import statement for Cloudinary service functions
  - Add error handling for upload failures
  - Add console logging with emoji prefixes matching banner controller pattern
  - _Requirements: 1.1, 1.2, 1.3, 1.4, 1.5, 5.1, 5.2, 5.4_



- [ ] 1.1 Write property test for base64 detection and upload
  - **Property 1: Base64 Detection and Upload**

  - **Validates: Requirements 1.1, 1.2, 1.3**



- [ ] 1.2 Write property test for URL passthrough
  - **Property 2: URL Passthrough**
  - **Validates: Requirements 1.5**

- [x] 2. Customize Cloudinary transformations for logos


  - Update cloudinaryService to accept custom transformation parameters OR


  - Document that logos use default transformations (currently 1200x600)
  - Ideally: modify uploadImage to accept optional transformation config
  - Apply logo-specific transformations: 800x800 limit, quality auto:good, format auto
  - _Requirements: 2.1, 2.2, 2.3, 2.4_

- [ ] 2.1 Write property test for logo optimization
  - **Property 5: Logo Optimization Application**


  - **Validates: Requirements 2.1, 2.2, 2.3**


- [ ] 3. Implement comprehensive error handling
  - Add validation for missing logoUrl in uploadLogo endpoint
  - Add try-catch blocks around Cloudinary upload calls

  - Ensure database is not modified when upload fails
  - Return appropriate HTTP status codes (400 for validation, 500 for server errors)



  - Log all errors with descriptive messages
  - _Requirements: 4.1, 4.2, 4.3, 4.4_

- [ ] 3.1 Write property test for upload failure handling
  - **Property 3: Upload Failure Handling**
  - **Validates: Requirements 1.4, 4.2**



- [ ] 3.2 Write property test for settings preservation on failure
  - **Property 4: Settings Preservation on Logo Failure**
  - **Validates: Requirements 3.3**

- [ ] 3.3 Write property test for error response format
  - **Property 6: Consistent Error Response Format**
  - **Validates: Requirements 4.1, 4.2, 4.3, 4.4**


- [ ] 4. Test integration locally
  - Start backend server locally
  - Test updateStoreSettings with base64 logo using Postman/curl
  - Test uploadLogo endpoint with base64 logo
  - Test with regular URL (should pass through unchanged)



  - Verify Cloudinary dashboard shows uploaded logos in eshop/logos folder
  - Verify MongoDB contains Cloudinary URLs
  - _Requirements: All_

- [ ] 5. Deploy to Render and verify
  - Copy updated storeSettingsController.js to eshop-backend-temp repository
  - Copy updated cloudinaryService.js if modified
  - Commit with message: "feat: Add Cloudinary integration for store logo uploads"
  - Push to GitHub main branch
  - Wait for Render auto-deploy
  - Check Render logs for successful deployment
  - Test production endpoint with base64 logo
  - Verify logo appears in Cloudinary dashboard
  - _Requirements: All_

- [ ] 6. Write integration tests for complete workflows
  - Test complete logo upload flow (create store → upload logo → verify URL)
  - Test logo update flow (existing logo → new logo → verify replacement)
  - Test mixed settings update (name + colors + logo simultaneously)
  - _Requirements: All_

- [ ] 7. Checkpoint - Ensure all tests pass
  - Ensure all tests pass, ask the user if questions arise.
