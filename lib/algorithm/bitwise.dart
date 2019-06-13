import 'package:calculator/algorithm/calculator.dart';
import 'package:calculator/signs.dart';

class BitwiseCalculator extends Calculator {
  static final _numberPattern = r'([0-9]+)';
  static final _operatorPattern = genOpRegx([
    PLUS_SIGN,
    MINUS_SIGN,
    AND_SIGN,
    OR_SIGN,
    NOT_SIGN,
    XOR_SIGN,
    LEFT_QUOTE_SIGN,
    RIGHT_QUOTE_SIGN,
    BOUNDARY_SIGN,
  ]);
  final _operatorIndex = {
    PLUS_SIGN: 0,
    MINUS_SIGN: 1,
    AND_SIGN: 2,
    OR_SIGN: 3,
    NOT_SIGN: 4,
    XOR_SIGN: 5,
    LEFT_QUOTE_SIGN: 6,
    RIGHT_QUOTE_SIGN: 7,
    BOUNDARY_SIGN: 8,
  };
  final _priorMap = {
    0: PCompare.error,
    1: PCompare.less,
    2: PCompare.prior,
    3: PCompare.equal
  };
  final _priorCompare = {
    PLUS_SIGN: [1, 1, 1, 1, 2, 1, 2, 1, 1],
    MINUS_SIGN: [1, 1, 1, 1, 2, 1, 2, 1, 1],
    AND_SIGN: [2, 2, 1, 1, 2, 1, 2, 1, 1],
    OR_SIGN: [2, 2, 2, 1, 2, 2, 2, 1, 1],
    NOT_SIGN: [1, 1, 1, 1, 1, 1, 2, 1, 1],
    XOR_SIGN: [2, 2, 2, 1, 2, 1, 2, 1, 1],
    LEFT_QUOTE_SIGN: [2, 2, 2, 2, 2, 2, 2, 3, 0],
    RIGHT_QUOTE_SIGN: [1, 1, 1, 1, 0, 1, 0, 1, 1],
    BOUNDARY_SIGN: [2, 2, 2, 2, 2, 2, 2, 0, 3],
  };

  @override
  PCompare compare(Operator op1, Operator op2) {
    return _priorMap[_priorCompare[op1.name][_operatorIndex[op2.name]]];
  }

  @override
  compute(Operator op, List operands) {
    if (operands.length != op.level) {
      throw OperandsError<int>(op, operands);
    }

    switch (op.name) {
      case PLUS_SIGN:
        return operands[0] + operands[1];
      case MINUS_SIGN:
        return operands[0] - operands[1];
      case AND_SIGN:
        return operands[0] & operands[1];
      case OR_SIGN:
        return operands[0] | operands[1];
      case NOT_SIGN:
        return ~operands[0];
      case XOR_SIGN:
        return operands[0] ^ operands[1];
    }
    return null;
  }

  @override
  bool firstIsOperator(String s) {
    return RegExp('^' + _operatorPattern).hasMatch(s);
  }

  @override
  bool lastIsOperator(String s) {
    return RegExp(_operatorPattern + r'$').hasMatch(s);
  }

  @override
  Operand<int> readFirstOperand(String s) {
    final numberRegExp = RegExp("^$_numberPattern");
    final matched = numberRegExp.firstMatch(s).group(0);
    return Operand(int.parse(matched), matched.length);
  }

  @override
  Operator readFirstOperator(String s) {
    final operatorRegExp = RegExp("^$_operatorPattern");
    final op = operatorRegExp.firstMatch(s).group(0);
    var operandsNum = 0;
    switch (op) {
      case NOT_SIGN:
        operandsNum = 1;
        break;
      case PLUS_SIGN:
      case MINUS_SIGN:
      case AND_SIGN:
      case OR_SIGN:
      case XOR_SIGN:
        operandsNum = 2;
        break;
      case LEFT_QUOTE_SIGN:
      case RIGHT_QUOTE_SIGN:
      case BOUNDARY_SIGN:
        operandsNum = 0;
    }
    return Operator(op, operandsNum);
  }
}
