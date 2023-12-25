import 'package:flutter/material.dart';
import 'package:wheel_picker/wheel_picker.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Example',
      theme: ThemeData.dark(useMaterial3: true),
      home: const Scaffold(
        body: Center(
          child: WheelPickerExample(),
        ),
      ),
    );
  }
}

class WheelPickerExample extends StatefulWidget {
  const WheelPickerExample({super.key});

  @override
  State<WheelPickerExample> createState() => _WheelPickerExampleState();
}

class _WheelPickerExampleState extends State<WheelPickerExample> {
  final now = TimeOfDay.now();
  late final hoursWheel = WheelPickerController(
    itemCount: 12,
    initialIndex: now.hour % 12,
  );
  late final minutesWheel = WheelPickerController(
    itemCount: 60,
    initialIndex: now.minute,
    mounts: [hoursWheel],
  );

  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(fontSize: 26.0, height: 1.5);
    final wheelStyle = WheelPickerStyle(
      size: 200,
      itemExtent: textStyle.fontSize! * textStyle.height!, // Text height
      squeeze: 1.25,
      diameterRatio: .8,
      surroundingOpacity: .25,
      magnification: 1.2,
    );

    Widget itemBuilder(BuildContext context, int index) {
      return Text("$index".padLeft(2, '0'), style: textStyle);
    }

    return SizedBox(
      width: 200.0,
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
                    builder: itemBuilder,
                    controller: hoursWheel,
                    looping: false,
                    style: wheelStyle,
                    selectedIndexColor: Colors.redAccent,
                  ),
                  const Text(":", style: textStyle),
                  WheelPicker(
                    builder: itemBuilder,
                    controller: minutesWheel,
                    style: wheelStyle,
                    enableTap: true,
                    selectedIndexColor: Colors.redAccent,
                  )
                ],
              ),
              WheelPicker(
                itemCount: 2,
                builder: (context, index) {
                  return Text(["AM", "PM"][index], style: textStyle);
                },
                initialIndex: (now.period == DayPeriod.am) ? 0 : 1,
                looping: false,
                style: wheelStyle.copyWith(
                    shiftAnimationStyle: const WheelShiftAnimationStyle(
                  duration: Duration(seconds: 1),
                  curve: Curves.bounceOut,
                )),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    hoursWheel.dispose();
    minutesWheel.dispose();
    super.dispose();
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
