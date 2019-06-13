import 'package:calculator/pages/logical_calculator.dart';
import 'package:flutter/material.dart';
import 'pages/science_calculator.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Calculator',
        theme: ThemeData(
            primaryColor: Color(0xFF414449),
            primaryColorDark: Color(0xFF242532),
            accentColor: Color(0xFFD20024)),
        home: CalculatorMainPage());
  }
}

class CalculatorMainPage extends StatefulWidget {
  CalculatorMainPage({Key key}) : super(key: key);

  @override
  _CalculatorMainPageState createState() => _CalculatorMainPageState();
}

enum Calculators { scientific, logical }

class _CalculatorMainPageState extends State<CalculatorMainPage> {
  var _selected = Calculators.scientific;
  final _tabTextStyle = TextStyle(fontSize: 17);
  final _controller = PageController();
  final _scientificCalculatorView = ScienceCalculatorView();
  final _logicalCalculatorView = LogicalCalculatorView();

  _selectTab(Calculators type) {
    if (_selected == type) return;
    setState(() {
      _selected = type;
    });
  }

  @override
  void initState() {
    super.initState();

    _controller.addListener(() {
      if (_controller.page == 0) {
        _selectTab(Calculators.scientific);
      } else if (_controller.page == 1) {
        _selectTab(Calculators.logical);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var scientificTextColor;
    var logicalTextColor;
    if (_selected == Calculators.scientific) {
      scientificTextColor = Theme.of(context).accentColor;
      logicalTextColor = Colors.white;
    } else {
      scientificTextColor = Colors.white;
      logicalTextColor = Theme.of(context).accentColor;
    }
    return Scaffold(
        appBar: AppBar(
          flexibleSpace: SafeArea(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                FlatButton(
                  highlightColor: Colors.white30,
                  child: Text(
                    'Scientific',
                    style: _tabTextStyle.copyWith(color: scientificTextColor),
                  ),
                  onPressed: () {
                    _selectTab(Calculators.scientific);
                    _controller.jumpToPage(0);
                  },
                ),
                FlatButton(
                  highlightColor: Colors.white30,
                  child: Text(
                    'Logical',
                    style: _tabTextStyle.copyWith(color: logicalTextColor),
                  ),
                  onPressed: () {
                    _selectTab(Calculators.logical);
                    _controller.jumpToPage(1);
                  },
                )
              ],
            ),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.history),
              onPressed: () {},
            )
          ],
        ),
        body: PageView(
          controller: _controller,
          children: <Widget>[_scientificCalculatorView, _logicalCalculatorView],
        ));
  }
}
