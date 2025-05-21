import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:snapdish/utils/app_theme.dart';

class CameraView extends StatefulWidget {
  const CameraView({super.key});

  @override
  State<CameraView> createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {
  CameraController? _controller;
  bool _isCameraInitialized = false;
  bool _isPermissionDenied = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    if (cameras.isEmpty) return;

    final status = await Permission.camera.request();
    if (status.isDenied) {
      setState(() => _isPermissionDenied = true);
      return;
    }

    final camera = cameras.first;
    final controller = CameraController(
      camera,
      ResolutionPreset.high,
      enableAudio: false,
    );

    try {
      await controller.initialize();
      if (mounted) {
        setState(() {
          _controller = controller;
          _isCameraInitialized = true;
        });
      }
    } catch (e) {
      debugPrint('Camera initialization error: $e');
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _takePicture() async {
    if (!_isCameraInitialized) return;

    try {
      final image = await _controller!.takePicture();
      if (mounted) {
        // TODO: Process the image and navigate to result page
        context.go('/ingredient-result');
      }
    } catch (e) {
      debugPrint('Error taking picture: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isPermissionDenied) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.pop(),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('需要相機權限才能使用此功能'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  final status = await Permission.camera.request();
                  if (status.isGranted) {
                    setState(() => _isPermissionDenied = false);
                    _initializeCamera();
                  }
                },
                child: const Text('授予權限'),
              ),
            ],
          ),
        ),
      );
    }

    if (!_isCameraInitialized) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(
            child: CameraPreview(_controller!),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 32,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: _takePicture,
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppTheme.primaryColor,
                            width: 4,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
                  '拍攝食材照片',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                      onPressed: () => context.pop(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
} 