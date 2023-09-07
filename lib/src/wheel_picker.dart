part of './wheel_picker_controller.dart';

class WheelPicker extends StatefulWidget {
  final Widget Function(BuildContext context, int index) builder;
  final Widget Function(BuildContext context, int index)? selectBuilder;
  final int? itemCount;
  final WheelPickerController? controller;
  final void Function(int index)? onSelectedItemChanged;
  final bool looping;
  final WheelPickerStyle style;

  const WheelPicker({
    required this.builder,
    this.selectBuilder,
    this.itemCount,
    this.controller,
    this.onSelectedItemChanged,
    this.looping = true,
    this.style = WheelPickerStyle.defaultStyle,
    super.key,
  })  : assert(
          !(itemCount == null && controller == null),
          "Must have either itemCount or a controller",
        ),
        assert(
          !(itemCount != null && controller != null),
          "Can't have both itemCount and controller. Try removing the itemCount to the controller",
        );

  @override
  State<WheelPicker> createState() => _WheelPickerState();
}

class _WheelPickerState extends State<WheelPicker> {
  int? current;

  @override
  void initState() {
    widget.controller?._attach(widget.looping);
    if (widget.selectBuilder != null) {
      current = widget.controller?.initialIndex ?? 0;
    }
    super.initState();
  }

  @override
  void dispose() {
    widget.controller?._disposeAttachment();
    super.dispose();
  }

  void Function(int)? _onSelectedItemChangedFactory(int range) {
    if (widget.selectBuilder == null) return widget.onSelectedItemChanged;
    return (int index) {
      setState(() => current = index % range);
      widget.onSelectedItemChanged?.call(index);
    };
  }

  @override
  Widget build(BuildContext context) {
    final range = (widget.itemCount ?? widget.controller?.itemCount)!;
    return SizedBox(
      width: widget.style.width,
      height: widget.style.height,
      child: range > 0
          ? (widget.looping ? _loopingWheel : _nonLoopingWheel)
              .call(context, range)
          : null,
    );
  }

  Widget _loopingWheel(BuildContext context, int range) {
    return ListWheelScrollView.useDelegate(
      itemExtent: widget.style.itemExtent,
      childDelegate: ListWheelChildBuilderDelegate(
        builder: widget.selectBuilder == null
            ? (context, index) => widget.builder(context, index % range)
            : (context, index) {
                final relativeIndex = index % range;
                final builder = (current == relativeIndex)
                    ? widget.selectBuilder!
                    : widget.builder;
                return builder(context, relativeIndex);
              },
      ),
      controller: widget.controller?._getScrollController(),
      onSelectedItemChanged: _onSelectedItemChangedFactory(range),
      physics: const FixedExtentScrollPhysics(),
      diameterRatio: widget.style.diameterRatio,
      squeeze: widget.style.squeeze,
      overAndUnderCenterOpacity: widget.style.betweenItemOpacity,
      magnification: widget.style.magnification,
    );
  }

  Widget _nonLoopingWheel(BuildContext context, int range) {
    return ListWheelScrollView(
      itemExtent: widget.style.itemExtent,
      controller: widget.controller?._getScrollController(),
      onSelectedItemChanged: _onSelectedItemChangedFactory(range),
      physics: const FixedExtentScrollPhysics(),
      diameterRatio: widget.style.diameterRatio,
      squeeze: widget.style.squeeze,
      overAndUnderCenterOpacity: widget.style.betweenItemOpacity,
      magnification: widget.style.magnification,
      children: List.generate(
          range,
          widget.selectBuilder == null
              ? (index) => widget.builder(context, index)
              : (index) {
                  final relativeIndex = index % range;
                  final builder = (current == relativeIndex)
                      ? widget.selectBuilder!
                      : widget.builder;
                  return builder(context, relativeIndex);
                }),
    );
  }
}
