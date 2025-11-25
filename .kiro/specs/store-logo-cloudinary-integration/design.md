# Design Document

## Overview

This design document outlines the integration of Cloudinary image upload functionality into the store logo management system. The implementation will follow the proven pattern established in the banner controller, ensuring consistency across the codebase. The system will automatically detect base64-encoded images and upload them to Cloudinary, replacing the base64 data with optimized Cloudinary URLs before storing in MongoDB.

## Architecture

### Current Architecture
The store settings system currently has three main components:
1. **StoreSettings Model** - MongoDB schema with logoUrl field (stores string URLs)
2. **StoreSettingsController** - Three endpoints: getStoreSettings, updateStoreSettings, uploadLogo
3. **Cloudinary Service** - Shared service with upload, delete, and detection utilities

### Modified Architecture
The integration will enhance the existing controller methods to intercept base64 images and process them through Cloudinary before database storage:

```
Client Request (base64 logo)
    ↓
StoreSettingsController
    ↓
isBase64Image() detection
    ↓
uploadImage() to Cloudinary
    ↓
Cloudinary URL returned
    ↓
MongoDB (logoUrl = Cloudinary URL)
    ↓
Response to Client
```

## Components and Interfaces

### 1. StoreSettingsController (Modified)

**File:** `backend/controllers/storeSettingsController.js`

**Modified Methods:**

#### `updateStoreSettings(req, res)`
- **Input:** `req.params.storeId`, `req.body` (including optional `logoUrl`)
- **Output:** JSON response with updated settings
- **Behavior:** 
  - Detects if `logoUrl` is base64
  - Uploads to Cloudinary if base64 detected
  - Replaces base64 with Cloudinary URL
  - Updates or creates store settings
  - Returns updated settings object

#### `uploadLogo(req, res)`
- **Input:** `req.params.storeId`, `req.body.logoUrl`
- **Output:** JSON response with updated settings
- **Behavior:**
  - Validates logoUrl presence
  - Detects if logoUrl is base64
  - Uploads to Cloudinary if base64 detected
  - Updates logoUrl in database
  - Returns success message with settings

### 2. Cloudinary Service (Existing)

**File:** `backend/services/cloudinaryService.js`

**Used Functions:**
- `isBase64Image(str)` - Detects if string is base64 image data URI
- `uploadImage(imageData, folder)` - Uploads image to Cloudinary with transformations

**Configuration:**
- Folder: `eshop/logos`
- Transformations: Will be customized for logo dimensions

### 3. StoreSettings Model (Unchanged)

**File:** `backend/models/StoreSettings.js`

**Relevant Fields:**
- `logoUrl` (String) - Stores the logo URL (Cloudinary or external)
- `logoPosition` (String) - Logo position preference

## Data Models

### Request Payload (updateStoreSettings)
```javascript
{
  "storeName": "My Store",
  "logoUrl": "data:image/png;base64,iVBORw0KG...", // Base64 or URL
  "primaryColor": "#FF6B6B",
  "secondaryColor": "#4ECDC4",
  // ... other fields
}
```

### Request Payload (uploadLogo)
```javascript
{
  "logoUrl": "data:image/png;base64,iVBORw0KG..." // Base64 or URL
}
```

### Response Format
```javascript
{
  "success": true,
  "data": {
    "_id": "...",
    "storeId": "store123",
    "storeName": "My Store",
    "logoUrl": "https://res.cloudinary.com/.../eshop/logos/abc123.png",
    "primaryColor": "#FF6B6B",
    // ... other fields
  },
  "message": "Logo atualizada com sucesso" // Only for uploadLogo
}
```

### Error Response Format
```javascript
{
  "success": false,
  "message": "Erro ao fazer upload da logo",
  "error": "Detailed error message"
}
```

## Correctness Properties

*A property is a characteristic or behavior that should hold true across all valid executions of a system-essentially, a formal statement about what the system should do. Properties serve as the bridge between human-readable specifications and machine-verifiable correctness guarantees.*

### Property 1: Base64 Detection and Upload
*For any* store settings update request containing a base64-encoded logoUrl, the system should detect the base64 format and upload the image to Cloudinary, resulting in the stored logoUrl being a Cloudinary URL (not base64).
**Validates: Requirements 1.1, 1.2, 1.3**

### Property 2: URL Passthrough
*For any* store settings update request containing a non-base64 logoUrl (regular URL), the system should store the URL directly without attempting Cloudinary upload.
**Validates: Requirements 1.5**

### Property 3: Upload Failure Handling
*For any* logo upload that fails at the Cloudinary service level, the system should return an error response with status 500 and should not modify the existing logoUrl in the database.
**Validates: Requirements 1.4, 4.2**

### Property 4: Settings Preservation on Logo Failure
*For any* store settings update where the logo upload fails, all other settings fields should remain unchanged from their previous values.
**Validates: Requirements 3.3**

### Property 5: Logo Optimization Application
*For any* successful logo upload to Cloudinary, the returned URL should reference an image with applied transformations (dimension limits, quality optimization, format conversion).
**Validates: Requirements 2.1, 2.2, 2.3**

### Property 6: Consistent Error Response Format
*For any* error condition (validation failure, upload failure, or unexpected error), the system should return a JSON response with `success: false` and an error message.
**Validates: Requirements 4.1, 4.2, 4.3, 4.4**

## Error Handling

### Error Categories

1. **Validation Errors (400)**
   - Missing logoUrl in uploadLogo request
   - Invalid storeId format
   - Response: `{ success: false, message: "Validation error description" }`

2. **Cloudinary Upload Errors (500)**
   - Network failure to Cloudinary
   - Invalid image format
   - Cloudinary API errors
   - Response: `{ success: false, message: "Erro ao fazer upload da logo", error: details }`
   - Behavior: Log error, do not modify existing logoUrl

3. **Database Errors (500)**
   - MongoDB connection issues
   - Schema validation failures
   - Response: `{ success: false, message: "Erro ao atualizar configurações", error: details }`

4. **Unexpected Errors (500)**
   - Any uncaught exceptions
   - Response: Generic error message with details

### Error Logging Strategy

All errors will be logged to console with descriptive prefixes:
- `❌` - Critical errors (upload failures, database errors)
- `⚠️` - Warnings (fallback scenarios)
- `✅` - Success confirmations
- `📤` - Upload operations in progress

Example:
```javascript
console.log('📤 Upload de logo para Cloudinary...');
console.log('✅ Logo uploaded:', logoUrl);
console.error('❌ Erro no upload do logo:', error.message);
```

## Testing Strategy

### Unit Tests

Unit tests will verify specific scenarios and edge cases:

1. **Base64 Detection Test**
   - Input: Valid base64 image string
   - Expected: `isBase64Image()` returns true

2. **URL Detection Test**
   - Input: Regular URL string
   - Expected: `isBase64Image()` returns false

3. **Empty Logo Handling Test**
   - Input: Update request without logoUrl field
   - Expected: Existing logoUrl preserved

4. **Invalid Base64 Test**
   - Input: Malformed base64 string
   - Expected: Error response, no database modification

### Property-Based Tests

Property-based tests will verify universal behaviors across many inputs using a PBT library. We will use **fast-check** for Node.js property-based testing.

**Configuration:** Each property test will run a minimum of 100 iterations.

**Test Tagging Format:** Each test will include a comment with the format:
`// Feature: store-logo-cloudinary-integration, Property {number}: {property_text}`

1. **Property Test 1: Base64 Upload Transformation**
   - Generate: Random valid base64 image strings
   - Action: Call updateStoreSettings with base64 logoUrl
   - Assert: Returned logoUrl starts with "https://res.cloudinary.com/"
   - Assert: Returned logoUrl contains "/eshop/logos/"

2. **Property Test 2: URL Passthrough Invariant**
   - Generate: Random valid HTTP/HTTPS URLs
   - Action: Call updateStoreSettings with URL logoUrl
   - Assert: Returned logoUrl equals input logoUrl (no transformation)

3. **Property Test 3: Settings Isolation on Logo Failure**
   - Generate: Random store settings with invalid base64 logo
   - Setup: Create store with initial settings
   - Action: Attempt update with failing logo
   - Assert: All non-logo fields remain unchanged

4. **Property Test 4: Error Response Structure**
   - Generate: Random error-inducing inputs (missing fields, invalid data)
   - Action: Call controller methods with invalid inputs
   - Assert: Response has `success: false` field
   - Assert: Response has `message` field with string value

### Integration Tests

Integration tests will verify end-to-end workflows:

1. **Complete Logo Upload Flow**
   - Create store settings
   - Upload base64 logo
   - Verify Cloudinary URL in database
   - Verify image accessible at Cloudinary URL

2. **Logo Update Flow**
   - Create store with initial logo
   - Update with new base64 logo
   - Verify old logo replaced
   - Verify new Cloudinary URL stored

3. **Mixed Settings Update**
   - Update store name, colors, and logo simultaneously
   - Verify all fields updated correctly
   - Verify logo uploaded to Cloudinary

## Implementation Notes

### Code Consistency

The implementation will mirror the banner controller pattern:

**Banner Controller Pattern:**
```javascript
if (isBase64Image(imageUrl)) {
  console.log('📤 Base64 detectado! Upload para Cloudinary...');
  try {
    const uploadResult = await uploadImage(imageUrl, 'eshop/banners');
    imageUrl = uploadResult.url;
    console.log('✅ Cloudinary upload OK:', imageUrl);
  } catch (uploadError) {
    console.error('⚠️ Cloudinary falhou:', uploadError.message);
    // Handle error
  }
}
```

**Logo Controller Pattern (to implement):**
```javascript
if (logoUrl && isBase64Image(logoUrl)) {
  console.log('📤 Upload de logo para Cloudinary...');
  try {
    const uploadResult = await uploadImage(logoUrl, 'eshop/logos');
    logoUrl = uploadResult.url;
    console.log('✅ Logo uploaded:', logoUrl);
  } catch (error) {
    console.error('❌ Erro no upload do logo:', error.message);
    return res.status(500).json({ 
      success: false,
      message: 'Erro ao fazer upload da logo', 
      error: error.message 
    });
  }
}
```

### Cloudinary Transformations for Logos

Logos require different transformations than banners:

```javascript
// Logo-specific transformations
{
  folder: 'eshop/logos',
  transformation: [
    { width: 800, height: 800, crop: 'limit' }, // Smaller than banners
    { quality: 'auto:good' },
    { fetch_format: 'auto' }
  ]
}
```

Note: The cloudinaryService.js will need to accept custom transformations or we'll use the default and document the difference.

### Deployment Considerations

1. **Environment Variables:** Ensure Cloudinary credentials are set in Render
2. **Testing:** Test locally before pushing to GitHub
3. **Deployment Flow:**
   - Update local backend code
   - Copy to `eshop-backend-temp` repository
   - Commit and push to GitHub
   - Render auto-deploys from main branch
4. **Verification:** Check Render logs for upload success messages

## Security Considerations

1. **Input Validation:** Validate base64 format before upload
2. **File Size Limits:** Cloudinary enforces 10MB limit (free tier)
3. **Authentication:** Consider adding authentication middleware to uploadLogo endpoint (currently not implemented)
4. **CORS:** Ensure ALLOWED_ORIGINS environment variable permits frontend requests

## Performance Considerations

1. **Upload Time:** Base64 uploads may take 1-3 seconds depending on image size
2. **Timeout Handling:** Express timeout set to 50MB payload limit
3. **Optimization:** Cloudinary automatically optimizes images, reducing load times
4. **Caching:** Cloudinary URLs are CDN-cached for fast delivery
