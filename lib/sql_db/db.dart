import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SqlDb {
  static Database? _db;

  Future<Database?> get db async {
    if (_db == null) {
      _db = await intialDb();
      return _db;
    } else {
      return _db;
    }
  }

  intialDb() async {
    String databasepath = await getDatabasesPath();
    String path = join(databasepath, 'dd.db');
    Database mydb = await openDatabase(path,
        onCreate: _onCreate, version: 6, onUpgrade: _onUpgrade);
    return mydb;
  }

  _onUpgrade(Database db, int oldversion, int newversion) {
    print("onUpgrade =====================================");
  }

  _onCreate(Database db, int version) async {
    await db.execute('''
  CREATE TABLE "delivery_oder" (
    "oid" INTEGER  NOT NULL PRIMARY KEY ,
      "waybill_id" TEXT NOT NULL,
      "cod_final" TEXT NOT NULL,
      "order_type" TEXT NOT NULL,
      "cust_name" TEXT NOT NULL,
       "name" TEXT NOT NULL,
         "address" TEXT NOT NULL,
          "phone" TEXT NOT NULL,
           "status" TEXT NOT NULL,
            "cust_internal" TEXT NOT NULL,
            "prev_waybill" TEXT NOT NULL,
              "ex_bag_waybill" TEXT NOT NULL

    
      
    


  )
 ''');

    await db.execute('''
  CREATE TABLE "scanData" (
    "pick_id" INTEGER  NOT NULL PRIMARY KEY ,
      "scan_list" TEXT NOT NULL
    
      
    


  )
 ''');

    print(" onCreate =====================================");
  }

  readData(String sql) async {
    Database? mydb = await db;
    List<Map> response = await mydb!.rawQuery(sql);
    return response;
  }

  insertData(String sql) async {
    Database? mydb = await db;

    int response = await mydb!.rawInsert(sql);
    return response;
  }

  updateData(String sql) async {
    Database? mydb = await db;
    int response = await mydb!.rawUpdate(sql);
    return response;
  }

  deleteData(String sql) async {
    Database? mydb = await db;
    int response = await mydb!.rawDelete(sql);
    return response;
  }

  rawQuery(String sql, List<String> list) {}

  batch() {}

// SELECT
// DELETE
// UPDATE
// INSERT
}
