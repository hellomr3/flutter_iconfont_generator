# Flutter IconFont Generator

[![pub package](https://img.shields.io/pub/v/flutter_iconfont_generator.svg)](https://pub.dev/packages/flutter_iconfont_generator)

[中文文档](./README_CN.md) | English

> A Dart/Flutter code generator for iconfont.cn icons. Convert iconfont.cn icons to Flutter widgets with SVG rendering, supporting multi-source, multi-color icons and null safety.

## ✨ Features

- 🚀 **Command Line Tool** - Simple command-line interface
- 🎨 **Multi-color Support** - Render multi-color icons with custom color support
- 📦 **Pure Components** - No font files needed, uses SVG rendering for smaller bundle size
- 🔄 **Automated Generation** - Automatically fetch latest icons from iconfont.cn and generate Dart code
- 🛡️ **Null Safety** - Full Dart null safety support
- 📦 **Multi-source Support** - Configure multiple iconfont sources with different class names
- ⚡ **Easy Installation** - Global installation via dart pub global activate

## 🚀 Quick Start

### Installation

#### Method 1: Global Installation (Recommended)

Install the command-line tool globally:

```bash
dart pub global activate flutter_iconfont_generator
```

#### Method 2: Add as Dev Dependency

Add to your `pubspec.yaml`:

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
  - name: app
    symbol_url: "//at.alicdn.com/t/font_xxx.js"
    save_dir: "./lib/generated"
    trim_icon_prefix: "icon"
    default_icon_size: 18
    null_safety: true

  - name: admin
    symbol_url: "//at.alicdn.com/t/font_yyy.js"
    save_dir: "./lib/generated"
    output_file: "admin_icons.dart"
    trim_icon_prefix: "icon"
    default_icon_size: 20
    null_safety: true
```

### Generate Icon Code

#### Method 1: Command Line Tool (Recommended)

After global installation:

```bash
# Generate icons using iconfont.yaml configuration
iconfont_generator

# Show verbose output
iconfont_generator --verbose

# Show help
iconfont_generator --help
```

#### Method 2: Direct Dart Execution

If not globally installed:

```bash
# Run from your project root
dart run flutter_iconfont_generator:iconfont_generator
```

## 📖 Usage

### Basic Usage

**Single source:**

```dart
import 'package:your_app/iconfont/iconfont.dart';

// Basic usage
IconFont(IconNames.home)

// With size
IconFont(IconNames.user, size: 24)

// With color
IconFont(IconNames.settings, size: 32, color: '#ff0000')

// With multiple colors (for multi-color icons)
IconFont(IconNames.logo, size: 48, colors: ['#ff0000', '#00ff00', '#0000ff'])
```

**Multiple sources:**

```dart
import 'package:your_app/generated/app.dart';
import 'package:your_app/generated/admin_icons.dart';

// Use app icons
App(IconNames.home)

// Use admin icons
Admin(IconNames.settings)
```

### Command Line Options

```bash
# Basic usage
iconfont_generator

# Custom config file
iconfont_generator --config path/to/iconfont.yaml

# Verbose output
iconfont_generator --verbose

# Show help
iconfont_generator --help
```

## 🔧 Configuration Options

### Single Source Options

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `symbol_url` | String | - | Required. JavaScript URL from iconfont.cn |
| `save_dir` | String | `./lib/iconfont` | Output directory for generated files |
| `trim_icon_prefix` | String | `icon` | Prefix to remove from icon names |
| `default_icon_size` | int | `18` | Default size for icons |
| `null_safety` | bool | `true` | Enable null safety in generated code |

### Multiple Sources Options

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `sources` | List | - | Required. List of icon sources |
| `name` | String | - | Required. Source name, converted to PascalCase for widget class name |
| `symbol_url` | String | - | Required. JavaScript URL from iconfont.cn |
| `save_dir` | String | `./lib/iconfont` | Output directory for generated files |
| `output_file` | String | `{name}.dart` | Output file name |
| `trim_icon_prefix` | String | `icon` | Prefix to remove from icon names |
| `default_icon_size` | int | `18` | Default size for icons |
| `null_safety` | bool | `true` | Enable null safety in generated code |

**Important**: The `name` field is converted to PascalCase for the widget class name:
- `app` → `App`
- `admin` → `Admin`
- `icon_font` → `IconFont`

## 🔗 Getting Your Symbol URL

1. Go to [iconfont.cn](https://www.iconfont.cn/)
2. Create or open your icon project
3. Go to project settings (项目设置)
4. Find "FontClass/Symbol前缀" section
5. Copy the JavaScript URL (should look like `//at.alicdn.com/t/c/font_xxx_xxx.js`)

![Symbol URL Location](images/symbol-url.png)

## 🚧 Troubleshooting

### Common Issues

**"Configuration file not found"**
- Make sure you have an `iconfont.yaml` file in your project root
- Or use `--config` to specify the config file path

**"No iconfont configuration found"**
- Check that your `iconfont.yaml` has valid configuration
- Verify the YAML syntax is correct

**"Please configure a valid symbol_url"**
- Check that your symbol URL is from iconfont.cn and is accessible
- The URL should start with `//at.alicdn.com/`

**"No icons found in the SVG content"**
- Verify your symbol URL is correct
- Check that your iconfont project has icons
- Try accessing the URL in a browser

**Permission denied**
- Make sure you have write permissions to the output directory

### Debug Mode

Use verbose mode to see detailed information:

```bash
iconfont_generator --verbose
```

## 📱 Example

**iconfont.yaml:**

```yaml
sources:
  - name: app
    symbol_url: "//at.alicdn.com/t/font_4663043_7hbwe75j25b.js"
    save_dir: "./lib/generated"
    trim_icon_prefix: "icon"
    default_icon_size: 18
```

**Usage:**

```dart
import 'package:demo/generated/app.dart';

// Use the icon
App(IconNames.home)

// With custom color
App(IconNames.settings, color: '#ff0000')

// With multiple colors
App(IconNames.logo, colors: ['#ff0000', '#00ff00'])
```

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork this repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🔗 Related Links

- [iconfont.cn](https://iconfont.cn) - Alibaba Vector Icon Library
- [Flutter SVG](https://pub.dev/packages/flutter_svg) - Flutter SVG rendering plugin

## 🔧 Design Philosophy

### Why SVG instead of fonts?

1. **Multi-color Support** - SVG naturally supports multi-color rendering
2. **Smaller Bundle Size** - Only includes used icons, no redundant data
3. **Better Compatibility** - No dependency on system fonts, better cross-platform consistency
4. **Code as Icons** - Icons exist as Dart code, easier for version control and management

### Core Advantages

- **Pure Dart Implementation** - Leverages Dart ecosystem, no additional runtime environment needed
- **Compile-time Generation** - Icons are determined at compile time, better runtime performance
- **Type Safety** - Provides type-safe icon references through enums
- **Multi-source Support** - Configure multiple iconfont sources independently

## 📢 Project Background

This project is a pure Dart refactored version based on [flutter-iconfont-cli](https://github.com/iconfont-cli/flutter-iconfont-cli). Since the original repository is no longer maintained, we use this new repository to continue maintaining and developing this project.

---

If this project helps you, please give it a ⭐️ Star!
