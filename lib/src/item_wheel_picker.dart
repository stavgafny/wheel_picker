import 'package:flutter/material.dart';
import './wheel_picker_style.dart';

class ItemWheelPicker<T> extends StatelessWidget {
  final List<T> children;
  final Widget Function(BuildContext context, T item, int index) builder;
  final int initialIndex;
  final bool looping;
  final WheelPickerStyle style;

  const ItemWheelPicker({
    required this.children,
    required this.builder,
    this.initialIndex = 0,
    this.looping = true,
    this.style = WheelPickerStyle.defaultStyle,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return looping ? _repeating(context) : _nonRepeating(context);
  }

  Widget _repeating(BuildContext context) {
    return SizedBox(
      width: style.width,
      height: style.height,
      child: ListWheelScrollView.useDelegate(
        childDelegate: ListWheelChildBuilderDelegate(
          builder: (context, index) {
            final relativeIndex = index % children.length;
            return builder(context, children[relativeIndex], relativeIndex);
          },
        ),
        itemExtent: style.itemExtent,
        controller: FixedExtentScrollController(initialItem: initialIndex),
        physics: const FixedExtentScrollPhysics(),
        diameterRatio: style.diameterRatio,
        squeeze: style.squeeze,
        overAndUnderCenterOpacity: style.betweenItemOpacity,
        magnification: style.magnification,
      ),
    );
  }

  Widget _nonRepeating(BuildContext context) {
    int i = 0;
    return SizedBox(
      width: style.width,
      height: style.height,
      child: ListWheelScrollView(
        itemExtent: style.itemExtent,
        controller: FixedExtentScrollController(initialItem: initialIndex),
        physics: const FixedExtentScrollPhysics(),
        diameterRatio: style.diameterRatio,
        squeeze: style.squeeze,
        overAndUnderCenterOpacity: style.betweenItemOpacity,
        magnification: style.magnification,
        children: children.map((item) => builder(context, item, i++)).toList(),
      ),
    );
  }
}
