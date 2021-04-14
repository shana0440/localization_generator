# localization_generator

A command tool to generate localization from JSON file.

![Dart CI](https://github.com/shana0440/localization_generator/workflows/Dart%20CI/badge.svg?branch=master)

## Getting Start

Add to your `pubspec.yaml`.

```yaml
dependencies:
  intl: ^0.17.0
dev_dependencies:
  localization_generator: <last_version>
```

Add translation files to a folder.

```
l10n
  +- {languageCode}.json
  +- {languageCode}-{countryCode}.json
  +- {languageCode}-{scriptCode}.json
```

Run the following command.

```bash
flutter pub run localization_generator --output=./l10n --input=./l10n
```

Configuration app.

```dart
// Import the generated localization file.
import 'l10n/localization.dart';

MaterialApp(
  onGenerateTitle: (context) {
    return Localized.of(context).hello(name: "my name");
  },
  theme: ThemeData(
    primarySwatch: Colors.blue,
  ),
  localizationsDelegates: [
    Localized.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate
  ],
  supportedLocales: Localized.delegate.supportedLocales,
  home: Builder(builder: (context) {
    return Column(
      children: [
        Text(Localized.of(context).hi),
        Text(Localized.of(context).price(currency: "TWD")),
        Text(Localized.of(context).gender(gender: "female")),
        Text(Localized.of(context).reply(count: 0)),
      ],
    );
  }),
);
```

[Example project](./example)

## MessageFormat

The message pattern is follow the [ICU MessageFormat](https://unicode-org.github.io/icu/userguide/format_parse/messages/).

### Unsupport
- `offset` of `plural`
- date
- number
