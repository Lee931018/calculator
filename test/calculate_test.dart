import 'package:calculator/algorithm/science.dart';
import 'package:flutter/physics.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("science calculator test", () {
    test('test isOperator method', () {
      final calculator = SicenceCalculate();
      expect(calculator.isOperator('9+0.5×2-(9-8)'), false);
      expect(calculator.isOperator('(9-7)×7'), true);
      expect(calculator.isOperator('-9-8'), false);
    });

    test('test readOperator and readOperand', () {
      final calculator = SicenceCalculate();
      expect(calculator.readOperand('9+0.5×2-(9-8)').operand, 9);
      expect(calculator.readOperand('-9+7').operand, -9);
      expect(calculator.readOperator('(9-7)×7').name, '(');
    });

    test('test calculate method', () {
      final calculator = SicenceCalculate();
      expect(calculator.calculate('9+0.5×2-(9-8)'), 9);
      expect(calculator.calculate('(9-7)×7'), 14);
      expect(calculator.calculate('9'), 9);
      expect(calculator.calculate('-9'), -9);
      expect(calculator.calculate('0- (-9+ 7 ) '), 2);
      var result = calculator.calculate('√7-cos(π÷2)+2^(2)-ln(2-1)');
      expect(nearEqual(result, 6.6457513111, 0.0000000001), true);
      result = calculator.calculate('(-6)^2-tan(-π÷3)');
      expect(nearEqual(result, 37.732050807569, 0.000000001), true);
    });
  });
}
