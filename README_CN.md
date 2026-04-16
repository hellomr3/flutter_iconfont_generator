# Flutter IconFont Generator

[![pub package](https://img.shields.io/pub/v/flutter_iconfont_generator.svg)](https://pub.dev/packages/flutter_iconfont_generator)

中文文档 | [English](./README.md)

> 一个用于 iconfont.cn 图标的 Dart/Flutter 代码生成器。将 iconfont.cn 图标转换为 Flutter 组件，支持 SVG 渲染、多源配置、多色彩图标和空安全。

## ✨ 功能特性

- 🚀 **命令行工具** - 简单的命令行接口
- 🎨 **多色彩支持** - 支持多色彩图标渲染和自定义颜色
- 📦 **纯组件** - 无需字体文件，使用 SVG 渲染减少包体积
- 🔄 **自动生成** - 自动从 iconfont.cn 获取最新图标并生成 Dart 代码
- 🛡️ **空安全** - 完整的 Dart 空安全支持
- 📦 **多源支持** - 支持配置多个 iconfont 源，每个源独立的类名
- ⚡ **简易安装** - 通过 dart pub global activate 全局安装

## 🚀 快速开始

### 安装

#### 方法一：全局安装（推荐）

全局安装命令行工具：

```bash
dart pub global activate flutter_iconfont_generator
```

#### 方法二：添加为开发依赖

在你的 `pubspec.yaml` 中添加：

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

### 生成图标代码

#### 方法一：命令行工具（推荐）

全局安装后：

```bash
# 使用 iconfont.yaml 配置生成图标
iconfont_generator

# 显示详细输出
iconfont_generator --verbose

# 显示帮助
iconfont_generator --help
```

#### 方法二：直接执行 Dart

如果未全局安装：

```bash
# 从项目根目录运行
dart run flutter_iconfont_generator:iconfont_generator
```

## 📖 使用方法

### 基本使用

**单源：**

```dart
import 'package:your_app/iconfont/iconfont.dart';

// 基本使用
IconFont(IconNames.home)

// 带大小
IconFont(IconNames.user, size: 24)

// 带颜色
IconFont(IconNames.settings, size: 32, color: '#ff0000')

// 多色彩图标
IconFont(IconNames.logo, size: 48, colors: ['#ff0000', '#00ff00', '#0000ff'])
```

**多源：**

```dart
import 'package:your_app/generated/app.dart';
import 'package:your_app/generated/admin_icons.dart';

// 使用 app 图标
App(IconNames.home)

// 使用 admin 图标
Admin(IconNames.settings)
```

### 命令行选项

```bash
# 基本使用
iconfont_generator

# 指定配置文件
iconfont_generator --config path/to/iconfont.yaml

# 详细输出
iconfont_generator --verbose

# 显示帮助
iconfont_generator --help
```

## ⚙️ 配置参数

### 单源配置参数

| 参数 | 类型 | 默认值 | 说明 |
|-----|------|--------|------|
| `symbol_url` | String | - | **必填** iconfont.cn 的 Symbol 链接 |
| `save_dir` | String | `"./lib/iconfont"` | 生成文件的保存目录 |
| `trim_icon_prefix` | String | `"icon"` | 要移除的图标名前缀 |
| `default_icon_size` | int | `18` | 默认图标大小 |
| `null_safety` | bool | `true` | 是否生成 null safety 代码 |

### 多源配置参数

| 参数 | 类型 | 默认值 | 说明 |
|-----|------|--------|------|
| `sources` | List | - | **必填** 图标源列表 |
| `name` | String | - | **必填** 源名称，转换为大驼峰作为 widget 类名 |
| `symbol_url` | String | - | **必填** iconfont.cn 的 Symbol 链接 |
| `save_dir` | String | `"./lib/iconfont"` | 生成文件的保存目录 |
| `output_file` | String | `{name}.dart` | 输出文件名 |
| `trim_icon_prefix` | String | `"icon"` | 要移除的图标名前缀 |
| `default_icon_size` | int | `18` | 默认图标大小 |
| `null_safety` | bool | `true` | 是否生成 null safety 代码 |

**重要说明**：`name` 字段会转换为大驼峰格式作为 widget 类名：
- `app` → `App`
- `admin` → `Admin`
- `icon_font` → `IconFont`

## 🔗 获取 Symbol URL

1. 访问 [iconfont.cn](https://www.iconfont.cn/)
2. 创建或打开你的图标项目
3. 进入项目设置（项目设置）
4. 找到 "FontClass/Symbol前缀" 部分
5. 复制 JavaScript URL（应该类似 `//at.alicdn.com/t/c/font_xxx_xxx.js`）

![Symbol URL Location](images/symbol-url.png)

## 🚧 故障排除

### 常见问题

**"未找到配置文件"**
- 确保你在项目根目录有 `iconfont.yaml` 文件
- 或使用 `--config` 指定配置文件路径

**"未找到 iconfont 配置"**
- 检查你的 `iconfont.yaml` 是否有有效配置
- 验证 YAML 语法是否正确

**"请配置有效的 symbol_url"**
- 检查你的 symbol URL 是否来自 iconfont.cn 且可访问
- URL 应该以 `//at.alicdn.com/` 开头

**"在 SVG 内容中未找到图标"**
- 验证你的 symbol URL 是否正确
- 检查你的 iconfont 项目是否有图标
- 尝试在浏览器中访问该 URL

**权限被拒绝**
- 确保你对输出目录有写权限

### 调试模式

使用详细模式查看详细信息：

```bash
iconfont_generator --verbose
```

## 📱 使用示例

**iconfont.yaml：**

```yaml
sources:
  - name: app
    symbol_url: "//at.alicdn.com/t/font_4663043_7hbwe75j25b.js"
    save_dir: "./lib/generated"
    trim_icon_prefix: "icon"
    default_icon_size: 18
```

**使用：**

```dart
import 'package:demo/generated/app.dart';

// 使用图标
App(IconNames.home)

// 自定义颜色
App(IconNames.settings, color: '#ff0000')

// 多色图标
App(IconNames.logo, colors: ['#ff0000', '#00ff00'])
```

## 🤝 贡献指南

欢迎提交 Issue 和 Pull Request！

1. Fork 本仓库
2. 创建特性分支 (`git checkout -b feature/AmazingFeature`)
3. 提交更改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 开启 Pull Request

## 📄 许可证

本项目基于 MIT 许可证，详情请参阅 [LICENSE](LICENSE) 文件。

## 🔗 相关链接

- [iconfont.cn](https://iconfont.cn) - 阿里巴巴矢量图标库
- [Flutter SVG](https://pub.dev/packages/flutter_svg) - Flutter SVG 渲染插件

## 🔧 设计理念

### 为什么使用 SVG 而不是字体？

1. **多色彩支持** - SVG 天然支持多色彩渲染
2. **体积更小** - 只包含使用的图标，无冗余数据
3. **更好的兼容性** - 不依赖系统字体，跨平台一致性更好
4. **代码即图标** - 图标作为 Dart 代码存在，便于版本控制和管理

### 核心优势

- **纯 Dart 实现** - 利用 Dart 生态，无需额外的运行时环境
- **编译时生成** - 图标在编译时确定，运行时性能更好
- **类型安全** - 通过枚举提供类型安全的图标引用
- **多源支持** - 独立配置和管理多个 iconfont 源

## 📢 项目说明

本项目是基于 [flutter-iconfont-cli](https://github.com/iconfont-cli/flutter-iconfont-cli) 的纯 Dart 重构版本。由于原仓库不再维护，故使用新仓库继续维护和发展该项目。

---

如果这个项目对你有帮助，请给个 ⭐️ Star 支持一下！
