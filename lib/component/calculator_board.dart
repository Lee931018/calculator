import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:calculator/state.dart';

class CalculatorBoard extends StatefulWidget {
  Color bgColor;

  CalculatorBoard({this.bgColor});

  @override
  _CalculatorBoardState createState() => _CalculatorBoardState();
}

class _CalculatorBoardState extends State<CalculatorBoard> {
  double _calculationTextSize = 30;

  @override
  Widget build(BuildContext context) {
    return Consumer<CalculationState>(builder: (context, state, _) {
      const historyTextStyle = TextStyle(fontSize: 17, color: Colors.white24);
      const calculationTextStyle = TextStyle(color: Colors.white);
      return Expanded(
        child: Container(
          width: double.infinity,
          color: widget.bgColor ?? Theme.of(context).primaryColor,
          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Text(
                state.history,
                style: historyTextStyle,
              ),
              Text(
                state.calculationStr,
                style: calculationTextStyle.copyWith(
                    fontSize: _calculationTextSize),
              )
            ],
          ),
        ),
      );
    });
  }
}
