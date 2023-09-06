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

class Example extends StatefulWidget {
  const Example({super.key});

  @override
  State<Example> createState() => _ExampleState();
}

class _ExampleState extends State<Example> {
  late final WheelPickerController yearController;
  late final WheelPickerController monthController;

  bool _visible = true;

  @override
  void initState() {
    yearController = WheelPickerController(
      items: List.generate(100, (index) => index),
      initialIndex: 0,
    );
    monthController = WheelPickerController(
      items: List.generate(12, (index) => index + 1),
      initialIndex: 0,
      mount: yearController,
      preserveIndex: true,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        WheelPicker(
          builder: (context, item, index) {
            return Text("${2000 + item}");
          },
          controller: yearController,
          looping: false,
        ),
        _visible
            ? WheelPicker(
                builder: (context, item, index) {
                  return Text("$item".padLeft(2, '0'));
                },
                controller: monthController,
              )
            : const SizedBox(),
        ElevatedButton(
          onPressed: () {
            setState(() {
              _visible = !_visible;
            });
          },
          child: Text(_visible ? "remove" : "add"),
        )
      ],
    );
  }
}

final alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ".split('');
