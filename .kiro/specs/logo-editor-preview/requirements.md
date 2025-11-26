# Requirements Document

## Introduction

This feature enhances the store logo upload experience in the admin panel by providing a modern, interactive logo editor with real-time preview. The lojista (store owner) will be able to upload any image size, position it within a circular preview, and adjust zoom level before saving - similar to profile picture editors on Facebook and LinkedIn.

## Glossary

- **Admin Panel**: The web-based administrative interface where store owners manage their store settings
- **Logo Editor**: An interactive component that allows image positioning and zoom adjustment
- **Circular Preview**: A circular viewport showing how the logo will appear in the mobile app
- **Lojista**: The store owner/administrator using the admin panel
- **Cloudinary**: The image hosting service that processes and stores uploaded images

## Requirements

### Requirement 1

**User Story:** As a lojista, I want to see a real-time preview of my logo in a circular frame, so that I can visualize how it will appear in the mobile app before saving.

#### Acceptance Criteria

1. WHEN a lojista selects an image file THEN the system SHALL display the image inside a circular preview container
2. WHEN the image is displayed THEN the system SHALL maintain the image's aspect ratio within the circular frame
3. WHEN no image is selected THEN the system SHALL display a placeholder icon or text in the circular preview
4. WHEN the lojista saves the logo THEN the system SHALL show the final circular preview in the settings page

### Requirement 2

**User Story:** As a lojista, I want to adjust the zoom level of my logo, so that I can control how much of the image is visible within the circular frame.

#### Acceptance Criteria

1. WHEN the logo editor is open THEN the system SHALL provide a zoom slider control
2. WHEN the lojista adjusts the zoom slider THEN the system SHALL scale the image in real-time within the circular preview
3. WHEN the zoom level changes THEN the system SHALL maintain the image center point during scaling
4. WHEN the lojista saves THEN the system SHALL preserve the zoom level setting for the uploaded image

### Requirement 3

**User Story:** As a lojista, I want to reposition my logo within the circular frame, so that I can choose which part of the image is visible.

#### Acceptance Criteria

1. WHEN the logo editor is open THEN the system SHALL allow the lojista to drag the image within the circular preview
2. WHEN the lojista drags the image THEN the system SHALL update the position in real-time
3. WHEN the image is repositioned THEN the system SHALL constrain movement to keep the image covering the circular area
4. WHEN the lojista saves THEN the system SHALL preserve the position settings for the uploaded image

### Requirement 4

**User Story:** As a lojista, I want the system to accept any image size, so that I don't need to pre-process my logo before uploading.

#### Acceptance Criteria

1. WHEN a lojista uploads an image THEN the system SHALL accept images of any dimensions
2. WHEN an image is uploaded THEN the system SHALL automatically fit it within the editor viewport
3. WHEN processing the image THEN the system SHALL maintain the original image quality
4. WHEN saving THEN the system SHALL send the cropped circular area to Cloudinary with the zoom and position applied

### Requirement 5

**User Story:** As a lojista, I want a clean and modern interface without unnecessary text, so that I can focus on editing my logo.

#### Acceptance Criteria

1. WHEN the settings page loads THEN the system SHALL NOT display "tamanho recomendado" (recommended size) text
2. WHEN the settings page loads THEN the system SHALL NOT display app positioning options
3. WHEN the logo editor is open THEN the system SHALL show only essential controls (zoom slider, save/cancel buttons)
4. WHEN displaying the interface THEN the system SHALL use modern, clean styling consistent with the admin panel design

### Requirement 6

**User Story:** As a lojista, I want to save my edited logo with one click, so that the changes are immediately applied to my store.

#### Acceptance Criteria

1. WHEN the lojista clicks save THEN the system SHALL generate a base64 representation of the cropped circular image
2. WHEN saving THEN the system SHALL send the image data to the backend API
3. WHEN the backend receives the image THEN the system SHALL upload it to Cloudinary with appropriate transformations
4. WHEN the upload succeeds THEN the system SHALL update the settings page with the new logo preview
5. WHEN the upload fails THEN the system SHALL display an error message and keep the editor open

### Requirement 7

**User Story:** As a lojista, I want to cancel my edits without saving, so that I can discard changes if I'm not satisfied with the result.

#### Acceptance Criteria

1. WHEN the logo editor is open THEN the system SHALL provide a cancel button
2. WHEN the lojista clicks cancel THEN the system SHALL close the editor without saving changes
3. WHEN canceling THEN the system SHALL revert to the previous logo state
4. WHEN the editor closes THEN the system SHALL clear any temporary image data from memory
