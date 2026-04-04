import 'dart:async';

import 'package:flutter/material.dart';
import 'package:wheel_picker/wheel_picker.dart';

class WheelPickerExample2 extends StatefulWidget {
  const WheelPickerExample2({super.key});

  @override
  State<WheelPickerExample2> createState() => _WheelPickerExample2State();
}

class _WheelPickerExample2State extends State<WheelPickerExample2> {
  late final _infiniteWheel = WheelPickerController(
    itemCount: null,
    initialIndex: 0,
  );
  late final _zeroToThousandWheel = WheelPickerController(
    itemCount: null,
    initialIndex: 0,
  );

  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(fontSize: 26.0, height: 1.5);
    final wheelStyle = WheelPickerStyle(
      itemExtent: textStyle.fontSize! * textStyle.height!, // Text height
      squeeze: 1.25,
      diameterRatio: .8,
      surroundingOpacity: .25,
      magnification: 1.2,
    );

    Widget infiniteItemBuilder(BuildContext context, int index) {
      return Text("$index", style: textStyle);
    }

    Widget? zeroToThousandItemBuilder(BuildContext context, int index) {
      if (index < 0 || index > 1000) return null;
      return Text("$index", style: textStyle);
    }

    return Center(
      child: SizedBox(
        width: 200.0,
        height: 200.0,
        child: Stack(
          fit: StackFit.expand,
          children: [
            _centerBar(context),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                children: [
                  Expanded(
                    child: WheelPicker(
                      builder: infiniteItemBuilder,
                      controller: _infiniteWheel,
                      looping: false,
                      style: wheelStyle,
                      selectedIndexColor: Colors.redAccent,
                      onIndexChanged: (index, interactionType) {
                        _printReportedPosition("infiniteWheel index: $index");
                      },
                    ),
                  ),
                  const Text(" - ", style: textStyle),
                  Expanded(
                    child: WheelPicker(
                      builder: zeroToThousandItemBuilder,
                      controller: _zeroToThousandWheel,
                      looping: false,
                      style: wheelStyle,
                      selectedIndexColor: Colors.redAccent,
                      onIndexChanged: (index, interactionType) {
                        _printReportedPosition(
                            "zeroToThousandWheel index: $index");
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Timer? _printCooldown;
  String? _lastMessage;
  String? _pendingMessage;

  void _printReportedPosition(String message) {
    if (_printCooldown != null) {
      _pendingMessage = message;
      return;
    }

    _printCooldown = Timer(const Duration(milliseconds: 200), () {
      _printCooldown = null;
      final pendingMessage = _pendingMessage;
      if (pendingMessage == null || _lastMessage == pendingMessage) {
        return;
      }
      _lastMessage = pendingMessage;
      _pendingMessage = null;
      Future.microtask(() {
        print(pendingMessage);
      });
    });

    _lastMessage = message;
    Future.microtask(() {
      print(message);
    });
  }

  @override
  void dispose() {
    // Don't forget to dispose the controllers at the end.
    _infiniteWheel.dispose();
    _zeroToThousandWheel.dispose();
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
