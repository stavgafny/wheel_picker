import 'package:flutter/material.dart';

/// WheelPicker styling options.
///
/// This class allows you to customize the appearance of the WheelPicker widget.
class WheelPickerStyle {
  static const _defaultItemExtent = 20.0;
  static const _defaultDiameterRatio = 1.0;
  static const _defaultSqueeze = 1.0;
  static const _defaultSurroundingOpacity = 1.0;
  static const _defaultMagnification = 1.0;
  static const _defaultShiftAnimationStyle = WheelShiftAnimationStyle(
    duration: Duration(milliseconds: 200),
    curve: Curves.decelerate,
  );

  /// The extent of each item in the WheelPicker. It determines the size of
  /// each item displayed in the wheel.
  final double itemExtent;

  /// The ratio of the wheel's diameter to the item extent. It affects the curvature
  /// and spacing of items within the wheel.
  final double diameterRatio;

  /// The degree to which items in the wheel are squeezed together. A value greater
  /// than 1 will compress items, while a value less than 1 will expand them.
  final double squeeze;

  /// The opacity of items surrounding the selected(centered) item.
  final double surroundingOpacity;

  /// The magnification factor applied to the selected item in the center of the wheel.
  final double magnification;

  /// The animation style for shifting items in the WheelPicker.
  final WheelShiftAnimationStyle shiftAnimationStyle;

  /// WheelPicker styling options.
  ///
  /// This class allows you to customize the appearance and behavior of the
  /// WheelPicker widget, including dimensions, item extent, and animation style.
  const WheelPickerStyle({
    this.itemExtent = _defaultItemExtent,
    this.diameterRatio = _defaultDiameterRatio,
    this.squeeze = _defaultSqueeze,
    this.surroundingOpacity = _defaultSurroundingOpacity,
    this.magnification = _defaultMagnification,
    this.shiftAnimationStyle = _defaultShiftAnimationStyle,
  })  : assert(itemExtent > 0),
        assert(squeeze > 0),
        assert(surroundingOpacity >= 0 && surroundingOpacity <= 1),
        assert(magnification > 0);

  /// Creates a copy of the current [WheelPickerStyle] with the specified
  /// properties overridden.
  WheelPickerStyle copyWith({
    double? itemExtent,
    double? diameterRatio,
    double? squeeze,
    double? surroundingOpacity,
    double? magnification,
    WheelShiftAnimationStyle? shiftAnimationStyle,
  }) {
    return WheelPickerStyle(
      itemExtent: itemExtent ?? this.itemExtent,
      diameterRatio: diameterRatio ?? this.diameterRatio,
      squeeze: squeeze ?? this.squeeze,
      surroundingOpacity: surroundingOpacity ?? this.surroundingOpacity,
      magnification: magnification ?? this.magnification,
      shiftAnimationStyle: shiftAnimationStyle ?? this.shiftAnimationStyle,
    );
  }

  @override
  String toString() {
    return 'WheelPickerStyle(itemExtent: $itemExtent, diameterRatio: $diameterRatio, squeeze: $squeeze, surroundingOpacity: $surroundingOpacity, magnification: $magnification, shiftAnimationStyle: $shiftAnimationStyle)';
  }
}

/// The animation style for shifting items in the WheelPicker widget.
class WheelShiftAnimationStyle {
  final Duration duration;
  final Curve curve;
  const WheelShiftAnimationStyle({required this.duration, required this.curve});

  /// Creates a copy of the current [WheelShiftAnimationStyle] with the specified
  /// properties overridden.
  WheelShiftAnimationStyle copyWith({
    Duration? duration,
    Curve? curve,
  }) {
    return WheelShiftAnimationStyle(
      duration: duration ?? this.duration,
      curve: curve ?? this.curve,
    );
  }

  @override
  String toString() =>
      'WheelShiftAnimationStyle(duration: $duration, curve: $curve)';
}
