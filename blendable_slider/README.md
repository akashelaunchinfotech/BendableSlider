# 🌀 BendableSlider

A custom, bendable curved slider widget for Flutter that delivers a delightful user interaction.
Great for onboarding screens, confirmation sliders, or fun UI interactions.

---

## ✨ Features

- 🎯 Bendable curved slider
- 🌈 Customizable gradient foreground and solid background
- 📝 Optional title (fixed or dynamic)
- 🧩 Easy to integrate and style

---

## 📦 Installation

Add this to your `pubspec.yaml`:

## 💡 Example

Here's a minimal example of how to use the `BendableSlider` widget:

```yaml
dependencies:
  bendable_slider: ^0.0.1
  ```

```dart
BendableSlider(
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





