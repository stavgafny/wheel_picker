import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wheel_picker/wheel_picker.dart';

void main() {
  testWidgets('WheelPicker displays initialIndex and surrounding items',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: WheelPicker(
            builder: (context, index) => Text("${index + 1}"),
            itemCount: 10,
            initialIndex: 5,
          ),
        ),
      ),
    );

    expect(find.text("3"), findsOneWidget);
    expect(find.text("4"), findsOneWidget);
    expect(find.text("5"), findsOneWidget);
    expect(find.text("6"), findsOneWidget);
    expect(find.text("7"), findsOneWidget);
  });
}
