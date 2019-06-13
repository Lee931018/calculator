import 'dart:collection';
import 'package:calculator/algorithm/calculator.dart';
import 'package:calculator/main.dart';
import 'package:calculator/model/db.dart';
import 'package:calculator/signs.dart';
import 'package:flutter/widgets.dart';

class CalculationState with ChangeNotifier {
  final Calculators _type;
  CalculationState(this._type);

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
      addToHistory(calculationStr, _type);
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

  input(Calculator calculator, String calculation) {
    _calculationSigns = ListQueue();
    _uncloseQuoteCount = 0;

    if (calculator.firstIsOperator(calculation)) {
      final op = calculator.readFirstOperator(calculation);
      if (op.name == LEFT_QUOTE_SIGN) {
        _uncloseQuoteCount++;
      } else if (op.name == RIGHT_QUOTE_SIGN) {
        _uncloseQuoteCount--;
      }
      _calculationSigns.add(op.name);
      calculation = calculation.substring(0, op.name.length);
    } else {
      final oprand = calculator.readFirstOperand(calculation);
      _calculationSigns.addAll(oprand.operand.toString().split(''));
      calculation = calculation.substring(0, oprand.length);
    }
    notifyListeners();
  }
}

class CalculationInputNotifacation extends Notification {
  final String calculation;

  CalculationInputNotifacation(this.calculation);
}
