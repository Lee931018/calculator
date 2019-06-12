import 'package:flutter/material.dart';
import 'pages/science_calculator.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Calculator',
        theme: ThemeData(
            primaryColor: Color(0xFF414449),
            primaryColorDark: Color(0xFF242532),
            accentColor: Color(0xFFD20024)),
        home: CalculatorMainPage());
  }
}

class CalculatorMainPage extends StatelessWidget {
  CalculatorMainPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ScienceCalculatorView(),
    );
  }
}
