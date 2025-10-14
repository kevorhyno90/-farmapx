# Changelog

## [Unreleased]

### Added

- Created `CHANGELOG.md` to document changes.
- Created `fireb/lib/services` directory and moved `app_state.dart` into it.
- Created `fireb/lib/models` directory and created model files for each data type.
- Created `fireb/lib/widgets` directory and created `csv_input_dialog.dart`.


### Changed

- Moved all Dart files from the root directory to the `fireb/lib` directory.
- Updated `pubspec.yaml` to reflect the new project name `farm_management_app`.
- Updated all import statements in the Dart files to use the new package name and file structure.
- Refactored the code to use a more organized and modular structure.

### Fixed

- Corrected import paths in all Dart files.
- Fixed a bug in `feed_formulation_page.dart` where the `changed` variable was not being checked for null before being used.
