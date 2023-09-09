part of './wheel_picker_controller.dart';

/// A customizable scrolling wheel interface for selecting items, such as numbers, dates, or any value of your choice.
///
/// Key Features:
/// - Supports both looping and non-looping scrolling behavior.
/// - Customizable appearance and styling through `WheelPickerStyle`.
/// - Easily integrates with a controller for precise control and synchronization.
/// - Enables tap gestures for intuitive navigation through the wheel.
/// - Provides the ability to highlight the selected item with a color shader.
/// - Allows mounting `WheelPickerController`s and automatically shifting them when looped.
///
/// Usage:
/// `WheelPicker` is highly configurable and can be adapted to different use cases by specifying the builder function, initial settings, and style properties. It's a valuable component for creating user-friendly and visually appealing selection interfaces in your Flutter applications.
///
/// Example:
/// ```dart
/// WheelPicker(
///   builder: (context, index) {
///     // Define how each item in the wheel should be rendered.
///     return Text('Item $index');
///   },
///   itemCount: 10, // Number of items in the wheel.
///   initialIndex: 2, // Initial selected item.
///   looping: true, // Enable looping behavior.
///   selectedIndexColor: Colors.blue, // Color to highlight the selected item.
///   enableTap: true, // Allow tap gestures for navigation.
///   onIndexChanged: (index) {
///     // Handle index changes.
///     print('Selected index: $index');
///   },
///   style: WheelPickerStyle(
///     // Customize the appearance and behavior.
///     width: 200,
///     height: 150,
///     itemExtent: 50,
///     // ...
///   ),
/// )
/// ```
///
/// Simplify the process of creating scrollable selection wheels in Flutter, making it easier to build interactive and engaging user interfaces.

class WheelPicker extends StatelessWidget {
  /// Callback for creating item widgets based on their index.
  final Widget Function(BuildContext context, int index) builder;

  /// The total number of items. This is used when no controller is provided.
  final int? itemCount;

  /// A controller for retrieving the selected item index, controlling wheel behavior, shifting it, and enabling mounting of additional [WheelPickerController] controllers for shifting them when looping.
  ///
  /// If a controller is initialized, [itemCount] and [initialIndex] must not be specified.
  final WheelPickerController? controller;

  /// The initially selected item index. Use this property when not using a [controller].
  final int? initialIndex;

  /// Whether the wheel should support infinite looping, allowing it to loop both forward and backward.
  ///
  /// Must be `true` for automatic shifting for mounted controllers.
  final bool looping;

  /// The color used to highlight the selected item(center) using a shader mask.
  final Color? selectedIndexColor;

  /// Whether to enable tap gestures for item selection.
  ///
  /// A controller must be specified for this to work.
  final bool enableTap;

  /// Callback function that is called for when the selected item index changes.
  final void Function(int index)? onIndexChanged;

  /// Defines the appearance and behavior style for the `WheelPicker`.
  final WheelPickerStyle style;

  /// Creates a `WheelPicker` widget with customizable options.
  ///
  /// Use this constructor to create a scrollable selection wheel with specific settings. You can define the appearance, behavior, and provide callbacks for user interaction.
  const WheelPicker({
    required this.builder,
    this.itemCount,
    this.controller,
    this.initialIndex,
    this.looping = true,
    this.selectedIndexColor,
    this.enableTap = false,
    this.onIndexChanged,
    this.style = const WheelPickerStyle(),
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
    if (range <= 0) return SizedBox(width: style.width, height: style.height);

    controller?._attach(looping, style.shiftAnimationStyle);

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

  /// Factory method that updates possible [controller] and calls possible [onIndexChanged]
  /// with the relative based on `index` and given `range`.
  void Function(int)? _onIndexChangedMethodFactory(int range) {
    return (int index) {
      controller?._update(index);
      onIndexChanged?.call(index % range);
    };
  }

  /// Constructs a looping scroll wheel with items that are passed to a delegate with lazily built during layout.
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
      overAndUnderCenterOpacity: style.surroundingOpacity,
      magnification: style.magnification,
    );
  }

  /// Constructs a non looping scroll wheel with items that are passed to a delegate with lazily built during layout.
  Widget _nonLoopingWheel(BuildContext context, int range) {
    return ListWheelScrollView(
      itemExtent: style.itemExtent,
      controller: controller?._scrollController,
      onSelectedItemChanged: _onIndexChangedMethodFactory(range),
      physics: const FixedExtentScrollPhysics(),
      diameterRatio: style.diameterRatio,
      squeeze: style.squeeze,
      overAndUnderCenterOpacity: style.surroundingOpacity,
      magnification: style.magnification,
      children: List.generate(range, (index) => builder(context, index)),
    );
  }

  /// Wrapps wheel with a [GestureDetector] to register tap events and based on
  /// the tap location it shifts the wheel.
  ///
  /// The way this is done is by getting the tap location offset from the center
  /// and if it is above half the itemExtent then it shifts up or down according
  /// to whether an offset is positive or negative.
  /// If the offset is smaller then half the itemExtent, it does nothing.
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

  /// Wrapps wheel with a [ShaderMask] of [BlendMode.srcATop] and places it on top
  /// of the wheel's center at height of the `itemExtent` and `magnification`.
  Widget _centerColorShaderMaskWrapper({required Widget? wheel}) {
    return ShaderMask(
      blendMode: BlendMode.srcATop,
      shaderCallback: (Rect bounds) {
        final v =
            (1 - (style.itemExtent * style.magnification) / style.height) * .5;

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
