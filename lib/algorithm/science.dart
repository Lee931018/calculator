import 'dart:math';

import 'package:calculator/algorithm/calculate.dart';
import 'package:flutter/foundation.dart';
import '../signs.dart';

class OperandsError<T> implements Exception {
  final Operator _op;
  final List<T> _operands;
  OperandsError(this._op, this._operands);

  @override
  String toString() {
    if (_op.level != _operands.length) {
      return "operator ${_op.name} need ${_op.level} operands, but find ${_operands.length}";
    }
    return "operator ${_op.name} have some thing wrong with operands ${_operands.toString()}";
  }
}

class SicenceCalculate extends Calculate<double> {
  final _numberRegExp = RegExp(r'^-?(([0-9]+(\.[0-9]+)?)|π|e)');
  final _operatorRegExp = RegExp(_genOpRegx([
    PLUS_SIGN,
    MINUS_SIGN,
    MULTIPLICATION_SIGN,
    DIVISION_SIGN,
    POWER_SIGN,
    SQUARE_ROOT_OP,
    LG_SIGN,
    LN_SIGN,
    MODULAR_SIGN,
    SIN_SIGN,
    COS_SIGN,
    TAN_SIGN,
    LEFT_QUOTE_SIGN,
    RIGHT_QUOTE_SIGN,
    BOUNDARY_SIGN,
  ]));
  static final _level1 = 'level1';
  static final _level2 = 'level2';
  static final _level3 = 'level3';
  final _operatorIndex = {
    PLUS_SIGN: 0,
    MINUS_SIGN: 1,
    MULTIPLICATION_SIGN: 2,
    DIVISION_SIGN: 3,
    POWER_SIGN: 4,
    SQUARE_ROOT_OP: 5,
    LG_SIGN: 6,
    LN_SIGN: 7,
    MODULAR_SIGN: 8,
    SIN_SIGN: 9,
    COS_SIGN: 10,
    TAN_SIGN: 11,
    LEFT_QUOTE_SIGN: 12,
    RIGHT_QUOTE_SIGN: 13,
    BOUNDARY_SIGN: 14
  };
  final _priorMap = {
    0: PCompare.error,
    1: PCompare.less,
    2: PCompare.prior,
    3: PCompare.equal
  };

  final _priorCompare = {
    _level1: [1, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 1],
    _level2: [1, 1, 1, 1, 2, 2, 2, 2, 1, 2, 2, 2, 2, 1, 1],
    _level3: [1, 1, 1, 1, 1, 2, 2, 2, 1, 2, 2, 2, 2, 1, 1],
    LEFT_QUOTE_SIGN: [2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 3, 0],
    RIGHT_QUOTE_SIGN: [1, 1, 1, 1, 1, 0, 0, 0, 1, 0, 0, 0, 0, 1, 1],
    BOUNDARY_SIGN: [2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 0, 3]
  };

// the function that generate regular expression to match operator in the begining of calculation string
  static String _genOpRegx(List<String> operators) {
    var regx = r'^(';
    operators.asMap().forEach((i, o) {
      if (o.length > 1) {
        regx += ('(' + o + ')');
      } else if (o.length == 1) {
        regx += (r'\' + o);
      }
      if (i < operators.length - 1) {
        regx += '|';
      }
    });
    regx += r')';
    return regx;
  }

  @override
  @protected
  String preProcess(String s) {
    final blankReg = RegExp(r'\s.*?');
    // remove all of the blank
    s = s.replaceAll(blankReg, '');
    // replace all of the 'a-b' to 'a+-b' to match minus number.
    final regExp =
        RegExp(r'(?<=([0-9]+(\.[0-9]+)?)|π|e)-(?=([0-9]+(\.[0-9]+)?)|π|e)');
    return s.replaceAll(regExp, '+-');
  }

  @override
  @protected
  PCompare compare(Operator op1, Operator op2) {
    String key;
    switch (op1.name) {
      case PLUS_SIGN:
      case MINUS_SIGN:
        key = _level1;
        break;
      case MULTIPLICATION_SIGN:
      case DIVISION_SIGN:
      case MODULAR_SIGN:
        key = _level2;
        break;
      case POWER_SIGN:
      case SQUARE_ROOT_OP:
      case LG_SIGN:
      case LN_SIGN:
      case SIN_SIGN:
      case COS_SIGN:
      case TAN_SIGN:
        key = _level3;
        break;
      case LEFT_QUOTE_SIGN:
        key = LEFT_QUOTE_SIGN;
        break;
      case RIGHT_QUOTE_SIGN:
        key = RIGHT_QUOTE_SIGN;
        break;
      case BOUNDARY_SIGN:
        key = BOUNDARY_SIGN;
    }

    return _priorMap[_priorCompare[key][_operatorIndex[op2.name]]];
  }

  @override
  @protected
  double compute(Operator op, List<double> operands) {
    if (operands.length != op.level) {
      throw OperandsError<double>(op, operands);
    }

    switch (op.name) {
      case PLUS_SIGN:
        return operands[0] + operands[1];
      case MINUS_SIGN:
        return operands[0] - operands[1];
      case MULTIPLICATION_SIGN:
        return operands[0] * operands[1];
      case DIVISION_SIGN:
        return operands[0] / operands[1];
      case POWER_SIGN:
        return pow(operands[0], operands[1]);
      case MODULAR_SIGN:
        return operands[0] % operands[1];
      case SQUARE_ROOT_OP:
        return sqrt(operands[0]);
      case LG_SIGN:
        return log(operands[0]) / ln10;
      case LN_SIGN:
        return log(operands[0]);
      case SIN_SIGN:
        return sin(operands[0]);
      case COS_SIGN:
        return cos(operands[0]);
      case TAN_SIGN:
        return tan(operands[0]);
    }
    return null;
  }

  @override
  @protected
  bool isOperator(String s) {
    return !_numberRegExp.hasMatch(s);
  }

  @override
  @protected
  Operand<double> readOperand(String s) {
    final matched = _numberRegExp.firstMatch(s).group(0);
    var operand;
    switch (matched) {
      case 'π':
        operand = pi;
        break;
      case '-π':
        operand = -pi;
        break;
      case 'e':
        operand = e;
        break;
      case '-e':
        operand = -e;
        break;
      default:
        operand = double.parse(matched);
    }
    return Operand(operand, matched.length);
  }

  @override
  @protected
  Operator readOperator(String s) {
    final op = _operatorRegExp.firstMatch(s).group(0);
    var operandsNum = 0;
    switch (op) {
      case PLUS_SIGN:
      case MINUS_SIGN:
      case MULTIPLICATION_SIGN:
      case DIVISION_SIGN:
      case POWER_SIGN:
      case MODULAR_SIGN:
        operandsNum = 2;
        break;
      case SQUARE_ROOT_OP:
      case LG_SIGN:
      case LN_SIGN:
      case SIN_SIGN:
      case COS_SIGN:
      case TAN_SIGN:
        operandsNum = 1;
        break;
      case LEFT_QUOTE_SIGN:
      case RIGHT_QUOTE_SIGN:
      case BOUNDARY_SIGN:
        operandsNum = 0;
        break;
    }
    return Operator(op, operandsNum);
  }
}
