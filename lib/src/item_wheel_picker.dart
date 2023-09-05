part of './wheel_picker_controller.dart';

class ItemWheelPicker<T> extends StatelessWidget {
  final List<T> children;
  final Widget Function(BuildContext context, T item, int index) builder;
  final WheelPickerController? controller;
  final void Function(T item, int index)? onSelectedItemChanged;
  final bool looping;
  final WheelPickerStyle style;

  const ItemWheelPicker({
    required this.children,
    required this.builder,
    this.controller,
    this.onSelectedItemChanged,
    this.looping = true,
    this.style = WheelPickerStyle.defaultStyle,
    super.key,
  }) : assert(children.length > 0);

  void _onSelectedItemChanged(value) {
    final relativeIndex = value % children.length;
    onSelectedItemChanged?.call(children[relativeIndex], relativeIndex);
  }

  @override
  Widget build(BuildContext context) {
    return looping ? _repeating(context) : _nonRepeating(context);
  }

  Widget _repeating(BuildContext context) {
    controller?._attach(children, looping);
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
        controller: controller?._getScrollController(),
        onSelectedItemChanged: _onSelectedItemChanged,
        physics: const FixedExtentScrollPhysics(),
        diameterRatio: style.diameterRatio,
        squeeze: style.squeeze,
        overAndUnderCenterOpacity: style.betweenItemOpacity,
        magnification: style.magnification,
      ),
    );
  }

  Widget _nonRepeating(BuildContext context) {
    controller?._attach(children, looping);

    int i = 0;
    return SizedBox(
      width: style.width,
      height: style.height,
      child: ListWheelScrollView(
        itemExtent: style.itemExtent,
        controller: controller?._getScrollController(),
        onSelectedItemChanged: _onSelectedItemChanged,
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
