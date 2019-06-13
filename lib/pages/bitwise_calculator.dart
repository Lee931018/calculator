import 'package:calculator/algorithm/bitwise.dart';
import 'package:calculator/algorithm/calculator.dart';
import 'package:calculator/component/calculator_button.dart';
import 'package:calculator/component/calculator_keyboard.dart';
import 'package:calculator/signs.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:calculator/main.dart';
import 'package:calculator/state.dart';

class BitwiseCalculatorView extends StatelessWidget {
  final _calculator = BitwiseCalculator();
  final _state = CalculationState(Calculators.bitwise);

  _unaryOpValidate(Calculator c, CalculationState s) {
    final isEmpty = s.calculationStr == '';
    final isRightQuote = RegExp(r'\)$').hasMatch(s.calculationStr);
    final isOp = c.lastIsOperator(s.calculationStr);
    return isEmpty || (isOp && !isRightQuote);
  }

  _binaryOpValidate(Calculator c, CalculationState s) {
    final isNotEmpty = s.calculationStr != '';
    final isRightQuote = RegExp(r'\)$').hasMatch(s.calculationStr);
    final isNotOp = !c.lastIsOperator(s.calculationStr);
    return isNotEmpty && (isNotOp || isRightQuote);
  }

  _numValidate(Calculator c, CalculationState s) {
    // replace the bigining 0 at integer part
    if (RegExp(r'(?<![0-9])0$').hasMatch(s.calculationStr)) {
      s.delete();
    }
    return true;
  }

  List<CalculatorButtonDelegator> _buildDelegators(BuildContext context) {
    final operatorStyle =
        CalculatorButtonStyle(fontSize: 22, fontColor: Color(0xFF87898F));
    final numberStyle =
        CalculatorButtonStyle(fontSize: 26, fontColor: Colors.white);
    final clearBtnStyle = operatorStyle.copyWith(fontSize: 26);
    final equalBtnStyle = numberStyle.copyWith(
        btnColor: Theme.of(context).accentColor,
        shape: CircleBorder(),
        fontSize: 34,
        padding: EdgeInsets.all(2));
    final importantOpStyle = operatorStyle.copyWith(fontSize: 30);

    return [
      // clear button view
      CalculatorButtonDelegator(display: CLEAR_SIGN, style: clearBtnStyle),

      // delete button view
      CalculatorButtonDelegator(display: DELETE_SIGN, style: operatorStyle),

      // quote button view
      CalculatorButtonDelegator(
          display: LEFT_QUOTE_SIGN + ' ' + RIGHT_QUOTE_SIGN,
          style: operatorStyle,
          output: quoteOutput),

      // bitwise not button view
      CalculatorButtonDelegator(
          display: NOT_SIGN,
          style: importantOpStyle,
          invalid: _unaryOpValidate),

      // 7
      CalculatorButtonDelegator(
          display: '7', style: numberStyle, invalid: _numValidate),

      // 8
      CalculatorButtonDelegator(
          display: '8', style: numberStyle, invalid: _numValidate),

      // 9
      CalculatorButtonDelegator(
          display: '9', style: numberStyle, invalid: _numValidate),

      // bitwise and button view
      CalculatorButtonDelegator(
          display: AND_SIGN,
          style: importantOpStyle,
          invalid: _binaryOpValidate),

      // 4
      CalculatorButtonDelegator(
          display: '4', style: numberStyle, invalid: _numValidate),

      // 5
      CalculatorButtonDelegator(
          display: '5', style: numberStyle, invalid: _numValidate),

      // 6
      CalculatorButtonDelegator(
          display: '6', style: numberStyle, invalid: _numValidate),

      // bitwise or button view
      CalculatorButtonDelegator(
          display: OR_SIGN,
          style: importantOpStyle,
          invalid: _binaryOpValidate),

      // 1
      CalculatorButtonDelegator(
          display: '1', style: numberStyle, invalid: _numValidate),

      // 2
      CalculatorButtonDelegator(
          display: '2', style: numberStyle, invalid: _numValidate),

      // 3
      CalculatorButtonDelegator(
          display: '3', style: numberStyle, invalid: _numValidate),

      // bitwise xor button view
      CalculatorButtonDelegator(
          display: XOR_SIGN,
          style: importantOpStyle,
          invalid: _binaryOpValidate),

      // plus button view
      CalculatorButtonDelegator(
          display: PLUS_SIGN,
          style: importantOpStyle,
          invalid: _binaryOpValidate),

      // 0
      CalculatorButtonDelegator(
          display: '0', style: numberStyle, invalid: _numValidate),

      // minux button view
      CalculatorButtonDelegator(
          display: MINUS_SIGN,
          style: importantOpStyle,
          invalid: _binaryOpValidate),

      // equal button view
      CalculatorButtonDelegator(display: EQUAL_SIGN, style: equalBtnStyle)
    ];
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CalculationState>.value(
        notifier: _state,
        child: CalculatorKeyboard(
          delegators: _buildDelegators(context),
          calculator: _calculator,
          rowNum: 4,
          ratio: 1.25,
        ));
  }
}
