import 'package:calculator/algorithm/calculator.dart';
import 'package:calculator/algorithm/logical.dart';
import 'package:calculator/algorithm/science.dart';
import 'package:calculator/component/calculator_button.dart';
import 'package:calculator/component/calculator_keyboard.dart';
import 'package:calculator/signs.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class LogicalCalculatorView extends StatelessWidget {
  final _calculator = LogicalCalculator();
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CalculationState>.value(
        notifier: CalculationState(),
        child: CalculatorKeyboard([], _calculator, 4));
  }
}
