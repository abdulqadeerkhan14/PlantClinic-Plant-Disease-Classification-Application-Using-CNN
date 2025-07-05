# PlantClinic-Plant-Disease-Classification-Application-Using-CNN
# PlantClinic

A Flutter mobile application for detecting plant diseases using TensorFlow Lite (TFLite) machine learning.

## Overview

PlantClinic is an intelligent plant disease detection app that helps users identify common plant diseases by analyzing photos. The app uses a pre-trained machine learning model to classify plant images into three categories: Healthy, Powdery Mildew, and Rust Disease.

## Features

- 📸 **Image Capture**: Take photos directly using your device's camera
- 📁 **Image Upload**: Select images from your device's gallery
- 🤖 **AI-Powered Detection**: Uses TensorFlow Lite for accurate disease classification
- 💊 **Treatment Recommendations**: Provides specific treatment advice based on detected diseases
- 📱 **Cross-Platform**: Works on Android, iOS, Web, Windows, macOS, and Linux
- 🎨 **Modern UI**: Clean, intuitive interface with Material Design

## Supported Plant Diseases

The app can currently detect and provide treatment for:

1. **Healthy Plants** - No treatment needed
2. **Powdery Mildew** - Fungal disease affecting leaves and stems
3. **Rust Disease** - Fungal disease causing orange/brown spots

## Treatment Recommendations

- **Powdery Mildew**: Improve air circulation and use neem oil or a bicarbonate solution
- **Rust Disease**: Remove infected leaves and apply a fungicide like sulfur or copper-based spray
- **Healthy Plants**: No treatment required

## ScreenShorts Of Application




## Getting Started

### Prerequisites

- Flutter SDK (>=3.1.0)
- Dart SDK
- Android Studio / VS Code
- Device or emulator for testing

### Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd PlantClinic
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

### Permissions

The app requires the following permissions:
- Camera access for taking photos
- Storage access for uploading images
- Photo library access for selecting images

## Technical Details

### Dependencies

- `flutter_tflite: ^1.0.1` - TensorFlow Lite integration
- `image_picker: ^0.8.5+3` - Camera and gallery access
- `permission_handler: ^11.3.0` - Permission management
- `image: ^3.2.0` - Image processing utilities

### Model Information

- **Model Type**: TensorFlow Lite
- **Model Size**: 46MB
- **Input**: Plant images
- **Output**: Disease classification with confidence scores

### Project Structure

```
PlantClinic/
├── lib/
│   └── main.dart              # Main application code
├── assets/
│   └── models/
│       ├── model.tflite       # TFLite model file
│       └── labels.txt         # Disease labels
├── test/
│   └── widget_test.dart       # Widget tests
└── pubspec.yaml               # Dependencies and configuration
```

## Usage

1. **Launch the app** and grant necessary permissions
2. **Select an image** by either:
   - Tapping "Take Photo" to capture a new image
   - Tapping "Upload Image" to select from gallery
3. **Process the image** by tapping "Process Image"
4. **View results** including:
   - Detected disease with confidence percentage
   - Treatment recommendations

## Development

### Code Analysis

The project uses Flutter's recommended linting rules for code quality. Run analysis with:

```bash
flutter analyze
```

### Testing

Run tests with:

```bash
flutter test
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## Future Enhancements

- [ ] Add more plant disease categories
- [ ] Implement result history and saving
- [ ] Add image preprocessing and validation
- [ ] Improve error handling and user feedback
- [ ] Add offline mode support
- [ ] Implement batch processing for multiple images


## Support

For support and questions, please open an issue in the repository.

---

**Note**: This app is for educational and informational purposes. For serious plant health issues, consult with a professional botanist or agricultural expert.
