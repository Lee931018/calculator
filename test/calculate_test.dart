import 'dart:math';

import 'package:calculator/algorithm/bitwise.dart';
import 'package:calculator/algorithm/science.dart';
import 'package:flutter/physics.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("science calculator", () {
    test('test is operator', () {
      final calculator = ScienceCalculator();
      expect(calculator.firstIsOperator('9+0.5×2-(9-8)'), false);
      expect(calculator.firstIsOperator('(9-7)×7'), true);
      expect(calculator.firstIsOperator('-9-8'), false);
      expect(calculator.lastIsOperator('9+6'), false);
      expect(calculator.lastIsOperator('0'), false);
      expect(calculator.lastIsOperator('0-'), true);
      expect(calculator.lastIsOperator('6+tan'), true);
      expect(calculator.lastIsOperator('e'), false);
    });

    test('test read operand', () {
      final calculator = ScienceCalculator();
      expect(calculator.readFirstOperand('9+0.5×2-(9-8)').operand, 9);
      expect(calculator.readFirstOperand('-9+7').operand, -9);
      expect(calculator.readFirstOperand('e+3').operand, e);
    });

    test('test read operator', () {
      final calculator = ScienceCalculator();
      expect(calculator.readFirstOperator('(9-7)×7').name, '(');
      expect(calculator.readFirstOperator('tan3+6').name, 'tan');
    });

    test('test calculate method', () {
      final calculator = ScienceCalculator();
      expect(calculator.calculate('9+0.5×2-(9-8)'), 9);
      expect(calculator.calculate('(9-7)×7'), 14);
      expect(calculator.calculate('9'), 9);
      expect(calculator.calculate('-9'), -9);
      expect(calculator.calculate('0- (-9+ 7 ) '), 2);
      var result = calculator.calculate('√7-cos(π÷2)+2^(2)-ln(2-1)');
      expect(nearEqual(result, 6.6457513111, 0.0000000001), true);
      result = calculator.calculate('(-6)^2-tan(-π÷3)');
      expect(nearEqual(result, 37.732050807569, 0.000000001), true);
      result = calculator.calculate('√45-(1)-1');
      expect(nearEqual(result, 4.7082039325, 0.0000000001), true);
    });
  });

  group('bitwise calculator', () {
    test('test is operator', () {
      final calculator = BitwiseCalculator();
      expect(calculator.firstIsOperator('+6'), true);
      expect(calculator.firstIsOperator('~6'), true);
      expect(calculator.firstIsOperator('&6'), true);
      expect(calculator.firstIsOperator('6^0'), false);
      expect(calculator.lastIsOperator('6^'), true);
      expect(calculator.lastIsOperator('6|'), true);
      expect(calculator.lastIsOperator('6&'), true);
      expect(calculator.lastIsOperator('6^5'), false);
    });

    test('test read operand', () {
      final calculator = BitwiseCalculator();
      expect(calculator.readFirstOperand('6+5').operand, 6);
      expect(calculator.readFirstOperand('100^5').operand, 100);
    });

    test('test read operator', () {
      final calculator = BitwiseCalculator();
      expect(calculator.readFirstOperator('&5-6').name, '&');
      expect(calculator.readFirstOperator('~5-6').name, '~');
      expect(calculator.readFirstOperator('+5-6').name, '+');
      expect(calculator.readFirstOperator('(5-6').name, '(');
    });

    test('test calculate method', () {
      final calculator = BitwiseCalculator();
      expect(calculator.calculate('5'), 5);
      expect(calculator.calculate('5+10'), 15);
      expect(calculator.calculate('5-6'), -1);
      expect(calculator.calculate('6|5'), 7);
      expect(calculator.calculate('6^5'), 3);
      expect(calculator.calculate('6&5'), 4);
      expect(calculator.calculate('~6^5'), -4);
      expect(calculator.calculate('6|5&10^5+(6|5)^2'), 14);
    });
  });
}
