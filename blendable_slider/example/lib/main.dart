import 'package:bendable_slider/bendable_slider.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: const MyHomePage());
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF131315),
      body: Center(
        child: BendableSlider(
          backgroundTrackColor: Colors.grey.shade300,
          foregroundGradiantColor: [Colors.purple, Colors.pink],
          title: 'SEND',
          titleTextStyle: const TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
          isTitleFixed: true,
          initialProgress: 0.2,
          onSlideComplete: () {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('🎉 Slide Completed!')));
          },
        ),
      ),
    );
  }
}
