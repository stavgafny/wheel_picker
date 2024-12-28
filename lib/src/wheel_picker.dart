import 'dart:math' as math;

import 'package:flutter/material.dart';
import './wheel_picker_style.dart';

part './wheel_picker_controller.dart';

/// A customizable scrolling wheel interface for selecting items, such as numbers, dates, or any value of your choice.
///
/// Key Features:
/// - Supports both looping and non-looping scrolling behavior.
/// - Customizable appearance and styling through `WheelPickerStyle`.
/// - Enables tap gestures for intuitive navigation through the wheel.
/// - Easily integrates with a controller for precise control and synchronization.
/// - Provides the ability to highlight the selected item with a color shader.
///
/// For more control, use it with the `WheelPickerController`.
///
/// > _Note: If not wrapped or constrained, the widget will take up all available space._
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
///   onIndexChanged: (index, interactionType) {
///     // Handle index changes.
///     print('Selected index: $index from interaction: ${interactionType.name}');
///   },
///   style: WheelPickerStyle(
///     // Customize the appearance and behavior.
///     itemExtent: 50,
///     diameterRatio: .8
///     // ...
///   ),
/// )
/// ```
///
/// Simplify the process of creating scrollable selection wheels in Flutter, making it easier to build interactive and engaging user interfaces.
class WheelPicker extends StatefulWidget {
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

  /// Determines how the wheel is oriented and scrolled.
  final Axis scrollDirection;

  /// The color used to highlight the selected item(center) using a shader mask.
  final Color? selectedIndexColor;

  /// Whether to enable tap gestures for item selection.
  final bool enableTap;

  /// Callback function triggered when the selected item index changes.
  ///
  /// Provides the updated [index] and the [interactionType] that caused the change.
  final void Function(int index, WheelPickerInteractionType interactionType)? onIndexChanged;

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
    this.scrollDirection = Axis.vertical,
    this.selectedIndexColor,
    this.enableTap = true,
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
        );

  @override
  State<WheelPicker> createState() => _WheelPickerState();
}

class _WheelPickerState extends State<WheelPicker> {
  /// Creates a [WheelPickerController] instance based on the specified controller,
  /// or falls back to creating a new one if no controller is provided.
  ///
  /// If `_controller` falls back to being created, it implies that there is no
  /// specified controller, and consequently, `itemCount` must not be null.
  ///
  /// Note that if a new controller is made, it also gets disposed within the widget's scope.
  late final WheelPickerController _controller = widget.controller ??
      WheelPickerController(
        itemCount: widget.itemCount!,
        initialIndex: widget.initialIndex ?? WheelPickerController._defaultInitialIndex,
      );

  /// Retrieves the range (item count) from the already initialized [_controller].
  int _getRange() => _controller.itemCount;

  /// Attaches the controller to the widget, configuring looping and shift animation style.
  @override
  void initState() {
    // Ensure itemCount is valid.
    assert(_getRange() > 0, "itemCount can't be less or equal to zero.");

    // Attach the controller and configures its behavior.
    _controller._attach();
    _controller._updateShiftAnimationStyle(widget.style.shiftAnimationStyle);

    super.initState();
  }

  /// Update widget props for any possible changes.
  ///
  /// This is to update properties changes with Hot-Reload without needing to Hot-Restart.
  @override
  void didUpdateWidget(covariant WheelPicker oldWidget) {
    _controller._updateShiftAnimationStyle(widget.style.shiftAnimationStyle);

    // In the case the widget's itemCount property is given then update the internal controller's itemCount.
    if (widget.itemCount != null && widget.itemCount != _controller.itemCount) {
      _controller.itemCount = widget.itemCount!;
      // Also update the internal controller's current to its initialIndex.
      _controller.setCurrent(_controller.initialIndex);
    }

    super.didUpdateWidget(oldWidget);
  }

  /// Dispose of the [_controller] if it's not the specified controller but was instead created within the widget's scope.
  @override
  void dispose() {
    if (_controller != widget.controller) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final range = _getRange();

    Widget wheel = (widget.looping ? _loopingWheel : _nonLoopingWheel)(context, range);

    wheel = _gestureDetectsWrapper(wheel: wheel, enableTap: widget.enableTap);

    if (widget.selectedIndexColor != null) {
      wheel = _centerColorShaderMaskWrapper(wheel: wheel);
    }

    wheel = _scrollDirectionWrapper(
      rotateClockwise: false,
      child: wheel,
    );

    return wheel;
  }

  /// Factory method that updates possible [widget.controller] and calls possible [widget.onIndexChanged]
  /// with the relative based on `index` and given `range`.
  void Function(int)? _onIndexChangedMethodFactory(int range) {
    return (int index) {
      _controller._update(index);
      widget.onIndexChanged?.call(index % range, _controller._interactionType);
    };
  }

  /// Constructs a looping scroll wheel with items that are passed to a delegate with lazily built during layout.
  Widget _loopingWheel(BuildContext context, int range) {
    return ListWheelScrollView.useDelegate(
      itemExtent: widget.style.itemExtent,
      childDelegate: ListWheelChildBuilderDelegate(
        builder: (context, index) => _scrollDirectionWrapper(
          rotateClockwise: true,
          child: widget.builder(context, index % range),
        ),
      ),
      controller: _controller._scrollController,
      onSelectedItemChanged: _onIndexChangedMethodFactory(range),
      physics: const FixedExtentScrollPhysics(),
      diameterRatio: widget.style.diameterRatio,
      squeeze: widget.style.squeeze,
      overAndUnderCenterOpacity: widget.style.surroundingOpacity,
      magnification: widget.style.magnification,
    );
  }

  /// Constructs a non looping scroll wheel with items that are passed to a delegate with lazily built during layout.
  Widget _nonLoopingWheel(BuildContext context, int range) {
    return ListWheelScrollView(
      itemExtent: widget.style.itemExtent,
      controller: _controller._scrollController,
      onSelectedItemChanged: _onIndexChangedMethodFactory(range),
      physics: const FixedExtentScrollPhysics(),
      diameterRatio: widget.style.diameterRatio,
      squeeze: widget.style.squeeze,
      overAndUnderCenterOpacity: widget.style.surroundingOpacity,
      magnification: widget.style.magnification,
      children: List.generate(range, (index) {
        return _scrollDirectionWrapper(
          rotateClockwise: true,
          child: widget.builder(context, index),
        );
      }),
    );
  }

  /// Rotates child if [widget.scrollDirection] is horizontal.
  ///
  /// Rotation is either +90 or -90 degrees based on [rotateClockwise].
  /// (used to rotate the wheel and its items on different directions to achieve
  /// horizontal scroll view).
  Widget _scrollDirectionWrapper({
    required bool rotateClockwise,
    required Widget child,
  }) {
    if (widget.scrollDirection == Axis.vertical) return child;
    return Transform.rotate(
      angle: (math.pi * (rotateClockwise ? 1 : -1)) / 2,
      child: child,
    );
  }

  /// Wraps the [wheel] widget with a [GestureDetector] to detect tap and drag gestures.
  ///
  /// If [enableTap] is true, the method handles tap interactions to shift the wheel.
  /// The tap location is calculated as a ratio from -1 to 1, with 0 representing the center of the wheel.
  /// If the tap's offset exceeds the wheel's `itemExtent` ratio, the wheel will shift either up or down,
  /// depending on the direction of the offset. A negative offset (above center) shifts the wheel up,
  /// and a positive offset (below center) shifts it down. The interaction type is set to `WheelPickerInteractionType.tap`
  /// when a tap is detected.
  ///
  /// If [enableTap] is false, tap interactions are disabled, and no shift occurs on tap.
  ///
  /// The drag interaction sets the interaction type to `drag`.
  Widget _gestureDetectsWrapper({required Widget wheel, required bool enableTap}) {
    // The layout builder is for getting the maxHeight which is the wheel size.
    return LayoutBuilder(
      builder: (context, constraints) {
        final wheelSize = constraints.maxHeight;
        final offCenterRatio = (widget.style.itemExtent / wheelSize);
        return GestureDetector(
          onTapUp: enableTap
              ? (details) {
                  final tapLocation = details.localPosition.dy;
                  final normalizedLocation = -1.0 + ((tapLocation / wheelSize) * 2.0);

                  if (normalizedLocation.abs() >= offCenterRatio) {
                    normalizedLocation > 0
                        ? _controller._interactionShiftDown(WheelPickerInteractionType.tap)
                        : _controller._interactionShiftUp(WheelPickerInteractionType.tap);
                  }
                }
              : null,
          onPanDown: (details) => _controller._setInteractionType(WheelPickerInteractionType.drag),
          child: wheel,
        );
      },
    );
  }

  /// Wrapps wheel with a [ShaderMask] of [BlendMode.srcATop] and places it on top
  /// of the wheel's center with size of the `itemExtent` and `magnification`.
  Widget _centerColorShaderMaskWrapper({required Widget? wheel}) {
    return LayoutBuilder(
      // The layout builder is for getting the maxHeight which is the wheel size.
      builder: (context, constraints) {
        final wheelSize = constraints.maxHeight;
        final itemView = widget.style.itemExtent * widget.style.magnification;

        // Shader stops.
        final v = (1 - itemView / wheelSize) * .5;

        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (Rect bounds) {
            return LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [v, v, 1 - v, 1 - v],
              colors: [
                Colors.transparent,
                widget.selectedIndexColor!,
                widget.selectedIndexColor!,
                Colors.transparent,
              ],
            ).createShader(bounds);
          },
          child: wheel,
        );
      },
    );
  }
}
