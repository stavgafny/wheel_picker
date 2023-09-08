part of './wheel_picker_controller.dart';

class WheelPicker extends StatelessWidget {
  final Widget Function(BuildContext context, int index) builder;
  final int? itemCount;
  final WheelPickerController? controller;
  final int? initialIndex;
  final bool looping;
  final Color? selectedIndexColor;
  final bool enableTap;
  final void Function(int index)? onIndexChanged;
  final WheelPickerStyle style;

  const WheelPicker({
    required this.builder,
    this.itemCount,
    this.controller,
    this.initialIndex,
    this.looping = true,
    this.selectedIndexColor,
    this.enableTap = false,
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
        ),
        assert(
          !(enableTap == true && controller == null),
          "Tap events must work with a controller.",
        );

  @override
  Widget build(BuildContext context) {
    final range = (itemCount ?? controller?.itemCount)!;
    assert(range > 0, "itemCount must be a positive number");
    controller?._attach(looping, style.shiftStyle);

    Widget wheel = looping
        ? _loopingWheel(context, range)
        : _nonLoopingWheel(context, range);

    if (enableTap) {
      wheel = _tapDetectsWrapper(wheel: wheel);
    }

    if (selectedIndexColor != null) {
      wheel = _centerColorShaderMaskWrapper(wheel: wheel);
    }

    return SizedBox(
      width: style.width,
      height: style.height,
      child: wheel,
    );
  }

  void Function(int)? _onIndexChangedMethodFactory(int range) {
    return (int index) {
      controller?._update(index);
      onIndexChanged?.call(index % range);
    };
  }

  Widget _loopingWheel(BuildContext context, int range) {
    return ListWheelScrollView.useDelegate(
      itemExtent: style.itemExtent,
      childDelegate: ListWheelChildBuilderDelegate(
        builder: (context, index) => builder(context, index % range),
      ),
      controller: controller?._scrollController,
      onSelectedItemChanged: _onIndexChangedMethodFactory(range),
      physics: const FixedExtentScrollPhysics(),
      diameterRatio: style.diameterRatio,
      squeeze: style.squeeze,
      overAndUnderCenterOpacity: style.betweenItemOpacity,
      magnification: style.magnification,
    );
  }

  Widget _nonLoopingWheel(BuildContext context, int range) {
    return ListWheelScrollView(
      itemExtent: style.itemExtent,
      controller: controller?._scrollController,
      onSelectedItemChanged: _onIndexChangedMethodFactory(range),
      physics: const FixedExtentScrollPhysics(),
      diameterRatio: style.diameterRatio,
      squeeze: style.squeeze,
      overAndUnderCenterOpacity: style.betweenItemOpacity,
      magnification: style.magnification,
      children: List.generate(range, (index) => builder(context, index)),
    );
  }

  Widget _tapDetectsWrapper({required Widget wheel}) {
    final offCenterHeight = (style.itemExtent * .5) / style.height;
    return GestureDetector(
      onTapUp: (details) {
        final tapLocation = details.localPosition.dy;
        final normalizedLocation = (tapLocation / style.height) - .5;
        if (normalizedLocation > offCenterHeight) {
          controller?.shiftDown();
        } else if (normalizedLocation < -offCenterHeight) {
          controller?.shiftUp();
        }
      },
      child: wheel,
    );
  }

  Widget _centerColorShaderMaskWrapper({required Widget? wheel}) {
    return ShaderMask(
      blendMode: BlendMode.srcATop,
      shaderCallback: (Rect bounds) {
        final centerHeightRatio = _mapValue(
          style.itemExtent * style.magnification,
          0.0,
          style.height,
          0.0,
          1.0,
        );
        final v = (1 - centerHeightRatio) * .5;

        return LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [v, v, 1 - v, 1 - v],
          colors: [
            Colors.transparent,
            selectedIndexColor!,
            selectedIndexColor!,
            Colors.transparent,
          ],
        ).createShader(bounds);
      },
      child: wheel,
    );
  }
}

double _mapValue(
  double value,
  double inputMin,
  double inputMax,
  double outputMin,
  double outputMax,
) {
  value = value.clamp(inputMin, inputMax);

  return ((value - inputMin) / (inputMax - inputMin)) *
          (outputMax - outputMin) +
      outputMin;
}
