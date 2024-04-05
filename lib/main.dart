import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
 
import 'package:ollygemini/screens/home.dart';

final apiKey = dotenv.env['GEMINI-API-KEY'];

Future<String> generateContent() async {
  await dotenv.load(fileName: ".env");

  final apiKey = dotenv.env['GEMINI-API-KEY'];

  if (apiKey == null) {
    print('No \$API_KEY environment variable');
    exit(1);
  }

  final model = GenerativeModel(model: 'gemini-pro', apiKey: apiKey);
  final content = [Content.text('Write a story about Flutter the framework.')];
  final response = await model.generateContent(content);
  print(response.text);
  return response.text ?? ''; // Return the generated text
}

void main() async {
  generateContent();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        textTheme: GoogleFonts.interTextTheme(),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

