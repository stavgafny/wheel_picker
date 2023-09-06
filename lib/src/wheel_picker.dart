part of './wheel_picker_controller.dart';

class WheelPicker<T> extends StatefulWidget {
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

  @override
  State<WheelPicker<T>> createState() => _WheelPickerState<T>();
}

class _WheelPickerState<T> extends State<WheelPicker<T>> {
  List<T> get _items => (widget.items ?? widget.controller?.items)!;

  void _onSelectedItemChanged(value) {
    final relativeIndex = value % _items.length;
    widget.onSelectedItemChanged?.call(_items[relativeIndex], relativeIndex);
  }

  @override
  void initState() {
    widget.controller?._attach(widget.looping);
    super.initState();
  }

  @override
  void dispose() {
    widget.controller?._disposeAttachment();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.style.width,
      height: widget.style.height,
      child: _items.isNotEmpty
          ? (widget.looping ? _repeating : _nonRepeating).call(context, _items)
          : null,
    );
  }

  Widget _repeating(BuildContext context, List<T> buildItems) {
    return ListWheelScrollView.useDelegate(
      childDelegate: ListWheelChildBuilderDelegate(
        builder: (context, index) {
          final relativeIndex = index % buildItems.length;
          return widget.builder(
              context, buildItems[relativeIndex], relativeIndex);
        },
      ),
      itemExtent: widget.style.itemExtent,
      controller: widget.controller?._getScrollController(),
      onSelectedItemChanged: _onSelectedItemChanged,
      physics: const FixedExtentScrollPhysics(),
      diameterRatio: widget.style.diameterRatio,
      squeeze: widget.style.squeeze,
      overAndUnderCenterOpacity: widget.style.betweenItemOpacity,
      magnification: widget.style.magnification,
    );
  }

  Widget _nonRepeating(BuildContext context, List<T> buildItems) {
    int i = 0;
    return ListWheelScrollView(
      itemExtent: widget.style.itemExtent,
      controller: widget.controller?._getScrollController(),
      onSelectedItemChanged: _onSelectedItemChanged,
      physics: const FixedExtentScrollPhysics(),
      diameterRatio: widget.style.diameterRatio,
      squeeze: widget.style.squeeze,
      overAndUnderCenterOpacity: widget.style.betweenItemOpacity,
      magnification: widget.style.magnification,
      children:
          buildItems.map((item) => widget.builder(context, item, i++)).toList(),
    );
  }
}
