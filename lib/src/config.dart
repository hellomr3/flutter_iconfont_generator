/// Configuration model for a single iconfont source.
///
/// This class defines settings for one iconfont source with a unique name
/// and output file. Multiple sources can be configured in iconfont.yaml.
///
/// ## Usage
///
/// ### From iconfont.yaml configuration
/// ```yaml
/// sources:
///   - name: main
///     symbol_url: '//at.alicdn.com/t/font_123.js'
///     trim_icon_prefix: 'icon'
///   - name: secondary
///     symbol_url: '//at.alicdn.com/t/font_456.js'
///     output_file: 'secondary_icons.dart'
/// ```
///
/// ### Direct instantiation
/// ```dart
/// final source = IconFontSource(
///   name: 'main',
///   symbolUrl: 'https://at.alicdn.com/t/font_123.js',
///   saveDir: './lib/icons',
///   outputFile: 'main_icons.dart',
///   trimIconPrefix: 'icon',
///   defaultIconSize: 20,
///   nullSafety: true,
/// );
/// ```
class IconFontSource {
  /// Unique identifier for this icon source.
  ///
  /// This name is used to generate the output file name if not specified.
  /// It also helps identify different icon sources in logs and errors.
  ///
  /// Example: `main`, `secondary`, `admin`
  final String name;

  /// The URL to fetch iconfont symbols from.
  ///
  /// This should be your iconfont.cn project's symbol URL, which typically
  /// looks like `//at.alicdn.com/t/font_xxx.js` or can include the full
  /// protocol like `https://at.alicdn.com/t/font_xxx.js`.
  ///
  /// Example: `//at.alicdn.com/t/font_123456_abcdef.js`
  final String symbolUrl;

  /// The directory where generated icon files will be saved.
  ///
  /// Default: `./lib/iconfont`
  ///
  /// Examples:
  /// - `./lib/icons`
  /// - `./lib/generated/iconfont`
  final String saveDir;

  /// The output file name for this source.
  ///
  /// If not specified, defaults to `{name}.dart` (e.g., `main.dart`).
  /// This file will be generated in the [saveDir] directory.
  ///
  /// Example: `main_icons.dart`, `secondary_icons.dart`
  final String? outputFile;

  /// The prefix to trim from icon names when generating enum values.
  ///
  /// Default: `icon`
  final String trimIconPrefix;

  /// The default size for generated icon widgets.
  ///
  /// Default: `18`
  final int defaultIconSize;

  /// Whether to generate null-safe code.
  ///
  /// Default: `true`
  final bool nullSafety;

  /// Creates a new IconFontSource with the specified settings.
  const IconFontSource({
    required this.name,
    required this.symbolUrl,
    this.saveDir = './lib/iconfont',
    this.outputFile,
    this.trimIconPrefix = 'icon',
    this.defaultIconSize = 18,
    this.nullSafety = true,
  });

  /// Creates an IconFontSource from a configuration map.
  ///
  /// Expected keys:
  /// - `name` (required): Source identifier
  /// - `symbol_url` (required): Iconfont.cn symbol URL
  /// - `save_dir` (optional): Output directory
  /// - `output_file` (optional): Output file name
  /// - `trim_icon_prefix` (optional): Prefix to trim
  /// - `default_icon_size` (optional): Default icon size
  /// - `null_safety` (optional): Generate null-safe code
  factory IconFontSource.fromMap(Map<String, dynamic> map) {
    return IconFontSource(
      name: map['name'] as String? ??
          (throw ArgumentError('Source name is required')),
      symbolUrl: map['symbol_url'] as String? ??
          (throw ArgumentError('symbol_url is required for source ${map['name']}')),
      saveDir: (map['save_dir'] as String?) ?? './lib/iconfont',
      outputFile: map['output_file'] as String?,
      trimIconPrefix: (map['trim_icon_prefix'] as String?) ?? 'icon',
      defaultIconSize: (map['default_icon_size'] as int?) ?? 18,
      nullSafety: (map['null_safety'] as bool?) ?? true,
    );
  }

  /// Gets the output file name for this source.
  ///
  /// Returns the configured [outputFile] or generates one from [name].
  String get outputFileName => outputFile ?? '$name.dart';

  /// Gets the widget class name for this source.
  ///
  /// Converts the [name] to PascalCase format for use as a Dart class name.
  /// Examples:
  /// - `main` → `MainIcon`
  /// - `admin` → `AdminIcon`
  /// - `icon_font` → `IconFontIcon`
  String get className {
    // Convert to PascalCase
    final parts = name.split(RegExp(r'[_\-]'));
    final pascalCase = parts.map((part) {
      if (part.isEmpty) return '';
      return part[0].toUpperCase() + part.substring(1);
    }).join();

    return '$pascalCase';
  }

  /// Converts this source configuration to a map representation.
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'symbol_url': symbolUrl,
      'save_dir': saveDir,
      'output_file': outputFile,
      'trim_icon_prefix': trimIconPrefix,
      'default_icon_size': defaultIconSize,
      'null_safety': nullSafety,
    };
  }
}

/// Configuration model for iconfont generation.
///
/// This class defines all the settings needed to generate Flutter icon widgets
/// from iconfont.cn icons. It supports both single source (legacy) and
/// multiple sources (new) configurations.
///
/// ## Usage
///
/// ### Single source (legacy)
/// ```yaml
/// symbol_url: "//at.alicdn.com/t/font_123.js"
/// save_dir: "./lib/icons"
/// trim_icon_prefix: "icon"
/// ```
///
/// ### Multiple sources (new)
/// ```yaml
/// sources:
///   - name: main
///     symbol_url: "//at.alicdn.com/t/font_123.js"
///   - name: secondary
///     symbol_url: "//at.alicdn.com/t/font_456.js"
///     output_file: "secondary_icons.dart"
/// ```
class IconFontConfig {
  /// List of iconfont sources to generate.
  ///
  /// When using multiple sources, each source will generate a separate file
  /// with its own icon set and enum.
  final List<IconFontSource> sources;

  /// Whether this is a multi-source configuration.
  bool get isMultiSource => sources.length > 1;

  /// Creates a new IconFontConfig with multiple sources.
  const IconFontConfig({required this.sources});

  /// Creates a single-source IconFontConfig (legacy format).
  ///
  /// This constructor is used for backward compatibility with the old
  /// configuration format that only supported a single symbol_url.
  factory IconFontConfig.single({
    required String symbolUrl,
    String saveDir = './lib/iconfont',
    String trimIconPrefix = 'icon',
    int defaultIconSize = 18,
    bool nullSafety = true,
  }) {
    return IconFontConfig(
      sources: [
        IconFontSource(
          name: 'iconfont',
          symbolUrl: symbolUrl,
          saveDir: saveDir,
          outputFile: 'iconfont.dart',
          trimIconPrefix: trimIconPrefix,
          defaultIconSize: defaultIconSize,
          nullSafety: nullSafety,
        ),
      ],
    );
  }

  /// Creates an IconFontConfig from a configuration map.
  ///
  /// This factory constructor supports both legacy (single source) and
  /// new (multiple sources) configuration formats.
  ///
  /// ## Legacy format (single source):
  /// ```dart
  /// final config = IconFontConfig.fromMap({
  ///   'symbol_url': '//at.alicdn.com/t/font_123.js',
  ///   'save_dir': './lib/icons',
  /// });
  /// ```
  ///
  /// ## New format (multiple sources):
  /// ```dart
  /// final config = IconFontConfig.fromMap({
  ///   'sources': [
  ///     {'name': 'main', 'symbol_url': '//at.alicdn.com/t/font_123.js'},
  ///     {'name': 'secondary', 'symbol_url': '//at.alicdn.com/t/font_456.js'},
  ///   ],
  /// });
  /// ```
  factory IconFontConfig.fromMap(Map<String, dynamic> map) {
    // Check for new multi-source format
    if (map.containsKey('sources')) {
      final sourcesList = map['sources'] as List;
      final sources = sourcesList
          .map((item) => IconFontSource.fromMap(Map<String, dynamic>.from(item)))
          .toList();

      if (sources.isEmpty) {
        throw ArgumentError('At least one source must be configured');
      }

      return IconFontConfig(sources: sources);
    }

    // Legacy single source format
    return IconFontConfig.single(
      symbolUrl: (map['symbol_url'] as String?) ?? '',
      saveDir: (map['save_dir'] as String?) ?? './lib/iconfont',
      trimIconPrefix: (map['trim_icon_prefix'] as String?) ?? 'icon',
      defaultIconSize: (map['default_icon_size'] as int?) ?? 18,
      nullSafety: (map['null_safety'] as bool?) ?? true,
    );
  }

  /// Gets the first (legacy) symbol URL for backward compatibility.
  String get symbolUrl => sources.first.symbolUrl;

  /// Gets the first (legacy) save directory for backward compatibility.
  String get saveDir => sources.first.saveDir;

  /// Gets the first (legacy) trim prefix for backward compatibility.
  String get trimIconPrefix => sources.first.trimIconPrefix;

  /// Gets the first (legacy) default icon size for backward compatibility.
  int get defaultIconSize => sources.first.defaultIconSize;

  /// Gets the first (legacy) null safety setting for backward compatibility.
  bool get nullSafety => sources.first.nullSafety;

  /// Converts this configuration to a map representation.
  Map<String, dynamic> toMap() {
    if (sources.length == 1 && sources.first.name == 'iconfont') {
      // Legacy single source format
      return {
        'symbol_url': sources.first.symbolUrl,
        'save_dir': sources.first.saveDir,
        'trim_icon_prefix': sources.first.trimIconPrefix,
        'default_icon_size': sources.first.defaultIconSize,
        'null_safety': sources.first.nullSafety,
      };
    }

    // Multi-source format
    return {
      'sources': sources.map((s) => s.toMap()).toList(),
    };
  }
}
