import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:io';

class CameraGuideScreen extends StatefulWidget {
  const CameraGuideScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CameraGuideScreenState createState() => _CameraGuideScreenState();
}

class _CameraGuideScreenState extends State<CameraGuideScreen> {
  CameraController? _cameraController;
  bool _pictureTaken = false;
  XFile? _capturedImage;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final frontCamera = cameras.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.front,
      orElse: () => cameras.first,
    );
    
    _cameraController = CameraController(
      frontCamera,
      ResolutionPreset.high,
      enableAudio: false,
    );

    await _cameraController?.initialize();
    setState(() {});
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  void _takePicture() async {
    if (_cameraController != null && _cameraController!.value.isInitialized) {
      final image = await _cameraController?.takePicture();
      setState(() {
        _capturedImage = image;
        _pictureTaken = true;
      });
    }
  }

  void _retakePicture() {
    setState(() {
      _pictureTaken = false;
      _capturedImage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Camera Preview
          if (_cameraController != null && _cameraController!.value.isInitialized)
            CameraPreview(_cameraController!),

          // Overlay with Oval Cutout
          LayoutBuilder(
            builder: (context, constraints) {
              final ovalWidth = constraints.maxWidth * 0.75;
              final ovalHeight = ovalWidth * 1.1;
              
              return Stack(
                children: [
                  // Custom Overlay with matched oval shape
                  CustomPaint(
                    size: Size(constraints.maxWidth, constraints.maxHeight),
                    painter: OverlayPainter(
                      ovalWidth: ovalWidth,
                      ovalHeight: ovalHeight,
                    ),
                  ),
                ],
              );
            },
          ),

          // App Bar with Back Button
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 90,
              padding: const EdgeInsets.only(top: 40),
              child: IconButton(
                alignment: Alignment.topLeft,
                icon: const Icon(Icons.arrow_back, color: Colors.black, size: 28),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),

          // Guide Text
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.2,
            left: 0,
            right: 0,
            child: const Center(
              child: Text(
                'Keep your face within the oval',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),

          // Camera Button
          if (!_pictureTaken)
            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.black, width: 3),
                  ),
                  child: GestureDetector(
                    onTap: _takePicture,
                    child: Container(
                      width: 72,
                      height: 72,
                      margin: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
                ),
              ),
            ),

          // Preview Screen
          if (_pictureTaken && _capturedImage != null)
            Container(
              color: Colors.black,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipOval(
                    child: Image.file(
                      File(_capturedImage!.path),
                      width: MediaQuery.of(context).size.width * 0.75,
                      height: MediaQuery.of(context).size.width * 0.75 * 1.1,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                        onPressed: _retakePicture,
                        child: const Text(
                          'Retake',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Add upload functionality
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        child: const Text(
                          'Continue',
                          style: TextStyle(color: Colors.black, fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class OverlayPainter extends CustomPainter {
  final double ovalWidth;
  final double ovalHeight;

  OverlayPainter({
    required this.ovalWidth,
    required this.ovalHeight,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black.withOpacity(0.5)
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final center = Offset(size.width / 2, size.height / 2);
    final ovalRect = Rect.fromCenter(
      center: center,
      width: ovalWidth,
      height: ovalHeight,
    );

    // Create paths for the overlay
    final backgroundPath = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height));
    
    final ovalPath = Path()
      ..addOval(ovalRect);

    // Create the overlay with oval cutout using difference
    final overlayPath = Path.combine(
      PathOperation.difference,
      backgroundPath,
      ovalPath,
    );

    // Draw the overlay
    canvas.drawPath(overlayPath, paint);
    
    // Draw the oval border
    canvas.drawOval(ovalRect, borderPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}