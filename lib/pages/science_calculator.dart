import 'package:calculator/algorithm/calculator.dart';
import 'package:calculator/algorithm/science.dart';
import 'package:calculator/component/calculator_button.dart';
import 'package:calculator/component/calculator_keyboard.dart';
import 'package:calculator/signs.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class ScienceCalculatorView extends StatelessWidget {
  ScienceCalculatorView() {
    print('Lee ScienceCalculatorView constructor called!');
  }

  final _state = CalculationState();

  final _calculator = ScienceCalculator();

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
    if (RegExp("($PIE|$E_NUM)" + r'$').hasMatch(s.calculationStr)) {
      return false;
    }
    // replace the bigining 0 at integer part
    if (RegExp(r'(?<![0-9.])0$').hasMatch(s.calculationStr)) {
      s.delete();
    }
    return true;
  }

  _specialNumValidate(Calculator c, CalculationState s) {
    return c.lastIsOperator(s.calculationStr);
  }

  _dotValidate(Calculator c, CalculationState s) {
    return RegExp(r'(?<![0-9.])[0-9]+$').hasMatch(s.calculationStr);
  }

  _minusValidate(Calculator c, CalculationState s) {
    final isEmpty = s.calculationStr == '';
    final isQuote = RegExp(r'\(|\)$').hasMatch(s.calculationStr);
    final isNotOp = !c.lastIsOperator(s.calculationStr);
    return isEmpty || isQuote || isNotOp;
  }

  List<CalculatorButtonDelegator> _buildDelegators(BuildContext context) {
    final operatorStyle =
        CalculatorButtonStyle(fontSize: 20, fontColor: Color(0xFF87898F));
    final numberStyle =
        CalculatorButtonStyle(fontSize: 24, fontColor: Colors.white);
    final clearBtnStyle = operatorStyle.copyWith(fontSize: 24);
    final equalBtnStyle = numberStyle.copyWith(
        btnColor: Theme.of(context).accentColor,
        shape: CircleBorder(),
        fontSize: 34,
        padding: EdgeInsets.all(2));
    final importantOpStyle = operatorStyle.copyWith(fontSize: 28);

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

      // mode button view
      CalculatorButtonDelegator(
          display: MODULAR_SIGN,
          style: operatorStyle,
          invalid: _binaryOpValidate),

      // π button
      CalculatorButtonDelegator(
          display: PIE, style: operatorStyle, invalid: _specialNumValidate),

      // sin button
      CalculatorButtonDelegator(
          display: SIN_SIGN,
          actual: SIN_SIGN + LEFT_QUOTE_SIGN,
          style: operatorStyle,
          invalid: _unaryOpValidate),

      // square root button
      CalculatorButtonDelegator(
          display: SQUARE_ROOT_SIGN,
          actual: SQUARE_ROOT_SIGN + LEFT_QUOTE_SIGN,
          style: operatorStyle,
          invalid: _unaryOpValidate),

      // squar button
      CalculatorButtonDelegator(
          display: 'x²',
          actual: "$POWER_SIGN${LEFT_QUOTE_SIGN}2$RIGHT_QUOTE_SIGN",
          style: operatorStyle,
          invalid: _binaryOpValidate),

      // exponential button
      CalculatorButtonDelegator(
          display: POWER_SIGN,
          style: operatorStyle,
          invalid: _binaryOpValidate),

      // division button
      CalculatorButtonDelegator(
          display: DIVISION_SIGN,
          style: importantOpStyle,
          invalid: _binaryOpValidate),

      // cos button
      CalculatorButtonDelegator(
          display: COS_SIGN,
          actual: COS_SIGN + LEFT_QUOTE_SIGN,
          style: operatorStyle,
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

      // multiplication button
      CalculatorButtonDelegator(
          display: MULTIPLICATION_SIGN,
          style: importantOpStyle,
          invalid: _binaryOpValidate),

      // tan button
      CalculatorButtonDelegator(
          display: TAN_SIGN,
          actual: TAN_SIGN + LEFT_QUOTE_SIGN,
          style: operatorStyle,
          invalid: _unaryOpValidate),

      // 4
      CalculatorButtonDelegator(
          display: '4', style: numberStyle, invalid: _numValidate),

      // 5
      CalculatorButtonDelegator(
          display: '5', style: numberStyle, invalid: _numValidate),

      // 6
      CalculatorButtonDelegator(
          display: '6', style: numberStyle, invalid: _numValidate),

      // minus button
      CalculatorButtonDelegator(
          display: MINUS_SIGN,
          style: importantOpStyle,
          invalid: _minusValidate),

      // ln button
      CalculatorButtonDelegator(
          display: LN_SIGN,
          actual: LN_SIGN + LEFT_QUOTE_SIGN,
          style: operatorStyle,
          invalid: _unaryOpValidate),

      // 1
      CalculatorButtonDelegator(
          display: '1', style: numberStyle, invalid: _numValidate),

      // 2
      CalculatorButtonDelegator(
          display: '2', style: numberStyle, invalid: _numValidate),

      // 3
      CalculatorButtonDelegator(
          display: '3', style: numberStyle, invalid: _numValidate),

      // plus button
      CalculatorButtonDelegator(
          display: PLUS_SIGN,
          style: importantOpStyle,
          invalid: _binaryOpValidate),

      // lg button
      CalculatorButtonDelegator(
          display: LG_SIGN,
          actual: LG_SIGN + LEFT_QUOTE_SIGN,
          style: operatorStyle,
          invalid: _unaryOpValidate),

      // e
      CalculatorButtonDelegator(
          display: E_NUM, style: operatorStyle, invalid: _specialNumValidate),

      // 0
      CalculatorButtonDelegator(
          display: '0', style: numberStyle, invalid: _numValidate),

      // dot button
      CalculatorButtonDelegator(
          display: DECIMAL_POINT_SIGN,
          style: numberStyle,
          invalid: _dotValidate),

      // equal button view
      CalculatorButtonDelegator(display: EQUAL_SIGN, style: equalBtnStyle)
    ];
  }

  @override
  Widget build(BuildContext context) {
    print('Lee ScienceCalculatorView build called!');
    return ChangeNotifierProvider<CalculationState>.value(
        notifier: _state,
        child: CalculatorKeyboard(_buildDelegators(context), _calculator, 5));
  }
}
