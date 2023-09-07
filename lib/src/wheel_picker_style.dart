import 'package:flutter/material.dart';

class WheelPickerStyle {
  static const _defaultWidth = 50.0;
  static const _defaultHeight = 150.0;
  static const _defaultItemExtent = 20.0;
  static const _defaultDiameterRatio = 1.0;
  static const _defaultSqueeze = 1.0;
  static const _defaultBetweenItemOpacity = .25;
  static const _defaultMagnification = 1.25;
  static const _defaultShiftStyle = WheelShiftStyle(
    duration: Duration(milliseconds: 200),
    curve: Curves.decelerate,
  );

  static const defaultStyle = WheelPickerStyle();

  final double width;
  final double height;
  final double itemExtent;
  final double diameterRatio;
  final double squeeze;
  final double betweenItemOpacity;
  final double magnification;
  final WheelShiftStyle shiftStyle;

  const WheelPickerStyle({
    this.width = _defaultWidth,
    this.height = _defaultHeight,
    this.itemExtent = _defaultItemExtent,
    this.diameterRatio = _defaultDiameterRatio,
    this.squeeze = _defaultSqueeze,
    this.betweenItemOpacity = _defaultBetweenItemOpacity,
    this.magnification = _defaultMagnification,
    this.shiftStyle = _defaultShiftStyle,
  })  : assert(itemExtent > 0),
        assert(squeeze > 0),
        assert(betweenItemOpacity >= 0 && betweenItemOpacity <= 1),
        assert(magnification > 0);

  WheelPickerStyle copyWith({
    double? width,
    double? height,
    double? itemExtent,
    double? diameterRatio,
    double? squeeze,
    double? betweenItemOpacity,
    double? magnification,
    WheelShiftStyle? shiftStyle,
  }) {
    return WheelPickerStyle(
      width: width ?? this.width,
      height: height ?? this.height,
      itemExtent: itemExtent ?? this.itemExtent,
      diameterRatio: diameterRatio ?? this.diameterRatio,
      squeeze: squeeze ?? this.squeeze,
      betweenItemOpacity: betweenItemOpacity ?? this.betweenItemOpacity,
      magnification: magnification ?? this.magnification,
      shiftStyle: shiftStyle ?? this.shiftStyle,
    );
  }

  @override
  String toString() {
    return 'WheelPickerStyle(width: $width, height: $height, itemExtent: $itemExtent, diameterRatio: $diameterRatio, squeeze: $squeeze, betweenItemOpacity: $betweenItemOpacity, magnification: $magnification)';
  }
}

class WheelShiftStyle {
  final Duration duration;
  final Curve curve;
  const WheelShiftStyle({required this.duration, required this.curve});

  WheelShiftStyle copyWith({
    Duration? duration,
    Curve? curve,
  }) {
    return WheelShiftStyle(
      duration: duration ?? this.duration,
      curve: curve ?? this.curve,
    );
  }

  @override
  String toString() => 'WheelShiftStyle(duration: $duration, curve: $curve)';
}
