import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'l10n/localization.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateTitle: (context) {
        return Localized.of(context).hi;
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
        return MyHomePage();
      }),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Localized.of(context).hello(name: "my name")),
      ),
      body: Column(
        children: [
          Text(Localized.of(context).hi),
          Text(Localized.of(context).price(currency: "TWD")),
          Text(Localized.of(context).gender(gender: "female")),
          Text(Localized.of(context).reply(count: 0)),
        ],
      ),
    );
  }
}
