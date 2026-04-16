# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [2.0.0] - 2026-04-16

### Breaking Changes
- 🎨 **Flutter `Color` type** — `color` parameter changed from `String?` to `Color?`, `colors` from `List<String>?` to `List<Color>?`
- 🧩 **New API style** — Generated code now uses static getter accessors (like `assets.gen.dart`) instead of enum + Widget pattern
  - Before: `IconFont(IconNames.home, color: '#ff0000')`
  - After: `IconFont.home.svg(color: Colors.red)`
- 📛 **Removed `IconNames` enum** — Icons are now accessed as static getters on the class directly
- 📦 **Per-source data class** — Each source generates its own data class (`RData`, `IconFontData`, etc.) to avoid naming conflicts

### Added
- ✨ `{ClassName}Data` class with `.svg()` method for rendering icons
- 🎨 Built-in `_ColorToHex` private extension — generated files are self-contained, no external color extension dependency
- 📖 Updated README.md and README_CN.md with new API examples

### Improved
- 🧹 Cleaner generated code — no enum, no switch statement, no string-to-enum conversion
- 🔍 Better IDE discoverability — type `R.` to see all icons via auto-complete

## [1.0.3] - 2025-07-19

### Fixed
- 🐛 Fixed critical type errors in configuration factory constructor
- 🔧 Removed deprecated lint rules (invariant_booleans, iterable_contains_unrelated_type, list_remove_unrelated_type, prefer_equal_for_default_values)
- 📝 Fixed dangling library doc comments by adding proper library declaration
- 🧪 Cleaned up test files: removed unused imports and variables, fixed unnecessary null assertions
- ✅ Resolved all flutter analyze errors and warnings

### Improved
- 🎯 Enhanced type safety with proper type casting in configuration parsing
- 📋 Better code quality compliance with latest Dart analysis rules
- 🧹 Cleaner test code without unused dependencies

## [1.0.2] - 2025-07-06

### Changed
- 📚 Separated documentation into English (README.md) and Chinese (README_CN.md) versions
- 🔧 Enhanced build configuration to prevent conflicts with other generators
- 📋 Improved troubleshooting section with build conflict resolution
- 🎨 Removed redundant pub package badges for cleaner documentation

### Fixed
- 🐛 Fixed build conflicts by limiting builder scope in build.yaml
- 🔨 Changed output file extension from .g.dart to .iconfont.g.dart to avoid conflicts
- 📖 Fixed duplicate content in Chinese documentation

### Improved
- 🌐 Better internationalization with separate language documentation
- 🛠️ Enhanced build.yaml configuration with specific file targeting
- 📚 Added detailed solutions for common build conflicts

## [1.0.1] - 2025-06-11

### Changed
- 📚 Updated documentation with better examples and usage instructions
- 🔧 Enhanced error handling and validation
- 🎨 Improved code formatting and linting compliance

### Fixed
- 🐛 Minor bug fixes and stability improvements
- 📋 Fixed example app configuration and dependencies

## [1.0.0] - 2025-05-31

### Added
- 🚀 Command line tool for generating Flutter icon widgets from iconfont.cn
- 🎨 Multi-color icon support with custom color rendering
- 📦 SVG-based rendering for smaller bundle size (no font files needed)
- 🔄 Automated icon fetching and Dart code generation
- 🛡️ Full null safety support
- ⚡ Global installation support via `dart pub global activate`

### Features
- Convert iconfont.cn symbol URLs to Flutter widgets
- Configurable icon prefix trimming
- Customizable save directory and default icon size
- Support for both single-color and multi-color icons
- Pure Dart components with flutter_svg dependency
- Easy configuration through pubspec.yaml

### Dependencies
- flutter_svg: ^2.0.0
- http: ^1.0.0  
- xml: ^6.3.0
- path: ^1.8.3
- yaml: ^3.1.2

### Requirements
- Dart SDK: >=2.17.0 <4.0.0
- Flutter: >=3.0.0
