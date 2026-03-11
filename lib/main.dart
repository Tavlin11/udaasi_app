import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'udaasi_viewfinder.dart';
import 'udaasi_home.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

// This stores the cameras globally
late List<CameraDescription> cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize the camera hardware
  try {
    cameras = await availableCameras();
  } catch (e) {
    print("Camera error: $e");
  }

  runApp(
    const ProviderScope(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Project Udaasi',
        home: UdaasiHome(),
      ),
    ),
  );
}