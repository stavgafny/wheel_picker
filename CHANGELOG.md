## 0.0.1 — Initial Release (2023-09-11)

- Added the `Wheel Picker` package to the repository.
- Included basic documentation in the README.
- Provided examples for using the package.
- Listed key features and installation instructions.

This release contains the `WheelPicker` widget with `WheelPickerController` and `WheelPickerStyle`.

---

## 0.0.2 — Documentation Update (2023-09-11)

- Updated package README documentation.

---

## 0.0.3 — Pubspec Update (2023-09-20)

- Updated package pubspec to use the repository instead of the homepage.

---

## 0.0.4 — Horizontal Scrolling Support (2023-12-25)

- Added support for horizontal scrolling, addressing [#1](https://github.com/stavgafny/wheel_picker/issues/1).
- **Breaking Change**: Removed `width` and `height` parameters.
- **New Feature**: Introduced `size` parameter for specifying wheel size for both scroll directions.

---

## 0.0.5 — Controller Improvements (2024-07-04)

- Added support for updating `itemCount` and more control for moving between the wheel, addressing [#2](https://github.com/stavgafny/wheel_picker/issues/2).
- Added controller's `.shiftTo` and `.setCurrent` methods.
- `itemCount` can now be changed using the wheel picker controller or reactively through the wheel picker widget.

---

## 0.1.0 — Full Size Control (2024-08-09)

- **Breaking Change**: The `size` property has been removed.
- Developers now have full control over the widget's size and constraints, addressing [#3](https://github.com/stavgafny/wheel_picker/issues/3) and [#4](https://github.com/stavgafny/wheel_picker/issues/4). By default, the widget will take up as much space as possible.
- Updated the README to reflect the changes.

---

## 0.1.1 — Refactor & README Fixes (2024-08-31)

- Refactored import structure: integrated `WheelPickerController` as part of `WheelPicker`.
- Updated README file to fix typos and improve clarity.

---

## 0.2.0 — Interaction Tracking (2024-12-29)

- **New Feature**: Added support for tracking interaction types (`tap`, `drag`, `control`, `mounted`) during `onIndexChanged`, addressing [#5](https://github.com/stavgafny/wheel_picker/issues/5).
- Improved code structure and organization.

---

## 0.2.1 — Naming & Formatting (2024-12-31)

- Refined naming for improved clarity.
- Reformatted code to align with pub's static analysis standards.

---

## 0.2.2 — SDK & Example Updates (2025-06-21)

- Lowered SDK constraints to support a wider range of Dart and Flutter versions.
- Improved README: updated the basic example’s `onIndexChanged` usage and added an example showing how to listen for scroll end events.

---

## 0.3.0 — Infinite Wheels & Performance (2026-04-04)

- **New Feature**: Added support for infinite wheels in both directions.
- **Performance Improvement**: Regular wheels with a large number of items now use a builder instead of `List.generate`.
- **Non-breaking Change**: `itemCount` now allows `null` without breaking existing implementations.
- **Examples**: Added a second example demonstrating switching logic with the infinite wheel and updated all examples to follow the newest Flutter SDK.

---

## 0.4.0 — Mouse Input Support (2026-10-06)

- **New Feature**: Added support for mouse dragging while preserving the application's configured drag devices.
- **Interaction Tracking**: Added `WheelPickerInteractionType.scroll` for mouse-wheel scrolling.
- **Bug Fix**: Mouse-wheel scrolling now reports `scroll` instead of the previous interaction type in `onIndexChanged`, fixing [#10](https://github.com/stavgafny/wheel_picker/issues/10).
