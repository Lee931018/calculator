import 'package:calculator/algorithm/calculator.dart';

class LogicalCalculator extends Calculator {
  @override
  PCompare compare(Operator op1, Operator op2) {
    return null;
  }

  @override
  compute(Operator op, List operands) {
    return null;
  }

  @override
  bool firstIsOperator(String s) {
    return null;
  }

  @override
  bool lastIsOperator(String s) {
    // TODO: implement isOperator
    return null;
  }

  @override
  readFirstOperand(String s) {
    return null;
  }

  @override
  Operator readFirstOperator(String s) {
    return null;
  }

  @override
  Operand readLastOperand(String s) {
    // TODO: implement readLastOperand
    return null;
  }

  @override
  Operator readLastOperator(String s) {
    // TODO: implement readLastOperator
    return null;
  }
}
