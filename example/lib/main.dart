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
      mounts: [c1],
    );

    const textStyle = TextStyle(
      fontSize: 26.0,
      height: 1.4,
    );

    final wheelStyle = WheelPickerStyle(
      itemExtent: textStyle.fontSize! * textStyle.height!,
      squeeze: 1,
      diameterRatio: .8,
    );

    Widget buildItem(BuildContext context, int index) {
      return Text("$index".padLeft(2, '0'), style: textStyle);
    }

    Widget buildSelectedIndex(BuildContext context, int index) {
      return Text(
        "$index".padLeft(2, '0'),
        style: textStyle.copyWith(color: Colors.redAccent),
      );
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
                    selectedIndexBuilder: buildSelectedIndex,
                    controller: c1,
                    looping: false,
                    style: wheelStyle,
                  ),
                  const Text(":", style: textStyle),
                  WheelPicker(
                    builder: buildItem,
                    selectedIndexBuilder: buildSelectedIndex,
                    controller: c2,
                    style: wheelStyle.copyWith(squeeze: 1.5),
                  ),
                ],
              ),
              WheelPicker(
                itemCount: 2,
                builder: (context, index) {
                  return Text(["AM", "PM"][index], style: textStyle);
                },
                looping: false,
                style: wheelStyle.copyWith(
                  shiftStyle: const WheelShiftStyle(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.slowMiddle,
                  ),
                ),
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
        height: 32.0,
        decoration: BoxDecoration(
          color: const Color(0xFFC3C9FA).withAlpha(26),
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    );
  }
}
