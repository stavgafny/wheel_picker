part of './wheel_picker_controller.dart';

class WheelPicker<T> extends StatelessWidget {
  final List<T>? items;
  final Widget Function(BuildContext context, T item, int index) builder;
  final WheelPickerController<T>? controller;
  final void Function(T item, int index)? onSelectedItemChanged;
  final bool looping;
  final WheelPickerStyle style;

  const WheelPicker({
    this.items,
    required this.builder,
    this.controller,
    this.onSelectedItemChanged,
    this.looping = true,
    this.style = WheelPickerStyle.defaultStyle,
    super.key,
  })  : assert(
          !(items == null && controller == null),
          "Must have either items or a controller",
        ),
        assert(
          !(items != null && controller != null),
          "Can't have both items and controller",
        );

  List<T> get _items => (items ?? controller?.items)!;

  void _onSelectedItemChanged(value) {
    final relativeIndex = value % _items.length;
    onSelectedItemChanged?.call(_items[relativeIndex], relativeIndex);
  }

  @override
  Widget build(BuildContext context) {
    controller?._attach(looping);
    return SizedBox(
      width: style.width,
      height: style.height,
      child: _items.isNotEmpty
          ? (looping ? _repeating : _nonRepeating).call(context, _items)
          : null,
    );
  }

  Widget _repeating(BuildContext context, List<T> buildItems) {
    return ListWheelScrollView.useDelegate(
      childDelegate: ListWheelChildBuilderDelegate(
        builder: (context, index) {
          final relativeIndex = index % buildItems.length;
          return builder(context, buildItems[relativeIndex], relativeIndex);
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
    );
  }

  Widget _nonRepeating(BuildContext context, List<T> buildItems) {
    int i = 0;
    return ListWheelScrollView(
      itemExtent: style.itemExtent,
      controller: controller?._getScrollController(),
      onSelectedItemChanged: _onSelectedItemChanged,
      physics: const FixedExtentScrollPhysics(),
      diameterRatio: style.diameterRatio,
      squeeze: style.squeeze,
      overAndUnderCenterOpacity: style.betweenItemOpacity,
      magnification: style.magnification,
      children: buildItems.map((item) => builder(context, item, i++)).toList(),
    );
  }
}
