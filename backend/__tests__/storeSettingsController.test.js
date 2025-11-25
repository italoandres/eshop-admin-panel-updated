const fc = require('fast-check');
const { uploadImage, isBase64Image } = require('../services/cloudinaryService');
const StoreSettings = require('../models/StoreSettings');
const {
  updateStoreSettings,
  uploadLogo,
} = require('../controllers/storeSettingsController');

// Mock dependencies
jest.mock('../services/cloudinaryService');
jest.mock('../models/StoreSettings');

describe('StoreSettings Controller - Property-Based Tests', () => {
  let req, res;

  beforeEach(() => {
    // Reset mocks
    jest.clearAllMocks();

    // Setup request and response mocks
    req = {
      params: { storeId: 'test-store-123' },
      body: {},
    };

    res = {
      status: jest.fn().mockReturnThis(),
      json: jest.fn().mockReturnThis(),
    };
  });

  // Feature: store-logo-cloudinary-integration, Property 1: Base64 Detection and Upload
  describe('Property 1: Base64 Detection and Upload', () => {
    test('should detect base64 images and upload to Cloudinary, returning Cloudinary URL', async () => {
      await fc.assert(
        fc.asyncProperty(
          fc.string({ minLength: 100, maxLength: 200 }), // Random base64-like string
          async (randomBase64) => {
            // Arrange: Create a valid base64 image string
            const base64Logo = `data:image/png;base64,${randomBase64}`;
            const cloudinaryUrl = `https://res.cloudinary.com/test/image/upload/v1234567890/eshop/logos/test_${randomBase64.substring(0, 10)}.png`;

            req.body = {
              storeName: 'Test Store',
              logoUrl: base64Logo,
            };

            // Mock isBase64Image to return true
            isBase64Image.mockReturnValue(true);

            // Mock uploadImage to return Cloudinary URL
            uploadImage.mockResolvedValue({ url: cloudinaryUrl, publicId: 'test-id' });

            // Mock StoreSettings methods
            StoreSettings.findOne.mockResolvedValue(null);
            StoreSettings.create.mockResolvedValue({
              storeId: 'test-store-123',
              storeName: 'Test Store',
              logoUrl: cloudinaryUrl,
            });

            // Act
            await updateStoreSettings(req, res);

            // Assert: Cloudinary upload should be called
            expect(uploadImage).toHaveBeenCalledWith(base64Logo, 'eshop/logos');

            // Assert: Response should contain Cloudinary URL
            expect(res.status).toHaveBeenCalledWith(200);
            expect(res.json).toHaveBeenCalledWith({
              success: true,
              data: expect.objectContaining({
                logoUrl: cloudinaryUrl,
              }),
            });

            // Assert: logoUrl should start with Cloudinary domain
            const responseData = res.json.mock.calls[0][0].data;
            expect(responseData.logoUrl).toMatch(/^https:\/\/res\.cloudinary\.com\//);

            // Assert: logoUrl should contain the eshop/logos folder
            expect(responseData.logoUrl).toContain('/eshop/logos/');
          }
        ),
        { numRuns: 100 } // Run 100 iterations as specified in design
      );
    });

    test('uploadLogo endpoint should detect base64 and upload to Cloudinary', async () => {
      await fc.assert(
        fc.asyncProperty(
          fc.string({ minLength: 100, maxLength: 200 }),
          async (randomBase64) => {
            // Arrange
            const base64Logo = `data:image/jpeg;base64,${randomBase64}`;
            const cloudinaryUrl = `https://res.cloudinary.com/test/image/upload/v1234567890/eshop/logos/logo_${randomBase64.substring(0, 10)}.jpg`;

            req.body = { logoUrl: base64Logo };

            isBase64Image.mockReturnValue(true);
            uploadImage.mockResolvedValue({ url: cloudinaryUrl, publicId: 'logo-id' });

            StoreSettings.findOne.mockResolvedValue({
              storeId: 'test-store-123',
              logoUrl: '',
              save: jest.fn().mockResolvedValue(true),
            });

            // Act
            await uploadLogo(req, res);

            // Assert
            expect(uploadImage).toHaveBeenCalledWith(base64Logo, 'eshop/logos');
            expect(res.status).toHaveBeenCalledWith(200);
            expect(res.json).toHaveBeenCalledWith({
              success: true,
              data: expect.objectContaining({
                logoUrl: cloudinaryUrl,
              }),
              message: 'Logo atualizada com sucesso',
            });
          }
        ),
        { numRuns: 100 }
      );
    });
  });

  // Feature: store-logo-cloudinary-integration, Property 2: URL Passthrough
  describe('Property 2: URL Passthrough', () => {
    test('should store regular URLs directly without Cloudinary upload', async () => {
      await fc.assert(
        fc.asyncProperty(
          fc.webUrl(), // Generate random valid URLs
          async (regularUrl) => {
            // Clear mocks for each iteration
            jest.clearAllMocks();

            // Setup fresh request and response mocks
            req = {
              params: { storeId: 'test-store-123' },
              body: {
                storeName: 'Test Store',
                logoUrl: regularUrl,
              },
            };

            res = {
              status: jest.fn().mockReturnThis(),
              json: jest.fn().mockReturnThis(),
            };

            // Mock isBase64Image to return false for regular URLs
            isBase64Image.mockReturnValue(false);

            // Mock StoreSettings methods
            StoreSettings.findOne.mockResolvedValue(null);
            StoreSettings.create.mockImplementation((data) => Promise.resolve({
              storeId: data.storeId,
              storeName: data.storeName || 'Test Store',
              logoUrl: data.logoUrl,
            }));

            // Act
            await updateStoreSettings(req, res);

            // Assert: uploadImage should NOT be called
            expect(uploadImage).not.toHaveBeenCalled();

            // Assert: Response should contain the original URL unchanged
            expect(res.status).toHaveBeenCalledWith(200);
            expect(res.json).toHaveBeenCalledWith({
              success: true,
              data: expect.objectContaining({
                logoUrl: regularUrl,
              }),
            });

            // Assert: logoUrl should equal the input URL (no transformation)
            const responseData = res.json.mock.calls[0][0].data;
            expect(responseData.logoUrl).toBe(regularUrl);
          }
        ),
        { numRuns: 100 }
      );
    });

    test('uploadLogo endpoint should pass through regular URLs without upload', async () => {
      await fc.assert(
        fc.asyncProperty(
          fc.webUrl(),
          async (regularUrl) => {
            // Arrange
            req.body = { logoUrl: regularUrl };

            isBase64Image.mockReturnValue(false);

            const mockSettings = {
              storeId: 'test-store-123',
              logoUrl: '',
              save: jest.fn().mockResolvedValue(true),
            };

            StoreSettings.findOne.mockResolvedValue(mockSettings);

            // Act
            await uploadLogo(req, res);

            // Assert
            expect(uploadImage).not.toHaveBeenCalled();
            expect(mockSettings.logoUrl).toBe(regularUrl);
            expect(res.status).toHaveBeenCalledWith(200);
          }
        ),
        { numRuns: 100 }
      );
    });
  });

  // Feature: store-logo-cloudinary-integration, Property 5: Logo Optimization Application
  describe('Property 5: Logo Optimization Application', () => {
    test('should apply logo-specific transformations when uploading to Cloudinary', async () => {
      await fc.assert(
        fc.asyncProperty(
          fc.string({ minLength: 100, maxLength: 200 }),
          async (randomBase64) => {
            // Clear mocks for each iteration
            jest.clearAllMocks();

            // Arrange
            const base64Logo = `data:image/png;base64,${randomBase64}`;
            const cloudinaryUrl = `https://res.cloudinary.com/test/image/upload/w_800,h_800,c_limit/q_auto:good/f_auto/v1234567890/eshop/logos/test_${randomBase64.substring(0, 10)}.png`;

            req = {
              params: { storeId: 'test-store-123' },
              body: { logoUrl: base64Logo },
            };

            res = {
              status: jest.fn().mockReturnThis(),
              json: jest.fn().mockReturnThis(),
            };

            isBase64Image.mockReturnValue(true);
            uploadImage.mockResolvedValue({ url: cloudinaryUrl, publicId: 'test-id' });

            StoreSettings.findOne.mockResolvedValue({
              storeId: 'test-store-123',
              logoUrl: '',
              save: jest.fn().mockResolvedValue(true),
            });

            // Act
            await uploadLogo(req, res);

            // Assert: uploadImage should be called with 'eshop/logos' folder
            expect(uploadImage).toHaveBeenCalledWith(base64Logo, 'eshop/logos');

            // Assert: Response should contain Cloudinary URL
            expect(res.status).toHaveBeenCalledWith(200);
            expect(res.json).toHaveBeenCalledWith({
              success: true,
              data: expect.objectContaining({
                logoUrl: cloudinaryUrl,
              }),
              message: 'Logo atualizada com sucesso',
            });

            // Assert: URL should indicate transformations were applied
            // The actual transformation parameters are handled by cloudinaryService
            // We verify that the upload was called with the correct folder
            const responseData = res.json.mock.calls[0][0].data;
            expect(responseData.logoUrl).toMatch(/^https:\/\/res\.cloudinary\.com\//);
            expect(responseData.logoUrl).toContain('/eshop/logos/');
          }
        ),
        { numRuns: 100 }
      );
    });

    test('should call uploadImage with eshop/logos folder for logo uploads', async () => {
      await fc.assert(
        fc.asyncProperty(
          fc.string({ minLength: 50, maxLength: 100 }),
          async (randomBase64) => {
            // Clear mocks for each iteration
            jest.clearAllMocks();

            // Arrange
            const base64Logo = `data:image/jpeg;base64,${randomBase64}`;
            const cloudinaryUrl = `https://res.cloudinary.com/test/eshop/logos/logo.jpg`;

            req = {
              params: { storeId: 'test-store-123' },
              body: {
                storeName: 'Test Store',
                logoUrl: base64Logo,
              },
            };

            res = {
              status: jest.fn().mockReturnThis(),
              json: jest.fn().mockReturnThis(),
            };

            isBase64Image.mockReturnValue(true);
            uploadImage.mockResolvedValue({ url: cloudinaryUrl, publicId: 'test-id' });

            StoreSettings.findOne.mockResolvedValue(null);
            StoreSettings.create.mockImplementation((data) => Promise.resolve({
              storeId: data.storeId,
              storeName: data.storeName,
              logoUrl: data.logoUrl,
            }));

            // Act
            await updateStoreSettings(req, res);

            // Assert: uploadImage should be called with correct folder
            // The cloudinaryService will automatically apply 800x800 transformation
            // when it detects the 'eshop/logos' folder
            expect(uploadImage).toHaveBeenCalledWith(base64Logo, 'eshop/logos');
            
            // Assert: Response contains Cloudinary URL
            const responseData = res.json.mock.calls[0][0].data;
            expect(responseData.logoUrl).toBe(cloudinaryUrl);
          }
        ),
        { numRuns: 100 }
      );
    });
  });

  // Feature: store-logo-cloudinary-integration, Property 3: Upload Failure Handling
  describe('Property 3: Upload Failure Handling', () => {
    test('should return error 500 when Cloudinary upload fails and not modify database', async () => {
      await fc.assert(
        fc.asyncProperty(
          fc.string({ minLength: 100, maxLength: 200 }),
          async (randomBase64) => {
            // Clear mocks for each iteration
            jest.clearAllMocks();

            // Arrange
            const base64Logo = `data:image/png;base64,${randomBase64}`;
            const uploadError = new Error('Cloudinary upload failed');

            req = {
              params: { storeId: 'test-store-123' },
              body: { logoUrl: base64Logo },
            };

            res = {
              status: jest.fn().mockReturnThis(),
              json: jest.fn().mockReturnThis(),
            };

            isBase64Image.mockReturnValue(true);
            uploadImage.mockRejectedValue(uploadError); // Simulate upload failure

            const mockSettings = {
              storeId: 'test-store-123',
              logoUrl: 'https://old-logo-url.com/logo.png',
              save: jest.fn(),
            };

            StoreSettings.findOne.mockResolvedValue(mockSettings);

            // Act
            await uploadLogo(req, res);

            // Assert: Should return error status 500
            expect(res.status).toHaveBeenCalledWith(500);

            // Assert: Should return error response
            expect(res.json).toHaveBeenCalledWith({
              success: false,
              message: 'Erro ao fazer upload da logo',
              error: uploadError.message,
            });

            // Assert: Database should NOT be modified (save not called)
            expect(mockSettings.save).not.toHaveBeenCalled();

            // Assert: logoUrl should remain unchanged
            expect(mockSettings.logoUrl).toBe('https://old-logo-url.com/logo.png');
          }
        ),
        { numRuns: 100 }
      );
    });
  });

  // Feature: store-logo-cloudinary-integration, Property 4: Settings Preservation on Logo Failure
  describe('Property 4: Settings Preservation on Logo Failure', () => {
    test('should preserve all other settings when logo upload fails', async () => {
      await fc.assert(
        fc.asyncProperty(
          fc.string({ minLength: 100, maxLength: 200 }),
          fc.string({ minLength: 5, maxLength: 20 }),
          async (randomBase64, storeName) => {
            // Clear mocks for each iteration
            jest.clearAllMocks();

            // Arrange
            const base64Logo = `data:image/png;base64,${randomBase64}`;
            const primaryColor = '#FF6B6B';
            const uploadError = new Error('Upload failed');

            req = {
              params: { storeId: 'test-store-123' },
              body: {
                storeName,
                logoUrl: base64Logo,
                primaryColor,
              },
            };

            res = {
              status: jest.fn().mockReturnThis(),
              json: jest.fn().mockReturnThis(),
            };

            isBase64Image.mockReturnValue(true);
            uploadImage.mockRejectedValue(uploadError);

            const existingSettings = {
              storeId: 'test-store-123',
              storeName: 'Old Store Name',
              logoUrl: 'https://old-logo.com/logo.png',
              primaryColor: '#FF0000',
            };

            StoreSettings.findOne.mockResolvedValue(existingSettings);

            // Act
            await updateStoreSettings(req, res);

            // Assert: Should return error
            expect(res.status).toHaveBeenCalledWith(500);

            // Assert: findOneAndUpdate should NOT be called (no database modification)
            expect(StoreSettings.findOneAndUpdate).not.toHaveBeenCalled();

            // Assert: create should NOT be called
            expect(StoreSettings.create).not.toHaveBeenCalled();
          }
        ),
        { numRuns: 100 }
      );
    });
  });

  // Feature: store-logo-cloudinary-integration, Property 6: Consistent Error Response Format
  describe('Property 6: Consistent Error Response Format', () => {
    test('should return consistent error format for validation errors', async () => {
      // Clear mocks
      jest.clearAllMocks();

      // Arrange: Missing logoUrl
      req = {
        params: { storeId: 'test-store-123' },
        body: {}, // Missing logoUrl
      };

      res = {
        status: jest.fn().mockReturnThis(),
        json: jest.fn().mockReturnThis(),
      };

      // Act
      await uploadLogo(req, res);

      // Assert: Should return 400 for validation error
      expect(res.status).toHaveBeenCalledWith(400);

      // Assert: Should have consistent error format
      expect(res.json).toHaveBeenCalledWith({
        success: false,
        message: expect.any(String),
      });

      const response = res.json.mock.calls[0][0];
      expect(response).toHaveProperty('success', false);
      expect(response).toHaveProperty('message');
      expect(typeof response.message).toBe('string');
    });

    test('should return consistent error format for upload failures', async () => {
      await fc.assert(
        fc.asyncProperty(
          fc.string({ minLength: 50, maxLength: 100 }),
          async (randomBase64) => {
            // Clear mocks
            jest.clearAllMocks();

            // Arrange
            const base64Logo = `data:image/png;base64,${randomBase64}`;

            req = {
              params: { storeId: 'test-store-123' },
              body: { logoUrl: base64Logo },
            };

            res = {
              status: jest.fn().mockReturnThis(),
              json: jest.fn().mockReturnThis(),
            };

            isBase64Image.mockReturnValue(true);
            uploadImage.mockRejectedValue(new Error('Upload failed'));

            StoreSettings.findOne.mockResolvedValue({
              storeId: 'test-store-123',
              logoUrl: '',
              save: jest.fn(),
            });

            // Act
            await uploadLogo(req, res);

            // Assert: Should have consistent error format
            const response = res.json.mock.calls[0][0];
            expect(response).toHaveProperty('success', false);
            expect(response).toHaveProperty('message');
            expect(response).toHaveProperty('error');
            expect(typeof response.message).toBe('string');
            expect(typeof response.error).toBe('string');
          }
        ),
        { numRuns: 100 }
      );
    });

    test('should return consistent error format for database errors', async () => {
      // Clear mocks
      jest.clearAllMocks();

      // Arrange
      req = {
        params: { storeId: 'test-store-123' },
        body: {
          storeName: 'Test Store',
          logoUrl: 'https://example.com/logo.png',
        },
      };

      res = {
        status: jest.fn().mockReturnThis(),
        json: jest.fn().mockReturnThis(),
      };

      isBase64Image.mockReturnValue(false);
      StoreSettings.findOne.mockRejectedValue(new Error('Database connection failed'));

      // Act
      await updateStoreSettings(req, res);

      // Assert: Should return 500 for server error
      expect(res.status).toHaveBeenCalledWith(500);

      // Assert: Should have consistent error format
      const response = res.json.mock.calls[0][0];
      expect(response).toHaveProperty('success', false);
      expect(response).toHaveProperty('message');
      expect(response).toHaveProperty('error');
    });
  });
});
