import 'package:calculator/algorithm/calculator.dart';
import 'package:calculator/component/calculator_board.dart';
import 'package:calculator/component/calculator_button.dart';
import 'package:calculator/state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CalculatorKeyboard extends StatelessWidget {
  final List<CalculatorButtonDelegator> delegators;
  final Calculator calculator;
  final int rowNum;
  final double ratio;

  CalculatorKeyboard({
    this.delegators,
    this.calculator,
    this.rowNum,
    this.ratio = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<CalculationState>(builder: (context, state, _) {
      return Column(
        children: <Widget>[
          CalculatorBoard(),
          GridView.count(
            primary: false,
            childAspectRatio: ratio,
            crossAxisCount: this.rowNum,
            shrinkWrap: true,
            children: delegators
                .map((delegator) => Provider<Calculator>.value(
                    value: calculator, child: CalculatorButton(delegator)))
                .toList(),
          ),
        ],
      );
    });
  }
}
