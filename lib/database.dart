import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

const alarmTable = "alarms";
const nameCol = "drug";
const timeCol = "time";
const dateCol = "date";

_recoverBD() async {
  final filepath = await getDatabasesPath();
  final dbpath = join(filepath, 'lifecare.db');

  var result = await openDatabase(
    dbpath,
    version: 1,
    onCreate: (db, dbRecentVersion) async {
      await db.execute("CREATE TABLE $alarmTable (id INTEGER PRIMARY KEY AUTOINCREMENT, $nameCol TEXT, $timeCol TEXT, $dateCol TEXT)");
    }
  );

  if (!result.isOpen) {
    print("DB INIT error");
  }

  return result;
}

save(String name, String time, String date) async {
  Database db = await _recoverBD();
  Map<String, dynamic> value = {
    nameCol: name,
    timeCol: time,
    dateCol: date
  };
  int id = await db.insert(alarmTable, value);
}

getDrugsofDay(String date) async { // getDrugsofDay("${n.month}/${n.day+1}/${n.year}")
  Database db = await _recoverBD();
  return db.rawQuery("SELECT * FROM $alarmTable WHERE $dateCol = '$date'");
}

getDrugsDay() async {
  Database db = await _recoverBD();
  List<String> filtered = [];
  List<Map<String, dynamic>> dates = await db.rawQuery("SELECT $dateCol FROM $alarmTable");
  dates.forEach((date) {
    bool not_found = true;
    filtered.forEach((element) {
      if (element == date["date"]) not_found = false;
    });
    if (not_found) filtered.add(date["date"]);
  });
  return filtered;
}
