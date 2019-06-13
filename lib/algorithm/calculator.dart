import 'dart:collection';

import 'package:calculator/signs.dart';
import 'package:flutter/foundation.dart';

class CalculationInputError implements Exception {
  final Operator _op1;
  final Operator _op2;

  CalculationInputError(this._op1, this._op2);

  @override
  String toString() {
    String errorMsg;
    if (_op1 == null || _op2 == null) {
      errorMsg = 'there are some input error!';
    } else if (_op1.name == BOUNDARY_SIGN) {
      if (_op2.name == ')') {
        errorMsg = "missing (";
      }
      errorMsg = "operator ${_op1.name} cannot appear in the first place.";
    } else if (_op2.name == BOUNDARY_SIGN) {
      if (_op1.name == '(') {
        errorMsg = "missing )";
      }
      errorMsg = "operator ${_op1.name} cannot appear in the last place.";
    } else {
      errorMsg =
          "operator ${_op2.name} cannot appear behind the operator ${_op1.name}";
    }
    return errorMsg;
  }
}

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

enum PCompare { prior, less, equal, error }

class Operator {
  final String name;
  // indicate how many operands this operator needs
  final int level;
  Operator(this.name, this.level);
}

class Operand<T> {
  final T operand;
  final int length;

  Operand(this.operand, this.length);
}

abstract class Calculator<T> {
// the stack which store the operators from calculation string
  final _operators = ListQueue<Operator>();
// the stack which store the oparands from calculation string
  final _operands = ListQueue<T>();
// the operator means that it touch the end of the calculation string or operators stack
  final _endOperator = Operator(BOUNDARY_SIGN, 0);

// pre process the calculation string to handle some edge case
  @protected
  String preProcess(String s) {
    return s;
  }

// return if the first element in calculation string is operator
  bool firstIsOperator(String s);

// return if s is operator
  bool lastIsOperator(String s);

// read the operator from the begining of calculation strings
  Operator readFirstOperator(String s);

// read the next operand from calculation string
  Operand<T> readFirstOperand(String s);

// computing equation for the given operator with correspond operands
  @protected
  T compute(Operator op, List<T> operands);

  /// compare the priority between op1, and op2
  /// return the priority of op2 is less or prior or equal with op1
  ///  if return error, there are some problem with calculation string
  ///
  ///  @op1 the top operator in operators stack
  ///  @op2 the operator read from calculation string currently

  @protected
  PCompare compare(Operator op1, Operator op2);

  String formatResult(T result) {
    return result.toString();
  }

  /// get result of given calculation string
  ///
  /// @s the calculation string
  T calculate(String s) {
    // add boundary to operators stack and calculation string
    _operators.addLast(_endOperator);
    s = preProcess(s);
    s += BOUNDARY_SIGN;

    // parse calculation string until reach the end.
    while (_operators.last.name != BOUNDARY_SIGN || s[0] != BOUNDARY_SIGN) {
      // when the first elements in calculation string is operator
      if (firstIsOperator(s)) {
        // read the first operator from calculation string
        final op = readFirstOperator(s);

        switch (compare(_operators.last, op)) {
          // if the operator which read from calculation string is prior
          case PCompare.prior:
            // push the operator to operators stack
            _operators.addLast(op);
            // update the calculation string
            s = s.substring(op.name.length);
            break;
          // if the operator at the top of the operators stack is prior
          case PCompare.less:
            // pop the top operator from the operators stack for computation
            final topOp = _operators.removeLast();
            final calOpds = ListQueue<T>();
            // pop the coresponding number of operands from the operands stack for computation
            for (var i = 0; i < topOp.level; i++) {
              calOpds.addFirst(_operands.removeLast());
            }
            // push the result of computation back to operands stack
            _operands.addLast(compute(topOp, calOpds.toList()));
            break;
          // if the operator which read from calculation string have the same priority with the top operator in operators stack
          case PCompare.equal:
            // pop operator from the operators stack
            _operators.removeLast();
            // update the calculation string
            s = s.substring(op.name.length);
            break;
          case PCompare.error:
            _clear();
            throw CalculationInputError(_operators.last, op);
        }
      } else {
        // if the first elements of calculation string is operand, read first operand
        final operand = readFirstOperand(s);
        // update calculation string
        s = s.substring(operand.length);
        // push the operand read from calculation string to the operands stack
        _operands.addLast(operand.operand);
      }
    }

    if (_operands.length != 1) {
      _clear();
      throw CalculationInputError(null, null);
    }

    //now the result of calculation string is the top operand in the operands stack.
    final result = _operands.removeLast();
    _clear();
    return result;
  }

  _clear() {
    _operators.clear();
    _operands.clear();
  }
}

// the function that generate regular expression to match operator in the begining of calculation string
String genOpRegx(List<String> operators) {
  var regx = '(';
  operators.asMap().forEach((i, o) {
    if (o.length > 1) {
      regx += "($o)";
    } else if (o.length == 1) {
      regx += (r'\' + o);
    }
    if (i < operators.length - 1) {
      regx += '|';
    }
  });
  regx += ')';
  return regx;
}
