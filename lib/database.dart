import 'package:life_care/notifications.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

const alarmTable = "alarms";
const nameCol = "drug";
const timeCol = "time";
const dateCol = "date";
const activeCol = "active";
const alarmIdCol = "alarmId";

int _id = 1;

_recoverBD() async {
  final filepath = await getDatabasesPath();
  final dbpath = join(filepath, 'lifecare.db');

  var result = await openDatabase(
    dbpath,
    version: 1,
    onCreate: (db, dbRecentVersion) async {
      await db.execute("CREATE TABLE $alarmTable (id INTEGER PRIMARY KEY AUTOINCREMENT, $alarmIdCol TEXT, $nameCol TEXT, $timeCol TEXT, $dateCol TEXT, $activeCol BOOLEAN)");
    }
  );

  if (!result.isOpen) {
    print("DB INIT error");
  }

  return result;
}

save(String name, String time, String date, context) async {
  Database db = await _recoverBD();
  _id++;
  int month = int.parse(date.split('/')[0]);
  int day = int.parse(date.split('/')[1]);
  int year = int.parse(date.split('/')[2]);
  int hour = int.parse(time.split(':')[0]);
  int min = int.parse(time.split(':')[1]);
  Provider.of<NotificationService>(context, listen: false).showNotification(
      CustomNotification(
          id: _id,
          title: "Take your $name!",
          body: "Don't forget to take your $name! Now It's the time!",
          payload: name
      ),
    DateTime(year, month, day, hour,min)
  );
  Map<String, dynamic> value = {
    nameCol: name,
    timeCol: time,
    dateCol: date,
    activeCol: 1,
    alarmIdCol: _id
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

invertActivation(int id, context) async {
  Database db = await _recoverBD();
  if (1 == (await db.rawQuery("SELECT $activeCol FROM $alarmTable WHERE id = $id"))[0]['active']) {
    String? id_target = (await db.rawQuery('SELECT * FROM $alarmTable WHERE id = $id'))[0][alarmIdCol].toString();
    Provider.of<NotificationService>(context, listen: false).cancelNotification(int.parse(id_target));
    await db.rawQuery("UPDATE $alarmTable SET $activeCol = 0 WHERE id = $id");
  } else {
    String? date = (await db.rawQuery('SELECT * FROM $alarmTable WHERE id = $id'))[0][dateCol].toString();
    String? time = (await db.rawQuery('SELECT * FROM $alarmTable WHERE id = $id'))[0][timeCol].toString();
    String? drug = (await db.rawQuery('SELECT * FROM $alarmTable WHERE id = $id'))[0][nameCol].toString();
    int month = int.parse(date.split('/')[0]);
    int day = int.parse(date.split('/')[1]);
    int year = int.parse(date.split('/')[2]);
    int hour = int.parse(time.split(':')[0]);
    int min = int.parse(time.split(':')[1]);
    _id++;
    Provider.of<NotificationService>(context, listen: false).showNotification(
        CustomNotification(
            id: _id,
            title: "Take your $drug!",
            body: "Don't forget to take your $drug! Now It's the time!",
            payload: drug
        ),
        DateTime(year, month, day, hour,min)
    );
    await db.rawQuery("UPDATE $alarmTable SET $activeCol = 1, $alarmIdCol = $_id WHERE id = $id");
  }
}

Future<Map<String, List<int>>> getDrugs() async {
  Database db = await _recoverBD();
  List<Map<String,dynamic>> drugs = await db.rawQuery("SELECT * FROM $alarmTable");
  Map<String,List<int>> drug = {};
  drugs.forEach((element) {
    if (!drug.containsKey(element['drug'])) {
      drug[element['drug']] = [element['id']];
    }
    else {
      drug[element['drug']]?.add(element['id']);
    }
  });
  return drug;
}

deleteDrug(List<int> ids) async {
  Database db = await _recoverBD();
  ids.forEach((element) async {
    await db.rawQuery("DELETE FROM $alarmTable WHERE id = $element");
  });
}
