part of './wheel_picker_controller.dart';

class WheelPicker extends StatefulWidget {
  final Widget Function(BuildContext context, int index) builder;
  final int? itemCount;
  final WheelPickerController? controller;
  final int? initialIndex;
  final Widget Function(BuildContext context, int index)? selectedIndexBuilder;
  final bool looping;
  final bool enableTap;
  final void Function(int index)? onIndexChanged;
  final WheelPickerStyle style;

  const WheelPicker({
    required this.builder,
    this.itemCount,
    this.controller,
    this.initialIndex,
    this.selectedIndexBuilder,
    this.looping = true,
    this.enableTap = true,
    this.onIndexChanged,
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
  late WheelPickerController _controller;

  @override
  void initState() {
    _controller = widget.controller ??
        WheelPickerController(
          itemCount: widget.itemCount!,
          initialIndex: widget.initialIndex ?? 0,
        );

    _controller._attach(widget.looping, widget.style.shiftStyle);
    if (widget.selectedIndexBuilder != null) {
      _current = _controller.initialIndex;
    }
    super.initState();
  }

  @override
  void didUpdateWidget(covariant WheelPicker oldWidget) {
    _controller._attach(widget.looping, widget.style.shiftStyle);
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final range = (widget.itemCount ?? _controller.itemCount);
    if (range <= 0) {
      return SizedBox(width: widget.style.width, height: widget.style.height);
    }

    final wheel = widget.looping
        ? _loopingWheel(context, range)
        : _nonLoopingWheel(context, range);

    return SizedBox(
      width: widget.style.width,
      height: widget.style.height,
      child:
          widget.enableTap == true ? _wrapWithTapDetects(wheel: wheel) : wheel,
    );
  }

  Widget _loopingWheel(BuildContext context, int range) {
    return ListWheelScrollView.useDelegate(
      itemExtent: widget.style.itemExtent,
      childDelegate: ListWheelChildBuilderDelegate(
        builder: _loopingItemBuilderFactory(range),
      ),
      controller: _controller._scrollController,
      onSelectedItemChanged: _onIndexChangedFactory(range),
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
      controller: _controller._scrollController,
      onSelectedItemChanged: _onIndexChangedFactory(range),
      physics: const FixedExtentScrollPhysics(),
      diameterRatio: widget.style.diameterRatio,
      squeeze: widget.style.squeeze,
      overAndUnderCenterOpacity: widget.style.betweenItemOpacity,
      magnification: widget.style.magnification,
      children: List.generate(range, _nonLoopingItemBuilderFactory(range)),
    );
  }

  Widget Function(BuildContext, int) _loopingItemBuilderFactory(int range) {
    return (widget.selectedIndexBuilder == null)
        ? (context, index) => widget.builder(context, index % range)
        : (context, index) {
            final relativeIndex = index % range;
            final builder = (_current == relativeIndex)
                ? widget.selectedIndexBuilder!
                : widget.builder;
            return builder(context, relativeIndex);
          };
  }

  Widget Function(int) _nonLoopingItemBuilderFactory(int range) {
    return (widget.selectedIndexBuilder == null)
        ? (index) => widget.builder(context, index)
        : (index) {
            final relativeIndex = index % range;
            final builder = (_current == relativeIndex)
                ? widget.selectedIndexBuilder!
                : widget.builder;
            return builder(context, relativeIndex);
          };
  }

  void Function(int)? _onIndexChangedFactory(int range) {
    if (widget.selectedIndexBuilder == null) {
      return (int index) {
        _controller._update(index);
        widget.onIndexChanged?.call(index % range);
      };
    } else {
      return (int index) {
        _controller._update(index);
        setState(() => _current = index % range);
        widget.onIndexChanged?.call(_current!);
      };
    }
  }

  Widget _wrapWithTapDetects({required Widget wheel}) {
    final viewHeight = widget.style.height;
    final itemHeightRatio = widget.style.itemExtent / viewHeight;
    return GestureDetector(
      onTapUp: (details) {
        final tapLocation = (details.localPosition.dy / viewHeight) - .5;
        if (tapLocation > itemHeightRatio) {
          _controller.shiftDown();
        } else if (tapLocation < -itemHeightRatio) {
          _controller.shiftUp();
        }
      },
      child: wheel,
    );
  }
}
