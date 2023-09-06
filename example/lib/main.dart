import 'package:flutter/material.dart';
import 'package:wheel_picker/wheel_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Example',
      theme: ThemeData.dark(useMaterial3: true),
      home: const Scaffold(
        body: Center(
          child: Example(),
        ),
      ),
    );
  }
}

class Example extends StatelessWidget {
  const Example({super.key});

  @override
  Widget build(BuildContext context) {
    final now = TimeOfDay.now();
    final c1 =
        WheelPickerController(itemCount: 12, initialIndex: now.hour % 12);
    final c2 = WheelPickerController(
      itemCount: 60,
      initialIndex: now.minute,
      mount: c1,
    );
    const style = TextStyle(color: Colors.redAccent);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        WheelPicker(
          builder: (context, index) {
            return Text("$index".padLeft(2, '0'), style: style);
          },
          controller: c1,
          looping: false,
        ),
        const Text(":", style: style),
        WheelPicker(
          builder: (context, index) {
            return Text(
              "$index".padLeft(2, '0'),
              style: style,
            );
          },
          controller: c2,
        ),
        WheelPicker(
          itemCount: 2,
          builder: (context, index) {
            return Text(["AM", "PM"][index]);
          },
          looping: false,
        ),
      ],
    );
  }
}

final alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ".split('');
