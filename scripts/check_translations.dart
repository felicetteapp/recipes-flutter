#!/usr/bin/env dart

import 'dart:io';

void main() async {
  print('🔍 Checking for missing translation keys...\n');

  try {
    // Get all translation keys from TranslationKeys class
    final allKeys = await _getAllTranslationKeysFromFile();
    print(
      '📋 Found ${allKeys.length} translation keys in TranslationKeys class\n',
    );

    // Create a mapping of TranslationKeys constants to their values
    final keyMapping = await _createKeyMapping();

    // Get translation maps for each locale by parsing files
    final enKeys = await _getTranslationKeysFromFile(
      'lib/app/common/translations/en_translations.dart',
      'en_US',
      keyMapping,
    );
    final ptKeys = await _getTranslationKeysFromFile(
      'lib/app/common/translations/pt_translations.dart',
      'pt_BR',
      keyMapping,
    );
    final esKeys = await _getTranslationKeysFromFile(
      'lib/app/common/translations/es_translations.dart',
      'es_AR',
      keyMapping,
    );

    // Check each language
    _checkLanguage('English (en_US)', enKeys, allKeys);
    _checkLanguage('Portuguese (pt_BR)', ptKeys, allKeys);
    _checkLanguage('Spanish (es_AR)', esKeys, allKeys);

    // Check for unused keys (keys that exist in translations but not in TranslationKeys)
    _checkUnusedKeys('English (en_US)', enKeys, allKeys);
    _checkUnusedKeys('Portuguese (pt_BR)', ptKeys, allKeys);
    _checkUnusedKeys('Spanish (es_AR)', esKeys, allKeys);

    // Summary
    _printSummary(
      allKeys,
      [enKeys, ptKeys, esKeys],
      ['English (en_US)', 'Portuguese (pt_BR)', 'Spanish (es_AR)'],
    );

    print('✅ Translation check completed!');
  } catch (e) {
    print('❌ Error: $e');
    exit(1);
  }
}

Future<Set<String>> _getAllTranslationKeysFromFile() async {
  final keys = <String>{};

  // Read the TranslationKeys file
  final file = File('lib/app/common/translation_keys.dart');
  if (!await file.exists()) {
    throw Exception('TranslationKeys file not found at ${file.path}');
  }

  final content = await file.readAsString();

  // Simple parsing approach - look for lines with static const String
  final lines = content.split('\n');

  for (final line in lines) {
    final trimmedLine = line.trim();
    if (trimmedLine.startsWith('static const String')) {
      // Extract the value between quotes using simple string methods
      final parts = trimmedLine.split('=');
      if (parts.length == 2) {
        final valuePart = parts[1].trim();
        if (valuePart.startsWith("'") && valuePart.contains("';")) {
          final startIndex = valuePart.indexOf("'") + 1;
          final endIndex = valuePart.lastIndexOf("'");
          if (startIndex < endIndex) {
            final key = valuePart.substring(startIndex, endIndex);
            keys.add(key);
          }
        } else if (valuePart.startsWith('"') && valuePart.contains('";')) {
          final startIndex = valuePart.indexOf('"') + 1;
          final endIndex = valuePart.lastIndexOf('"');
          if (startIndex < endIndex) {
            final key = valuePart.substring(startIndex, endIndex);
            keys.add(key);
          }
        }
      }
    }
  }

  return keys;
}

Future<Map<String, String>> _createKeyMapping() async {
  final mapping = <String, String>{};

  // Read the TranslationKeys file
  final file = File('lib/app/common/translation_keys.dart');
  if (!await file.exists()) {
    throw Exception('TranslationKeys file not found at ${file.path}');
  }

  final content = await file.readAsString();
  final lines = content.split('\n');

  for (final line in lines) {
    final trimmedLine = line.trim();
    if (trimmedLine.startsWith('static const String')) {
      // Extract constant name and value
      final parts = trimmedLine.split('=');
      if (parts.length == 2) {
        final namePart = parts[0].trim();
        final valuePart = parts[1].trim();

        // Get the constant name
        final nameMatch = RegExp(
          r'static\s+const\s+String\s+(\w+)',
        ).firstMatch(namePart);
        if (nameMatch != null) {
          final constName = nameMatch.group(1)!;

          // Get the value
          if (valuePart.startsWith("'") && valuePart.contains("';")) {
            final startIndex = valuePart.indexOf("'") + 1;
            final endIndex = valuePart.lastIndexOf("'");
            if (startIndex < endIndex) {
              final key = valuePart.substring(startIndex, endIndex);
              mapping[constName] = key;
            }
          } else if (valuePart.startsWith('"') && valuePart.contains('";')) {
            final startIndex = valuePart.indexOf('"') + 1;
            final endIndex = valuePart.lastIndexOf('"');
            if (startIndex < endIndex) {
              final key = valuePart.substring(startIndex, endIndex);
              mapping[constName] = key;
            }
          }
        }
      }
    }
  }

  return mapping;
}

Future<Set<String>> _getTranslationKeysFromFile(
  String filePath,
  String locale,
  Map<String, String> keyMapping,
) async {
  final keys = <String>{};

  final file = File(filePath);
  if (!await file.exists()) {
    print('⚠️  Translation file not found: $filePath');
    return keys;
  }

  final content = await file.readAsString();

  // Find lines that contain TranslationKeys references
  final lines = content.split('\n');
  bool insideLocaleSection = false;
  int braceLevel = 0;

  for (final line in lines) {
    final trimmedLine = line.trim();

    // Check if we're entering the locale section
    if (trimmedLine.contains("'$locale'") ||
        trimmedLine.contains('"$locale"')) {
      insideLocaleSection = true;
      braceLevel = 0;
      continue;
    }

    if (insideLocaleSection) {
      // Count braces to know when we exit the locale section
      braceLevel += '{'.allMatches(trimmedLine).length;
      braceLevel -= '}'.allMatches(trimmedLine).length;

      if (braceLevel < 0) {
        // We've exited the locale section
        break;
      }

      // Extract translation key using TranslationKeys reference
      if (trimmedLine.contains('TranslationKeys.')) {
        final keyMatch = RegExp(
          r'TranslationKeys\.(\w+)',
        ).firstMatch(trimmedLine);
        if (keyMatch != null) {
          final constName = keyMatch.group(1)!;
          final actualKey = keyMapping[constName];
          if (actualKey != null) {
            keys.add(actualKey);
          }
        }
      }
    }
  }

  return keys;
}

void _checkLanguage(
  String languageName,
  Set<String> translations,
  Set<String> allKeys,
) {
  print('🌍 Checking $languageName:');

  final missingKeys = <String>[];

  for (final key in allKeys) {
    if (!translations.contains(key)) {
      missingKeys.add(key);
    }
  }

  final presentKeys = allKeys.length - missingKeys.length;

  if (missingKeys.isEmpty) {
    print(
      '  ✅ All translation keys are present! ($presentKeys/${allKeys.length})',
    );
  } else {
    print('  ❌ Missing ${missingKeys.length} translation keys:');
    for (final key in missingKeys) {
      print('    - $key');
    }
    print(
      '  📊 Coverage: $presentKeys/${allKeys.length} (${(presentKeys / allKeys.length * 100).toStringAsFixed(1)}%)',
    );
  }
  print('');
}

void _checkUnusedKeys(
  String languageName,
  Set<String> translations,
  Set<String> allKeys,
) {
  final unusedKeys = <String>[];

  for (final key in translations) {
    if (!allKeys.contains(key)) {
      unusedKeys.add(key);
    }
  }

  if (unusedKeys.isNotEmpty) {
    print(
      '⚠️  $languageName has ${unusedKeys.length} unused translation keys:',
    );
    for (final key in unusedKeys) {
      print('    - $key');
    }
    print('');
  }
}

void _printSummary(
  Set<String> allKeys,
  List<Set<String>> translations,
  List<String> languageNames,
) {
  print('📊 SUMMARY:');
  print('═' * 50);

  for (int i = 0; i < translations.length; i++) {
    final trans = translations[i];
    final name = languageNames[i];
    final presentKeys = allKeys.intersection(trans).length;
    final missing = allKeys.length - presentKeys;
    final unused = trans.difference(allKeys).length;
    final coverage = (presentKeys / allKeys.length * 100);

    print('$name:');
    print(
      '  ✅ Present: $presentKeys/${allKeys.length} (${coverage.toStringAsFixed(1)}%)',
    );
    if (missing > 0) {
      print('  ❌ Missing: $missing keys');
    }
    if (unused > 0) {
      print('  ⚠️  Unused: $unused keys');
    }
    print('');
  }
}
