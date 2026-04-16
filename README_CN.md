# Flutter IconFont Generator

[![pub package](https://img.shields.io/pub/v/flutter_iconfont_generator.svg)](https://pub.dev/packages/flutter_iconfont_generator)

中文文档 | [English](./README.md)

> 一个用于 iconfont.cn 图标的 Dart/Flutter 代码生成器。将 iconfont.cn 图标转换为 Flutter 组件，支持 SVG 渲染、多源配置、多色彩图标、Flutter `Color` 类型和空安全。

## ✨ 功能特性

- 🚀 **命令行工具** — 简单的命令行接口
- 🎨 **多色彩支持** — 使用 Flutter `Color` 类型渲染多色彩图标
- 📦 **纯组件** — 无需字体文件，使用 SVG 渲染减少包体积
- 🔄 **自动生成** — 自动从 iconfont.cn 获取最新图标并生成 Dart 代码
- 🛡️ **空安全** — 完整的 Dart 空安全支持
- 📦 **多源支持** — 支持配置多个 iconfont 源，每个源独立的类名
- ⚡ **简易安装** — 通过 `dart pub global activate` 全局安装
- 🧩 **assets.gen.dart 风格 API** — 静态 getter 访问器，如 `R.home.svg()`，类似 flutter_gen

## 🚀 快速开始

### 安装

#### 方法一：全局安装（推荐）

```bash
dart pub global activate flutter_iconfont_generator
```

#### 方法二：添加为开发依赖

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_svg: ^2.0.0

dev_dependencies:
  flutter_iconfont_generator: ^1.0.0
```

### 配置

在项目根目录创建 `iconfont.yaml` 文件：

**单源配置：**

```yaml
# iconfont.yaml
symbol_url: "//at.alicdn.com/t/font_xxx.js"
save_dir: "./lib/iconfont"
trim_icon_prefix: "icon"
default_icon_size: 18
null_safety: true
```

**多源配置：**

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

### 生成图标代码

```bash
# 全局安装后
iconfont_generator

# 或直接运行
dart run flutter_iconfont_generator:iconfont_generator

# 详细输出
iconfont_generator --verbose
```

## 📖 使用方法

### 生成代码结构

每个 source 生成一个文件，包含：
- `{ClassName}Data` 类 — 持有 SVG 构建器，提供 `.svg()` 方法
- `{ClassName}` 类 — 包含每个图标的静态 getter

### 基本使用

```dart
import 'package:your_app/generated/r.dart';

// 默认大小
R.home.svg()

// 自定义大小
R.user.svg(size: 24)

// 使用 Flutter Color
R.settings.svg(size: 32, color: Color(0xFFFF0000))

// 使用 Colors 常量
R.settings.svg(color: Colors.red)

// 多色彩图标
R.logo.svg(colors: [Colors.red, Colors.green, Colors.blue])
```

### 多源使用

```dart
import 'package:your_app/generated/r.dart';
import 'package:your_app/generated/icon_font.dart';

// 源 "r"（默认大小 18）
R.home.svg()

// 源 "icon_font"（默认大小 20）
IconFont.settings.svg(color: Colors.blue)
```

### API 参考

#### `{ClassName}Data.svg()`

| 参数 | 类型 | 默认值 | 说明 |
|------|------|--------|------|
| `size` | `double?` | 配置的 `default_icon_size` | 图标大小（宽高） |
| `color` | `Color?` | `null` | 单色覆盖所有路径 |
| `colors` | `List<Color>?` | `null` | 多色彩图标的逐路径颜色覆盖 |
| `key` | `Key?` | `null` | Flutter Widget key |

## ⚙️ 配置参数

### 单源配置

| 参数 | 类型 | 默认值 | 说明 |
|-----|------|--------|------|
| `symbol_url` | String | — | **必填** iconfont.cn 的 Symbol 链接 |
| `save_dir` | String | `./lib/iconfont` | 生成文件的保存目录 |
| `trim_icon_prefix` | String | `icon` | 要移除的图标名前缀 |
| `default_icon_size` | int | `18` | 默认图标大小 |
| `null_safety` | bool | `true` | 是否生成空安全代码 |

### 多源配置

| 参数 | 类型 | 默认值 | 说明 |
|-----|------|--------|------|
| `sources` | List | — | **必填** 图标源列表 |
| `name` | String | — | **必填** 源名称 → 大驼峰类名 |
| `symbol_url` | String | — | **必填** iconfont.cn 的 Symbol 链接 |
| `save_dir` | String | `./lib/iconfont` | 生成文件的保存目录 |
| `output_file` | String | `{name}.dart` | 输出文件名 |
| `trim_icon_prefix` | String | `icon` | 要移除的图标名前缀 |
| `default_icon_size` | int | `18` | 默认图标大小 |
| `null_safety` | bool | `true` | 是否生成空安全代码 |

**`name` → 类名映射：**
- `r` → `R`（数据类：`RData`）
- `icon_font` → `IconFont`（数据类：`IconFontData`）
- `admin` → `Admin`（数据类：`AdminData`）

## 🔗 获取 Symbol URL

1. 访问 [iconfont.cn](https://www.iconfont.cn/)
2. 打开你的图标项目
3. 进入项目设置
4. 复制 Symbol JavaScript URL（如 `//at.alicdn.com/t/c/font_xxx_xxx.js`）

![Symbol URL Location](images/symbol-url.png)

## 🚧 故障排除

| 问题 | 解决方案 |
|------|----------|
| 未找到配置文件 | 确保项目根目录有 `iconfont.yaml`，或使用 `--config` 指定 |
| 未找到图标 | 验证 symbol URL 是否正确且可访问 |
| 权限被拒绝 | 检查输出目录的写权限 |

使用 `iconfont_generator --verbose` 查看详细调试输出。

## 🔧 设计理念

### 为什么使用 SVG 而不是字体？

1. **多色彩支持** — SVG 天然支持多色彩渲染
2. **体积更小** — 只包含使用的图标
3. **更好的兼容性** — 不依赖系统字体
4. **代码即图标** — Dart 代码，便于版本控制

### 为什么用静态 getter 而不是 enum + Widget？

新 API（`R.home.svg()`）灵感来自 [flutter_gen](https://pub.dev/packages/flutter_gen) 的 `assets.gen.dart` 模式：

- **可发现** — IDE 自动补全在 `R.` 后显示所有可用图标
- **灵活** — `.svg()` 返回 `Widget`，参数为可选命名参数
- **类型安全颜色** — 使用 Flutter `Color` 而非十六进制字符串
- **无枚举样板** — 生成代码中无 `IconNames` 枚举和 switch 语句

## 📢 项目说明

基于 [flutter-iconfont-cli](https://github.com/iconfont-cli/flutter-iconfont-cli)（已停止维护）的纯 Dart 重写版本。

## 📄 许可证

MIT — 详见 [LICENSE](LICENSE)。
