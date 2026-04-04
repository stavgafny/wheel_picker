import 'package:example/wheel_picker_example1.dart';
import 'package:example/wheel_picker_example2.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final List<ButtonSegment<WidgetBuilder>> _examples = [
    ButtonSegment(
      label: Text('time'),
      value: (context) => WheelPickerExample1(),
    ),
    ButtonSegment(
      label: Text('infinite and 0-1000'),
      value: (context) => WheelPickerExample2(),
    ),
  ];
  late WidgetBuilder _selectedExample = _examples.first.value;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Example',
      theme: ThemeData.dark(useMaterial3: true),
      home: Scaffold(
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: SegmentedButton<WidgetBuilder>(
                  segments: _examples,
                  selected: {_selectedExample},
                  onSelectionChanged: (selection) {
                    final first = selection.firstOrNull;
                    if (first == null) return;
                    setState(() {
                      _selectedExample = first;
                    });
                  },
                ),
              ),
              Expanded(
                child: Center(
                  child: _selectedExample(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
