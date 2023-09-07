part of './wheel_picker_controller.dart';

class WheelPicker extends StatefulWidget {
  final Widget Function(BuildContext context, int index) builder;
  final int? itemCount;
  final WheelPickerController? controller;
  final int? initialIndex;
  final Widget Function(BuildContext context, int index)? selectBuilder;
  final bool looping;
  final void Function(int index)? onSelectedItemChanged;
  final WheelPickerStyle style;

  const WheelPicker({
    required this.builder,
    this.itemCount,
    this.controller,
    this.initialIndex,
    this.selectBuilder,
    this.looping = true,
    this.onSelectedItemChanged,
    this.style = WheelPickerStyle.defaultStyle,
    super.key,
  })  : assert(
          !(itemCount == null && controller == null),
          "Must have either itemCount or a controller",
        ),
        assert(
          !(itemCount != null && controller != null),
          "Can't have both itemCount and controller.",
        ),
        assert(
          !(initialIndex != null && controller != null),
          "Can't have both initialIndex and controller.",
        );

  @override
  State<WheelPicker> createState() => _WheelPickerState();
}

class _WheelPickerState extends State<WheelPicker> {
  int? _current;

  @override
  void initState() {
    widget.controller?._attach(widget.looping);
    if (widget.selectBuilder != null) {
      _current = widget.controller?.initialIndex ?? 0;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final range = (widget.itemCount ?? widget.controller?.itemCount)!;
    if (range <= 0) {
      return SizedBox(width: widget.style.width, height: widget.style.height);
    }

    final wheel = widget.looping
        ? _loopingWheel(context, range)
        : _nonLoopingWheel(context, range);

    return SizedBox(
      width: widget.style.width,
      height: widget.style.height,
      child: wheel,
    );
  }

  Widget _loopingWheel(BuildContext context, int range) {
    return ListWheelScrollView.useDelegate(
      itemExtent: widget.style.itemExtent,
      childDelegate: ListWheelChildBuilderDelegate(
        builder: _loopingItemBuilderFactory(range),
      ),
      controller: widget.controller?._scrollController,
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
      controller: widget.controller?._scrollController,
      onSelectedItemChanged: _onSelectedItemChangedFactory(range),
      physics: const FixedExtentScrollPhysics(),
      diameterRatio: widget.style.diameterRatio,
      squeeze: widget.style.squeeze,
      overAndUnderCenterOpacity: widget.style.betweenItemOpacity,
      magnification: widget.style.magnification,
      children: List.generate(range, _nonLoopingItemBuilderFactory(range)),
    );
  }

  Widget Function(BuildContext, int) _loopingItemBuilderFactory(int range) {
    return (widget.selectBuilder == null)
        ? (context, index) => widget.builder(context, index % range)
        : (context, index) {
            final relativeIndex = index % range;
            final builder = (_current == relativeIndex)
                ? widget.selectBuilder!
                : widget.builder;
            return builder(context, relativeIndex);
          };
  }

  Widget Function(int) _nonLoopingItemBuilderFactory(int range) {
    return (widget.selectBuilder == null)
        ? (index) => widget.builder(context, index)
        : (index) {
            final relativeIndex = index % range;
            final builder = (_current == relativeIndex)
                ? widget.selectBuilder!
                : widget.builder;
            return builder(context, relativeIndex);
          };
  }

  void Function(int)? _onSelectedItemChangedFactory(int range) {
    if (widget.selectBuilder == null) {
      return (int value) {
        widget.controller?._update(value);
        widget.onSelectedItemChanged?.call(value % range);
      };
    } else {
      return (int value) {
        widget.controller?._update(value);
        setState(() => _current = value % range);
        widget.onSelectedItemChanged?.call(_current!);
      };
    }
  }
}
