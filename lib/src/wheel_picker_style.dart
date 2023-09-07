class WheelPickerStyle {
  static const _defaultWidth = 50.0;
  static const _defaultHeight = 150.0;
  static const _defaultItemExtent = 20.0;
  static const _defaultDiameterRatio = 1.0;
  static const _defaultSqueeze = 1.5;
  static const _defaultBetweenItemOpacity = .25;
  static const _defaultMagnification = 1.25;

  static const defaultStyle = WheelPickerStyle();

  final double width;
  final double height;
  final double itemExtent;
  final double diameterRatio;
  final double squeeze;
  final double betweenItemOpacity;
  final double magnification;

  const WheelPickerStyle({
    this.width = _defaultWidth,
    this.height = _defaultHeight,
    this.itemExtent = _defaultItemExtent,
    this.diameterRatio = _defaultDiameterRatio,
    this.squeeze = _defaultSqueeze,
    this.betweenItemOpacity = _defaultBetweenItemOpacity,
    this.magnification = _defaultMagnification,
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
  }) {
    return WheelPickerStyle(
      width: width ?? this.width,
      height: height ?? this.height,
      itemExtent: itemExtent ?? this.itemExtent,
      diameterRatio: diameterRatio ?? this.diameterRatio,
      squeeze: squeeze ?? this.squeeze,
      betweenItemOpacity: betweenItemOpacity ?? this.betweenItemOpacity,
      magnification: magnification ?? this.magnification,
    );
  }
}
