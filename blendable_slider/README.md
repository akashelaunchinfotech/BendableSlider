# 🌀 BendableSlider

A custom, bendable curved slider widget for Flutter that delivers a delightful user interaction. Great for onboarding screens, confirmation sliders, or fun UI interactions.

---

## ✨ Features

- 🎯 Bendable curved slider
- 🌈 Customizable gradient foreground and solid background
- 📝 Optional title (fixed or dynamic)
- 🎉 Callback when sliding completes (over 98%)
- 🧩 Easy to integrate and style

---

## 📦 Installation

Add this to your `pubspec.yaml`:

## 💡 Example

Here's a minimal example of how to use the `BendableSlider` widget:

```dart
import 'package:flutter/material.dart';
import 'package:bendable_slider/bendable_slider.dart';

class BendableSliderExample extends StatelessWidget {
  const BendableSliderExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bendable Slider Example')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: BendableSlider(
            backgroundTrackColor: Colors.grey.shade300,
            foregroundGradiantColor: [Colors.purple, Colors.pink],
            title: 'Slide to Unlock',
            titleTextStyle: const TextStyle(
              fontSize: 18,
              color: Colors.black87,
              fontWeight: FontWeight.bold,
            ),
            isTitleFixed: true,
            initialProgress: 0.2,
            onSlideComplete: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('🎉 Slide Completed!')),
              );
            },
          ),
        ),
      ),
    );
  }
}


```yaml
dependencies:
  bendable_slider: ^0.0.1


