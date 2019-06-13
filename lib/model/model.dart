import 'package:calculator/main.dart';

class Calculation {
  final String calculation;
  int type;

  Calculation(this.calculation, Calculators type) {
    this.type = type == Calculators.scientific ? 0 : 1;
  }

  Map<String, dynamic> toMap() {
    return {
      'calculation': calculation,
      'type': type,
    };
  }
}
