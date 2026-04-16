# Flutter IconFont Generator

[![pub package](https://img.shields.io/pub/v/flutter_iconfont_generator.svg)](https://pub.dev/packages/flutter_iconfont_generator)

[中文文档](./README_CN.md) | English

> A Dart/Flutter code generator for iconfont.cn icons. Convert iconfont.cn icons to Flutter widgets with SVG rendering, supporting multi-source, multi-color icons, Flutter `Color` type and null safety.

## ✨ Features

- 🚀 **Command Line Tool** - Simple command-line interface
- 🎨 **Multi-color Support** - Render multi-color icons with Flutter `Color` type
- 📦 **Pure Components** - No font files needed, uses SVG rendering for smaller bundle size
- 🔄 **Automated Generation** - Automatically fetch latest icons from iconfont.cn and generate Dart code
- 🛡️ **Null Safety** - Full Dart null safety support
- 📦 **Multi-source Support** - Configure multiple iconfont sources with different class names
- ⚡ **Easy Installation** - Global installation via dart pub global activate
- 🧩 **assets.gen.dart Style API** - Static getter accessors like `R.home.svg()`, similar to flutter_gen

## 🚀 Quick Start

### Installation

#### Method 1: Global Installation (Recommended)

```bash
dart pub global activate flutter_iconfont_generator
```

#### Method 2: Add as Dev Dependency

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_svg: ^2.0.0

dev_dependencies:
  flutter_iconfont_generator: ^1.0.0
```

### Configuration

Create an `iconfont.yaml` file in your project root:

**Single source:**

```yaml
# iconfont.yaml
symbol_url: "//at.alicdn.com/t/font_xxx.js"
save_dir: "./lib/iconfont"
trim_icon_prefix: "icon"
default_icon_size: 18
null_safety: true
```

**Multiple sources:**

```yaml
# iconfont.yaml
sources:
  - name: r
    symbol_url: "//at.alicdn.com/t/font_xxx.js"
    save_dir: "./lib/generated"
    trim_icon_prefix: "icon"
    default_icon_size: 18
    null_safety: true

  - name: icon_font
    symbol_url: "//at.alicdn.com/t/font_yyy.js"
    save_dir: "./lib/generated"
    trim_icon_prefix: "icon"
    default_icon_size: 20
    null_safety: true
```

### Generate Icon Code

```bash
# After global installation
iconfont_generator

# Or run directly
dart run flutter_iconfont_generator:iconfont_generator

# Verbose output
iconfont_generator --verbose
```

## 📖 Usage

### Generated Code Structure

Each source generates a file containing:
- A `{ClassName}Data` class — holds the SVG builder and provides the `.svg()` method
- A `{ClassName}` class — contains static getters for every icon

### Basic Usage

```dart
import 'package:your_app/generated/r.dart';

// Default size
R.home.svg()

// Custom size
R.user.svg(size: 24)

// With Flutter Color
R.settings.svg(size: 32, color: Color(0xFFFF0000))

// With Colors constant
R.settings.svg(color: Colors.red)

// Multi-color icons
R.logo.svg(colors: [Colors.red, Colors.green, Colors.blue])
```

### Multiple Sources

```dart
import 'package:your_app/generated/r.dart';
import 'package:your_app/generated/icon_font.dart';

// Source "r" (default size 18)
R.home.svg()

// Source "icon_font" (default size 20)
IconFont.settings.svg(color: Colors.blue)
```

### API Reference

#### `{ClassName}Data.svg()`

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `size` | `double?` | configured `default_icon_size` | Icon size (width & height) |
| `color` | `Color?` | `null` | Single color override for all paths |
| `colors` | `List<Color>?` | `null` | Per-path color overrides for multi-color icons |
| `key` | `Key?` | `null` | Flutter widget key |

## ⚙️ Configuration Options

### Single Source

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `symbol_url` | String | — | **Required.** JavaScript URL from iconfont.cn |
| `save_dir` | String | `./lib/iconfont` | Output directory |
| `trim_icon_prefix` | String | `icon` | Prefix to remove from icon names |
| `default_icon_size` | int | `18` | Default icon size |
| `null_safety` | bool | `true` | Generate null-safe code |

### Multiple Sources

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `sources` | List | — | **Required.** List of icon sources |
| `name` | String | — | **Required.** Source name → PascalCase class name |
| `symbol_url` | String | — | **Required.** JavaScript URL from iconfont.cn |
| `save_dir` | String | `./lib/iconfont` | Output directory |
| `output_file` | String | `{name}.dart` | Output file name |
| `trim_icon_prefix` | String | `icon` | Prefix to remove from icon names |
| `default_icon_size` | int | `18` | Default icon size |
| `null_safety` | bool | `true` | Generate null-safe code |

**`name` → class name mapping:**
- `r` → `R` (data class: `RData`)
- `icon_font` → `IconFont` (data class: `IconFontData`)
- `admin` → `Admin` (data class: `AdminData`)

## 🔗 Getting Your Symbol URL

1. Go to [iconfont.cn](https://www.iconfont.cn/)
2. Open your icon project
3. Go to project settings
4. Copy the Symbol JavaScript URL (e.g. `//at.alicdn.com/t/c/font_xxx_xxx.js`)

![Symbol URL Location](images/symbol-url.png)

## 🚧 Troubleshooting

| Problem | Solution |
|---------|----------|
| Configuration file not found | Ensure `iconfont.yaml` exists in project root, or use `--config` |
| No icons found | Verify your symbol URL is correct and accessible |
| Permission denied | Check write permissions on the output directory |

Use `iconfont_generator --verbose` for detailed debug output.

## 🔧 Design Philosophy

### Why SVG instead of fonts?

1. **Multi-color Support** — SVG naturally supports multi-color rendering
2. **Smaller Bundle** — Only includes used icons
3. **Better Compatibility** — No system font dependency
4. **Code as Icons** — Dart code, easy version control

### Why static getters instead of enum + Widget?

The new API (`R.home.svg()`) is inspired by [flutter_gen](https://pub.dev/packages/flutter_gen)'s `assets.gen.dart` pattern:

- **Discoverable** — IDE auto-complete shows all available icons on `R.`
- **Flexible** — `.svg()` returns a `Widget`, parameters are optional named args
- **Type-safe colors** — Uses Flutter `Color` instead of hex strings
- **No enum boilerplate** — No `IconNames` enum or switch statements in generated code

## 📢 Project Background

Pure Dart rewrite of [flutter-iconfont-cli](https://github.com/iconfont-cli/flutter-iconfont-cli) (no longer maintained).

## 📄 License

MIT — see [LICENSE](LICENSE).
