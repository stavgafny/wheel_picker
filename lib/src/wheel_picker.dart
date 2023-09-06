part of './wheel_picker_controller.dart';

class WheelPicker extends StatefulWidget {
  final Widget Function(BuildContext context, int index) builder;
  final int? itemCount;
  final WheelPickerController? controller;
  final void Function(int index)? onSelectedItemChanged;
  final bool looping;
  final WheelPickerStyle style;

  const WheelPicker({
    required this.builder,
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
        builder: (context, index) => widget.builder(context, index % range),
      ),
      controller: widget.controller?._getScrollController(),
      onSelectedItemChanged: widget.onSelectedItemChanged,
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
      onSelectedItemChanged: widget.onSelectedItemChanged,
      physics: const FixedExtentScrollPhysics(),
      diameterRatio: widget.style.diameterRatio,
      squeeze: widget.style.squeeze,
      overAndUnderCenterOpacity: widget.style.betweenItemOpacity,
      magnification: widget.style.magnification,
      children: List.generate(range, (index) => widget.builder(context, index)),
    );
  }
}
