import 'package:calculator/algorithm/calculator.dart';
import 'package:calculator/component/calculator_keyboard.dart';
import 'package:calculator/signs.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CalculatorButtonStyle {
  final Color fontColor;
  final double fontSize;
  final ShapeBorder shape;
  final Color btnColor;
  final Color bgColor;
  final EdgeInsetsGeometry padding;

  const CalculatorButtonStyle(
      {this.fontColor,
      this.fontSize,
      this.shape,
      this.btnColor,
      this.bgColor,
      this.padding});

  CalculatorButtonStyle copyWith(
      {Color fontColor,
      double fontSize,
      ShapeBorder shape,
      Color btnColor,
      Color bgColor,
      EdgeInsetsGeometry padding}) {
    return CalculatorButtonStyle(
        fontColor: fontColor ?? this.fontColor,
        fontSize: fontSize ?? this.fontSize,
        shape: shape ?? this.shape,
        btnColor: btnColor ?? this.btnColor,
        bgColor: bgColor ?? this.bgColor,
        padding: padding ?? this.padding);
  }
}

class CalculatorButton extends StatelessWidget {
  final CalculatorButtonDelegator delegator;

  CalculatorButton(this.delegator);

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<CalculationState>(context);
    final calculator = Provider.of<Calculator>(context);
    return Container(
      padding: delegator.style.padding,
      color: delegator.style.bgColor ?? Theme.of(context).primaryColorDark,
      child: FlatButton(
        onPressed: () => delegator.action(calculator, state),
        shape: delegator.style.shape,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        color: delegator.style.btnColor,
        highlightColor: Colors.white30,
        child: Text(
          delegator.display,
          style: TextStyle(
              fontSize: delegator.style.fontSize ?? 14,
              color: delegator.style.fontColor ?? Colors.white),
        ),
      ),
    );
  }
}

class CalculatorButtonDelegator {
  final CalculatorButtonStyle style;
  final String display;
  final String actual;
  final Function(Calculator, CalculationState) output;
  final Function(Calculator, CalculationState) invalid;

  CalculatorButtonDelegator(
      {@required this.display,
      this.actual,
      this.invalid,
      this.output,
      this.style});

  action(Calculator calculator, CalculationState state) {
    switch (display) {
      case CLEAR_SIGN:
        state.clear();
        break;
      case DELETE_SIGN:
        state.delete();
        break;
      case EQUAL_SIGN:
        state.calculate(calculator);
        break;
      default:
        if (invalid != null && !invalid(calculator, state)) {
          return;
        }
        var outputStr;
        if (output != null) {
          outputStr = output(calculator, state);
        } else {
          outputStr = actual ?? display;
        }
        state.output(outputStr);
    }
  }
}

String quoteOutput(Calculator calculator, CalculationState state) {
  if (state.calculationStr == '') {
    return LEFT_QUOTE_SIGN;
  }

  final haveUnClosed = state.uncloseQuoteCount > 0;
  final lastIsOperator = calculator.lastIsOperator(state.calculationStr);
  final lastIsRightQuote = state.calculationStr.lastIndexOf(RIGHT_QUOTE_SIGN) ==
      state.calculationStr.length - 1;

  if (haveUnClosed) {
    if (lastIsRightQuote || !lastIsOperator) {
      return RIGHT_QUOTE_SIGN;
    }
    return LEFT_QUOTE_SIGN;
  } else {
    if (lastIsRightQuote || !lastIsOperator) {
      return '';
    }
    return LEFT_QUOTE_SIGN;
  }
}
