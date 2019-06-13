import 'package:calculator/main.dart';
import 'package:calculator/model/model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

Future<Database> database;
final DB_NAME = 'calculator';
final HISTORIES_TABLE = 'histories';

connectDb() async {
  database = openDatabase(join(await getDatabasesPath(), "$DB_NAME.db"),
      onCreate: (db, version) {
    db.execute(
      "CREATE TABLE $HISTORIES_TABLE(id INTEGER PRIMARY KEY AUTOINCREMENT, calculation TEXT, type INTEGER)",
    );
  }, version: 1);
}

addToHistory(String s, Calculators type) async {
  final db = await database;
  final calculation = Calculation(s, type);
  db.insert(HISTORIES_TABLE, calculation.toMap());
}

Future<List<Calculation>> getHistories(Calculators type) async {
  final db = await database;
  final List<Map<String, dynamic>> results = await db.query(HISTORIES_TABLE,
      where: "type=${type == Calculators.scientific ? 0 : 1}");
  return results.map((r) {
    final t = r['type'] == 0 ? Calculators.scientific : Calculators.bitwise;
    return Calculation(r['calculation'], t);
  }).toList();
}
