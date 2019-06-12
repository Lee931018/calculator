import 'dart:collection';

import 'package:calculator/algorithm/calculator.dart';
import 'package:calculator/component/calculator_board.dart';
import 'package:calculator/component/calculator_button.dart';
import 'package:calculator/signs.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CalculatorKeyboard extends StatelessWidget {
  final List<CalculatorButtonDelegator> btnDelegators;
  final Calculator calculator;
  final int rowNum;

  CalculatorKeyboard(this.btnDelegators, this.calculator, this.rowNum);

  @override
  Widget build(BuildContext context) {
    return Consumer<CalculationState>(builder: (context, calculationStr, _) {
      return Column(
        children: <Widget>[
          CalculatorBoard(),
          GridView.count(
            primary: false,
            childAspectRatio: 1.2,
            crossAxisCount: this.rowNum,
            shrinkWrap: true,
            children: btnDelegators
                .map((delegator) => Provider<Calculator>.value(
                    value: calculator, child: CalculatorButton(delegator)))
                .toList(),
          ),
        ],
      );
    });
  }
}

class CalculationState with ChangeNotifier {
  var _calculationSigns = ListQueue<String>();
  String get calculationStr => _calculationSigns.join();

  // unclosed quote number
  var _uncloseQuoteCount = 0;
  get uncloseQuoteCount => _uncloseQuoteCount;

  String _result = '';

  String _history = '';
  get history => _history;

  bool _clearResult() {
    if (_result == CALCULATE_ERROR) {
      _result = '';
      _calculationSigns = ListQueue();
      _uncloseQuoteCount = 0;
      return true;
    }
    return false;
  }

  output(String sign) {
    if (sign == '') {
      return;
    }
    _clearResult();
    _calculationSigns.add(sign);
    sign.split('').forEach((c) {
      if (c == LEFT_QUOTE_SIGN) {
        _uncloseQuoteCount++;
      } else if (c == RIGHT_QUOTE_SIGN) {
        _uncloseQuoteCount--;
      }
    });
    notifyListeners();
  }

  delete() {
    if (_clearResult()) {
      return;
    }
    if (_calculationSigns.isEmpty) {
      return;
    }
    _calculationSigns.last.split('').forEach((c) {
      if (c == LEFT_QUOTE_SIGN) {
        _uncloseQuoteCount--;
      } else if (c == RIGHT_QUOTE_SIGN) {
        _uncloseQuoteCount++;
      }
    });
    _calculationSigns.removeLast();
    notifyListeners();
  }

  clear() {
    if (_calculationSigns.isNotEmpty) {
      _calculationSigns = ListQueue();
      _uncloseQuoteCount = 0;
      notifyListeners();
    } else if (_history != '') {
      _history = '';
      notifyListeners();
    }
  }

  calculate(Calculator calculator) {
    if (_calculationSigns.isEmpty) {
      return;
    }
    _history = calculationStr;
    try {
      _result = calculator.formatResult(calculator.calculate(calculationStr));
      _calculationSigns = ListQueue.from(_result.split(''));
    } catch (e) {
      _result = CALCULATE_ERROR;
      _calculationSigns = ListQueue.from([_result]);
      print("calculate error: " + e.toString());
    } finally {
      _uncloseQuoteCount = 0;
      notifyListeners();
    }
  }
}
