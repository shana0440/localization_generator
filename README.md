# localization_generator

A command tool to generate localization from JSON file.

![Dart CI](https://github.com/shana0440/localization_generator/workflows/Dart%20CI/badge.svg?branch=master)

## Usage

create `en.json` and `zh_Hant.json` at l10n folder

en.json
```json
{
    "hi": "Hi",
    "hello": "Hello {name}",
    "price": "100 {currency, select, TWD{NT} other{\\$}}",
    "gender": "gender: {gender, gender, female{female} male{male} other{other}}",
    "reply": "{count, plural, =0{no reply} =1{1 reply} other{# replies}}"
}
```

zh_Hant.json
```json
{
    "hi": "嗨",
    "hello": "你好 {name}",
    "price": "100 {currency, select, TWD{台幣} other{\\$}}",
    "gender": "gender: {gender, gender, female{女} male{男} other{第三性}}",
    "reply": "{count, plural, =0{沒有回覆} =1{1個回覆} other{#個回覆}}"
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
