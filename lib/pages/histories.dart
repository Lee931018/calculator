import 'package:calculator/main.dart';
import 'package:calculator/model/db.dart';
import 'package:calculator/model/model.dart';
import 'package:calculator/state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Histories extends StatelessWidget {
  final Calculators type;
  Histories(this.type);

  Widget buildItem(BuildContext context, Calculation c) {
    return ListTile(
        title: Text(
          c.calculation,
          style: TextStyle(color: Colors.white, fontSize: 22),
        ),
        onTap: () {
          CalculationInputNotifacation(c.calculation)..dispatch(context);
          Navigator.pop(context);
        });
  }

  @override
  Widget build(BuildContext context) {
    final title = type == Calculators.scientific
        ? 'Scientific Histories'
        : 'Bitwise History';
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text(title),
        ),
        body: FutureBuilder<List<Calculation>>(
          future: getHistories(type),
          builder: (BuildContext context,
              AsyncSnapshot<List<Calculation>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container(
                alignment: Alignment.center,
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              print(snapshot.error);
              return Container(
                alignment: Alignment.center,
                child: Text(
                  'Error!',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              );
            } else {
              return ListView.separated(
                separatorBuilder: (context, i) => Divider(
                      height: 1,
                      color: Colors.white,
                    ),
                itemCount: snapshot.data.length,
                itemBuilder: (context, i) =>
                    buildItem(context, snapshot.data[i]),
              );
            }
          },
        ));
  }
}
