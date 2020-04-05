# localization_generator

A command tool to generate localization from JSON file.

## Usage

create `en.json` and `zh_Hant.json` at l10n folder

en.json
```json
{
  "Title": "Hello {{name}}",
  "Home": "Home"
}
```

zh_Hant.json
```json
{
  "Title": "你好 {{name}}",
  "Home": "首頁"
}
```

and run this command
```
flutter pub run localization_generator --output=./l10n --input=./l10n
```

```
import 'l10n/localization.dart';

MaterialApp(
  onGenerateTitle: (context) {
    return Localized.of(context).Title(name: "my name");
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
    return MyHomePage(title: Localized.of(context).Home);
  }),
);
```
