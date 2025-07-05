import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_tflite/flutter_tflite.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(PlantClinicApp());
}

class PlantClinicApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PlantClinic',
      theme: ThemeData(primarySwatch: Colors.teal),
      home: PlantClinicHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class PlantClinicHomePage extends StatefulWidget {
  @override
  _PlantClinicHomePageState createState() => _PlantClinicHomePageState();
}

class _PlantClinicHomePageState extends State<PlantClinicHomePage> {
  File? _image;
  String _result = "No results yet. Please upload or capture an image and press 'Process Image' to analyze.";
  List<String> _labels = [];
  String _treatment = "No treatment suggested yet.";
  String? diseaseFirstWord;


  @override
  void initState() {
    super.initState();
    requestPermissions();
    loadModel();
  }

  Future<void> requestPermissions() async {
    await [
      Permission.camera,
      Permission.photos,
      Permission.storage,
    ].request();
  }

  Future<void> loadModel() async {
    try {
      await Tflite.loadModel(
        model: 'assets/models/model.tflite',
        labels: 'assets/models/labels.txt',
      );
      String? labelsText = await DefaultAssetBundle.of(context).loadString('assets/models/labels.txt');
      _labels = labelsText.split('\n').where((label) => label.isNotEmpty).toList();
    } catch (e) {
      setState(() {
        _result = "Error loading model: $e";
      });
    }
  }

  Future<void> pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile == null) return;
    setState(() => _image = File(pickedFile.path));
  }

  Future<void> predictImage() async {
    if (_image == null) {
      setState(() => _result = "Please select an image first.");
      return;
    }

    try {
      var recognitions = await Tflite.runModelOnImage(
        path: _image!.path,
        imageMean: 0.0,
        imageStd: 255.0,
        numResults: _labels.length,
        threshold: 0.1,
      );

      if (recognitions == null || recognitions.isEmpty) {
        setState(() => _result = "No predictions returned.");
        return;
      }

      // Find the prediction with the highest confidence
      double maxConfidence = 0.0;
      String maxLabel = "Unknown";

      for (var recognition in recognitions) {
        double confidence = recognition['confidence'] as double;
        int index = recognition['index'] as int;
        if (confidence > maxConfidence && index < _labels.length) {
          maxConfidence = confidence;
          maxLabel = _labels[index];
        }
      }

      setState(() {
        _result = "$maxLabel - ${(maxConfidence * 100).toStringAsFixed(2)}%";
        diseaseFirstWord = _result.split(" ").first.trim().toLowerCase();
      });
    } catch (e) {
      setState(() {
        _result = "Error processing image: $e";
      });
    }
  }
  Float32List imageToByteListFloat32(img.Image image, int inputSize, double mean, double std) {
    final convertedBytes = Float32List(inputSize * inputSize * 3);
    final buffer = Float32List.view(convertedBytes.buffer);
    int pixelIndex = 0;

    for (int y = 0; y < inputSize; y++) {
      for (int x = 0; x < inputSize; x++) {
        final pixel = image.getPixel(x, y);
        buffer[pixelIndex++] = (img.getRed(pixel) - mean) / std;
        buffer[pixelIndex++] = (img.getGreen(pixel) - mean) / std;
        buffer[pixelIndex++] = (img.getBlue(pixel) - mean) / std;
      }
    }

    return convertedBytes;
  }

  @override
  void dispose() {
    Tflite.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal[50],
      appBar: AppBar(
        backgroundColor: Colors.teal,
        centerTitle: true,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 22
          ),
          title: Text("PlantClinic")),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Text("Image Analysis", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            Container(
              height: 200,
              width: double.infinity,
              color: Colors.white,
              child: _image == null
                  ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.image_outlined, size: 40, color: Colors.grey),
                    Text("No image selected", style: TextStyle(color: Colors.grey)),
                  ],
                ),
              )
                  : Image.file(_image!),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () => pickImage(ImageSource.camera),
                  icon: Icon(Icons.camera_alt, color: Colors.white,),
                  label: Text("Take Photo",style: TextStyle(color: Colors.white),),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                ),
                SizedBox(width: 10),
                ElevatedButton.icon(
                  onPressed: () => pickImage(ImageSource.gallery),
                  icon: Icon(Icons.upload, color: Colors.white,),
                  label: Text("Upload Image", style: TextStyle(color: Colors.white),),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: predictImage,
              child: Text("Process Image", style: TextStyle(color: Colors.white),),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
            ),
            SizedBox(height: 30),
            Text("Result", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            SizedBox(height: 10),
            Text(_result, textAlign: TextAlign.center),
            SizedBox(height: 20,),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.white,
              ),
              child: Padding(
                padding: EdgeInsetsGeometry.symmetric(vertical: 20, horizontal: 12),
                child: Text(
                    diseaseFirstWord == "powdery" ? "Improve air circulation and use neem oil or a bicarbonate solution as treatment.": diseaseFirstWord== "rust"? "Remove infected leaves and apply a fungicide like sulfur or copper-based spray.": "Plant is healthy. No need treatment.",
                    textAlign: TextAlign.center),
              ),
            )
          ],
        ),
      ),
    );
  }
}