import 'package:flutter/foundation.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'dart:typed_data';

class VisionService {
  // Replace this with your actual key from Google AI Studio
  final String apiKey = "AIzaSyAbBKFV4RM9ajhMwAn3m8Ys4Sdi3puTi7Q"; 

  Future<String> getWisdom(Uint8List imageBytes) async {
    final model = GenerativeModel(model: 'gemini-pro-vision-001', apiKey: apiKey);
    debugPrint("Checking available models...");
    
    // We're giving Udaasi a specific Toronto-inspired "Voice"
    final prompt = TextPart("""
      You are 'Udaasi', a poetic and deeply knowledgeable Toronto guide. 
      Analyze this image. If it's a landmark in Toronto, share its history with soul. 
      If it's an everyday object, find a philosophical lesson in it. 
      Keep your response under 60 words and maintain a serene, premium tone.
    """);
    
    final content = [
      Content.multi([
        prompt,
        DataPart('image/jpeg', imageBytes),
      ])
    ];

    try {
      final response = await model.generateContent(content);
      return response.text ?? "Udaasi is lost in thought. Try again.";
    } catch (e) {
      // THIS IS THE KEY: Look at your terminal/logs after you click the button
      debugPrint("--------- VISION DEBUG ---------");
      debugPrint(e.toString());
      debugPrint("--------------------------------");
      
      return "The digital winds are turbulent. Try again.";
    }
  }
}