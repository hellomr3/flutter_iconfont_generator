#!/usr/bin/env dart

import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:yaml/yaml.dart';
import '../lib/src/config.dart';
import '../lib/src/fetcher.dart';
import '../lib/src/svg_parser.dart';
import '../lib/src/generator.dart';

/// Command line tool for generating iconfont
Future<void> main(List<String> arguments) async {
  final verbose = arguments.contains('--verbose') || arguments.contains('-v');
  final showHelp = arguments.contains('--help') || arguments.contains('-h');
  final updateExtensions = arguments.contains('--update-extensions');

  if (showHelp) {
    _showUsage();
    return;
  }

  // Handle --update-extensions option
  if (updateExtensions) {
    await _updateBuildExtensions();
    return;
  }

  try {
    print('🚀 Flutter IconFont Generator v1.0.0');
    if (verbose) print('Running with verbose output...');
    print('');

    // Read configuration
    // Try lib/iconfont.yaml first, then fall back to pubspec.yaml
    String configPath = _getOptionValue(arguments, '--config') ?? '';
    if (configPath.isEmpty) {
      // Auto-detect config file
      if (verbose) print('Current directory: ${Directory.current.path}');

      // Use current directory as project root
      final projectRoot = Directory.current.path;

      // Try iconfont.yaml in project root first
      final rootIconfontYaml = File(path.join(projectRoot, 'iconfont.yaml'));
      if (verbose) print('Checking for ${rootIconfontYaml.path}...');

      if (await rootIconfontYaml.exists()) {
        configPath = rootIconfontYaml.path;
        if (verbose) print('Found iconfont.yaml');
      } else {
        // Try lib/iconfont.yaml as fallback
        final libIconfontYaml = File(path.join(projectRoot, 'lib', 'iconfont.yaml'));
        if (verbose) print('Checking for ${libIconfontYaml.path}...');

        if (await libIconfontYaml.exists()) {
          configPath = libIconfontYaml.path;
          if (verbose) print('Found lib/iconfont.yaml');
        } else {
          // Try pubspec.yaml in project root
          final pubspecFile = File(path.join(projectRoot, 'pubspec.yaml'));
          if (verbose) print('Checking for ${pubspecFile.path}...');

          if (await pubspecFile.exists()) {
            configPath = pubspecFile.path;
            if (verbose) print('Found pubspec.yaml');
          } else {
            // Not found, set default for error message
            configPath = 'iconfont.yaml';
          }
        }
      }
    }

    final configFile = File(configPath);
    if (!await configFile.exists()) {
      print('❌ Error: Configuration file not found: $configPath');
      print('   Please run this command in your Flutter project root');
      print('');
      _showConfigExample();
      exit(1);
    }

    final configContent = await configFile.readAsString();
    final configYaml = loadYaml(configContent) as Map;

    // Handle different config file formats
    Map? iconfontConfig;
    if (configPath.endsWith('iconfont.yaml')) {
      // iconfont.yaml: config is at root level
      iconfontConfig = configYaml;
    } else {
      // pubspec.yaml: config is under 'iconfont' key
      iconfontConfig = configYaml['iconfont'] as Map?;
    }

    if (iconfontConfig == null) {
      print('❌ Error: No iconfont configuration found in $configPath');
      print('');
      _showConfigExample();
      exit(1);
    }

    // Create config and apply command line overrides
    final config =
        IconFontConfig.fromMap(Map<String, dynamic>.from(iconfontConfig));
    final finalConfig = _applyCommandLineOverrides(config, arguments);

    // Check if using legacy single source format
    if (!finalConfig.isMultiSource) {
      if (finalConfig.symbolUrl.isEmpty ||
          finalConfig.symbolUrl.contains('请参考README.md')) {
        print('❌ Error: Please configure a valid symbol_url');
        print('   Use --url option or configure it in $configPath');
        print('   Get your symbol URL from iconfont.cn project settings');
        exit(1);
      }

      if (verbose) {
        print('📋 Configuration:');
        print('   Symbol URL: ${finalConfig.symbolUrl}');
        print('   Output Directory: ${finalConfig.saveDir}');
        print('   Trim Prefix: ${finalConfig.trimIconPrefix}');
        print('   Default Size: ${finalConfig.defaultIconSize}');
        print('   Null Safety: ${finalConfig.nullSafety}');
        print('');
      }

      print('📡 Fetching icons from iconfont.cn...');

      // Fetch SVG content
      final svgContent =
          await IconFontFetcher.fetchSvgContent(finalConfig.symbolUrl);
      if (verbose) print('✅ Fetched ${svgContent.length} characters of SVG data');

      // Parse symbols
      final symbols = SvgParser.parseSymbols(svgContent);

      if (symbols.isEmpty) {
        print('❌ Warning: No icons found in the SVG content');
        print('   Please check your symbol_url configuration');
        return;
      }

      print('✅ Found ${symbols.length} icons');
      if (verbose) {
        print('   Icons: ${symbols.map((s) => s.id).join(', ')}');
      }

      // Generate code
      await CodeGenerator.generateIconFont(symbols, finalConfig);

      print('🎉 Successfully generated iconfont code!');
      print('📁 Output: ${finalConfig.saveDir}/iconfont.dart');
      print('');
      print('💡 Usage in your Flutter app:');
      final source = finalConfig.sources.first;
      final importPath = finalConfig.saveDir.replaceAll('./', '').replaceAll('lib/', '');
      print(
          '   import \'package:your_app/$importPath/iconfont.dart\';');
      print('   ${source.className}(IconNames.yourIconName)');
    } else {
      // Multi-source format
      if (verbose) {
        print('📋 Configuration:');
        print('   Sources: ${finalConfig.sources.length}');
        for (final source in finalConfig.sources) {
          print('   - ${source.name}:');
          print('     URL: ${source.symbolUrl}');
          print('     Output: ${source.saveDir}/${source.outputFileName}');
        }
        print('');
      }

      print('📡 Fetching icons from ${finalConfig.sources.length} sources...');

      for (final source in finalConfig.sources) {
        if (source.symbolUrl.isEmpty ||
            source.symbolUrl.contains('请参考README.md')) {
          print('⚠️  Skipping ${source.name}: Invalid symbol_url');
          continue;
        }

        if (verbose) print('   Processing ${source.name}...');

        // Fetch SVG content
        final svgContent =
            await IconFontFetcher.fetchSvgContent(source.symbolUrl);
        if (verbose) print('   ✅ Fetched ${svgContent.length} characters');

        // Parse symbols
        final symbols = SvgParser.parseSymbols(svgContent);

        if (symbols.isEmpty) {
          print('⚠️  ${source.name}: No icons found');
          continue;
        }

        print('✅ ${source.name}: Found ${symbols.length} icons');
        if (verbose) {
          print('   Icons: ${symbols.map((s) => s.id).join(', ')}');
        }

        // Generate code
        await CodeGenerator.generateForSource(symbols, source);
      }

      print('🎉 Successfully generated iconfont code for ${finalConfig.sources.length} sources!');
      print('');
      print('💡 Usage in your Flutter app:');
      for (final source in finalConfig.sources) {
        print('   // ${source.name}');
        final importPath = source.saveDir.replaceAll('./', '').replaceAll('lib/', '');
        print(
            '   import \'package:your_app/$importPath/${source.outputFileName}\';');
        print('   ${source.className}(IconNames.yourIconName)');
      }
    }
  } catch (e, stackTrace) {
    print('❌ Error generating iconfont: $e');
    if (verbose) {
      print('');
      print('Stack trace:');
      print(stackTrace);
    }
    exit(1);
  }
}

IconFontConfig _applyCommandLineOverrides(
    IconFontConfig config, List<String> arguments) {
  // Command line overrides only apply to single source config
  if (!config.isMultiSource) {
    final source = config.sources.first;
    final urlOverride = _getOptionValue(arguments, '--url');
    final outputOverride = _getOptionValue(arguments, '--output');
    final prefixOverride = _getOptionValue(arguments, '--prefix');
    final sizeOverride = _getOptionValue(arguments, '--size');

    if (urlOverride == null &&
        outputOverride == null &&
        prefixOverride == null &&
        sizeOverride == null) {
      return config; // No overrides
    }

    return IconFontConfig(
      sources: [
        IconFontSource(
          name: source.name,
          symbolUrl: urlOverride ?? source.symbolUrl,
          saveDir: outputOverride ?? source.saveDir,
          outputFile: source.outputFile,
          trimIconPrefix: prefixOverride ?? source.trimIconPrefix,
          defaultIconSize:
              int.tryParse(sizeOverride ?? '') ?? source.defaultIconSize,
          nullSafety: source.nullSafety,
        ),
      ],
    );
  }

  // For multi-source configs, command line overrides are not supported
  return config;
}

/// Get command line option value
String? _getOptionValue(List<String> args, String option) {
  for (int i = 0; i < args.length - 1; i++) {
    if (args[i] == option) {
      return args[i + 1];
    }
  }
  return null;
}

void _showUsage() {
  print(
      'Flutter IconFont Generator - Generate Flutter icon widgets from iconfont.cn');
  print('');
  print('Usage: iconfont_generator [options]');
  print('');
  print('Options:');
  print('  -h, --help            Show this help message');
  print('  -v, --verbose         Show detailed output');
  print('  --config FILE         Configuration file (default: iconfont.yaml or pubspec.yaml)');
  print('  --url URL             Symbol URL from iconfont.cn');
  print('  --output DIR          Output directory (default: ./lib/iconfont)');
  print('  --prefix PREFIX       Icon prefix to trim (default: icon)');
  print('  --size SIZE           Default icon size (default: 18)');
  print('  --update-extensions  Update buildExtensions with current sources');
  print('');
  print('Configuration:');
  print('  The generator will automatically look for iconfont.yaml first,');
  print('  then fall back to pubspec.yaml if not found.');
  print('');
  print('Examples:');
  print('  iconfont_generator                                    # Auto-detect config file');
  print('  iconfont_generator --config iconfont.yaml            # Use specific config file');
  print('  iconfont_generator --url "//at.alicdn.com/..." --output lib/icons');
  print('  iconfont_generator --verbose                          # Show detailed output');
  print('  iconfont_generator --update-extensions               # Update buildExtensions');
  print('  iconfont_generator --help                             # Show this help');
}

void _showConfigExample() {
  print('Please create an iconfont.yaml file in your project root:');
  print('');
  print('# iconfont.yaml');
  print('symbol_url: "//at.alicdn.com/t/font_xxx.js"');
  print('save_dir: "./lib/iconfont"');
  print('trim_icon_prefix: "icon"');
  print('default_icon_size: 18');
  print('null_safety: true');
  print('');
  print('Or add iconfont configuration to your pubspec.yaml:');
  print('');
  print('iconfont:');
  print('  symbol_url: "//at.alicdn.com/t/c/font_xxx_xxx.js"  # Your iconfont.cn symbol URL');
  print('  save_dir: "./lib/iconfont"                          # Output directory');
  print('  trim_icon_prefix: "icon"                            # Prefix to remove from icon names');
  print('  default_icon_size: 18                               # Default icon size');
  print('  null_safety: true                                   # Enable null safety');
  print('');
  print('Get your symbol URL from iconfont.cn project settings.');
}

/// Updates buildExtensions in builder.dart based on current iconfont.yaml configuration.
///
/// This function reads iconfont.yaml, extracts all configured sources, and generates
/// the corresponding buildExtensions configuration that needs to be added to builder.dart.
Future<void> _updateBuildExtensions() async {
  print('🔧 Updating buildExtensions from iconfont.yaml...');

  // Read iconfont.yaml
  final iconfontYaml = File('iconfont.yaml');
  if (!await iconfontYaml.exists()) {
    print('❌ Error: iconfont.yaml not found');
    print('   Please create an iconfont.yaml file in your project root');
    return;
  }

  try {
    final content = await iconfontYaml.readAsString();
    final yaml = loadYaml(content) as Map;

    if (!yaml.containsKey('sources')) {
      print('⚠️  No sources found in iconfont.yaml');
      print('   Using single source format');
      return;
    }

    final sources = yaml['sources'] as List;
    final outputs = <String>[];

    // Collect all output files
    for (final source in sources) {
      final sourceMap = source as Map;
      final name = sourceMap['name'] as String;
      final outputFile = sourceMap['output_file'] as String? ?? '$name.dart';
      final saveDir = sourceMap['save_dir'] as String? ?? './lib/generated';

      // Add both .ifg.dart and .dart variants
      final ifgFile = '$saveDir/$outputFile'.replaceAll('.dart', '.ifg.dart');
      final dartFile = '$saveDir/$outputFile';

      outputs.add("'$ifgFile'");
      outputs.add("'$dartFile'");
    }

    // Generate buildExtensions code
    print('');
    print('📋 Add the following to your builder.dart buildExtensions:');
    print('');
    print("  @override");
    print("  Map<String, List<String>> get buildExtensions => {");
    print("        'lib/iconfont.yaml': [");
    for (final output in outputs) {
      // Remove leading './' for buildExtensions
      final cleanOutput = output.replaceAll("'", "").replaceAll("./", "");
      print("          '$cleanOutput',");
    }
    print("        ],");
    print("      };");
    print('');
    print('✅ Don\'t forget to restart your IDE or run: flutter pub get');
  } catch (e) {
    print('❌ Error reading iconfont.yaml: $e');
  }
}
