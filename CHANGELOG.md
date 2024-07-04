## 0.0.1 (Initial Release)

- Added the "Wheel Picker" package to the repository.
- Included basic documentation in the README.
- Provided examples for using the package.
- Listed key features and installation instructions.

This release contains the `WheelPicker` widget with `WheelPickerController` and `WheelPickerStyle`.

## Version 0.0.2:

- Updated package README documentation.

## Version 0.0.3:

- Updated package pubspec to have the repository instead of the homepage.

## Version 0.0.4:

- Added support for horizontal scrolling.
- **Breaking Change**: Removed `width` and `height` parameters.
- **New Feature**: Introduced `size` parameter for specifying wheel size for both scroll directions.

## Version 0.0.5:

Added support for updating `itemCount` and more control for moving between the wheel.
- Added controller's `.shiftTo` and `.setCurrent` methods.
- `itemCount` can now be changed using the wheel picker controller or reactively through the wheel picker widget.