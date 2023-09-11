# Wheel Picker

A superset version of original [ListWheelScrollView](https://api.flutter.dev/flutter/widgets/ListWheelScrollView-class.html) for easily creating wheel scroll input.

[![Flutter](https://img.shields.io/badge/Platform-Flutter-blue.svg)](https://flutter.dev/) [![Pub](https://img.shields.io/badge/pub-v0.0.2-orange.svg)]()

<div style="display: flex; flex-direction: row;">
    <img src="https://raw.githubusercontent.com/stavgafny/wheel_picker/main/doc/counter.gif" alt="Left Gif" width="30%">
    <img src="https://raw.githubusercontent.com/stavgafny/wheel_picker/main/doc/time.gif" alt="Right Gif" width="30%">
</div>

## Key Features

- **Item Selection**: Retrieve the selected item index effortlessly.
- **Highlight Selection**: Highlight selected items with a color shader.
- **Tap Navigation**: Enable tap scrolls.
- **Styling Flexibility**: Customize wheel appearance with `WheelPickerStyle`.
- **Precise Control**: Manage and synchronize `WheelPicker` widgets with a `WheelPickerController`.
- **Mounting Controllers**: Easily integrate and shift multiple controllers.

## Installing

Add it to your `pubspec.yaml` file:

```yaml
dependencies:
  wheel_picker: ^0.0.2
```

Install packages from the command line:

```
flutter packages get
```

## Usage

To use package, just import package `import 'package:wheel_picker/wheel_picker.dart';`

## Example

### Basic (Left Gif)

For more controller you can attach a controller and adjust it to your liking:

```dart
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:wheel_picker/wheel_picker.dart';

class WheelPickerExample extends StatelessWidget {
  const WheelPickerExample({super.key});

  @override
  Widget build(BuildContext context) {
    final secondsWheel = WheelPickerController(itemCount: 10);
    const textStyle = TextStyle(fontSize: 32.0, height: 1.5);

    Timer.periodic(const Duration(seconds: 1), (_) => secondsWheel.shiftDown());

    return WheelPicker(
      builder: (context, index) => Text("$index", style: textStyle),
      controller: secondsWheel,
      selectedIndexColor: Colors.blue,
      onIndexChanged: (index) {
        print("On index $index");
      },
      style: WheelPickerStyle(
        height: 300,
        itemExtent: textStyle.fontSize! * textStyle.height!, // Text height
        squeeze: 1.25,
        diameterRatio: .8,
        surroundingOpacity: .25,
        magnification: 1.2,
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Example',
      home: Scaffold(
        body: Center(
          child: WheelPickerExample(),
        ),
      ),
    );
  }
}

void main() => runApp(const MyApp());
```

> **Note:** This works for this short example but don't forget to dispose controllers you initialize youself.

### Advanced (Right Gif)

For more control, you can also mount controllers, making them shift each other. See [example](example/lib/main.dart).

<br />
<br />

Feel free to share your feedback, suggestions, or contribute to this package :handshake:.

If you like this package, consider supporting it by giving it a star on [GitHub](https://github.com/stavgafny/wheel_picker) and a like on [pub.dev](https://pub.dev/packages/wheel_picker) :heart:.
