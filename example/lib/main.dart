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
    final wheelHours = WheelPickerController(
      itemCount: 12,
      initialIndex: now.hour % 12,
    );
    final wheelMinutes = WheelPickerController(
      itemCount: 60,
      initialIndex: now.minute,
      mounts: [wheelHours],
    );
    const textStyle = TextStyle(fontSize: 26.0, height: 1.4);

    final wheelStyle = WheelPickerStyle(
      itemExtent: textStyle.fontSize! * textStyle.height!,
      squeeze: 1,
      diameterRatio: .8,
    );

    Widget buildItem(BuildContext context, int index) {
      return Text("$index".padLeft(2, '0'), style: textStyle);
    }

    const barWidth = 200.0;

    return SizedBox(
      width: barWidth,
      child: Stack(
        fit: StackFit.expand,
        children: [
          _centerBar(context),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  WheelPicker(
                    builder: buildItem,
                    controller: wheelHours,
                    looping: false,
                    style: wheelStyle,
                    selectedIndexColor: Colors.redAccent,
                  ),
                  const Text(":", style: textStyle),
                  WheelPicker(
                    builder: buildItem,
                    controller: wheelMinutes,
                    style: wheelStyle.copyWith(squeeze: 1.5, magnification: 1),
                    enableTap: true,
                    selectedIndexColor: Colors.redAccent,
                  ),
                ],
              ),
              WheelPicker(
                itemCount: 2,
                builder: (context, index) {
                  return Text(["AM", "PM"][index], style: textStyle);
                },
                looping: false,
                style: wheelStyle,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _centerBar(BuildContext context) {
    return Center(
      child: Container(
        height: 38.0,
        decoration: BoxDecoration(
          color: const Color(0xFFC3C9FA).withAlpha(26),
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    );
  }
}
