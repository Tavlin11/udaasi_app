import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:ui';
import 'main.dart'; 
import 'vision_service.dart';

class UdaasiViewfinder extends StatefulWidget {
  const UdaasiViewfinder({super.key});

  @override
  State<UdaasiViewfinder> createState() => _UdaasiViewfinderState();
}

class _UdaasiViewfinderState extends State<UdaasiViewfinder> {
  CameraController? _controller; // Made nullable for safety
  bool _isInitialized = false;
  bool _isThinking = false;
  String _wisdomText = "Point your lens at the 6ix. What wisdom do you seek?";

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  // Improved initialization
  Future<void> _initializeCamera() async {
    _controller = CameraController(cameras[0], ResolutionPreset.high, enableAudio: false);
    try {
      await _controller!.initialize();
      if (!mounted) return;
      setState(() => _isInitialized = true);
    } catch (e) {
      debugPrint("Camera error: $e");
    }
  }

  @override
  void dispose() {
    _controller?.dispose(); // CRITICAL: Frees up the camera hardware
    super.dispose();
  }

  Future<void> _seekWisdom() async {
    if (_controller == null || !_controller!.value.isInitialized) return;

    setState(() {
      _isThinking = true;
      _wisdomText = "Udaasi is observing...";
    });
    
    try {
      // 1. Capture the image
      final XFile image = await _controller!.takePicture();
      final bytes = await image.readAsBytes();
      
      // 2. Send to our Gemini Brain
      final vision = VisionService();
      final response = await vision.getWisdom(bytes);
      
      setState(() {
        _wisdomText = response;
        _isThinking = false;
      });
    } catch (e) {
      debugPrint("Vision Error: $e");
      setState(() {
        _wisdomText = "The digital winds are turbulent. Try again.";
        _isThinking = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized || _controller == null) {
      return const Scaffold(backgroundColor: Colors.black, body: Center(child: CircularProgressIndicator(color: Colors.orangeAccent)));
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Using a fitted box to ensure the camera fills the screen nicely
          Center(
            child: CameraPreview(_controller!),
          ),
          
          // Glass Panel UI
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.38,
              margin: const EdgeInsets.only(bottom: 110, left: 20, right: 20), // Lifted for Nav Bar
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Colors.white10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeader(),
                        const SizedBox(height: 15),
                        Expanded(
                          child: SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            child: _isThinking 
                              ? const Center(
                                  child: Padding(
                                    padding: EdgeInsets.only(top: 20),
                                    child: CircularProgressIndicator(color: Colors.orangeAccent),
                                  ),
                                )
                              : Text(
                                  _wisdomText, 
                                  style: const TextStyle(
                                    color: Colors.white, 
                                    fontSize: 18, 
                                    fontWeight: FontWeight.w300,
                                    height: 1.5,
                                  ),
                                ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        // THE AURA BUTTON
                        Center(
                          child: GestureDetector(
                            onTap: _isThinking ? null : _seekWisdom,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                              decoration: BoxDecoration(
                                color: _isThinking ? Colors.grey : Colors.orangeAccent,
                                borderRadius: BorderRadius.circular(50),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.orangeAccent.withOpacity(0.3),
                                    blurRadius: 15,
                                    spreadRadius: 2,
                                  )
                                ]
                              ),
                              child: Text(
                                _isThinking ? "THINKING..." : "SEEK WISDOM",
                                style: const TextStyle(
                                  color: Colors.black, 
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 1.5,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          width: 8, 
          height: 8, 
          decoration: const BoxDecoration(color: Colors.orangeAccent, shape: BoxShape.circle),
        ),
        const SizedBox(width: 10),
        const Text(
          "UDAASI VISION", 
          style: TextStyle(
            color: Colors.orangeAccent, 
            fontSize: 10, 
            fontWeight: FontWeight.bold, 
            letterSpacing: 2,
          ),
        ),
      ],
    );
  }
}