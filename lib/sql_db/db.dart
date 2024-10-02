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
    String path = join(databasepath, 'qzq.db');
    Database mydb = await openDatabase(path,
        onCreate: _onCreate, version: 27, onUpgrade: _onUpgrade);
    return mydb;
  }

  _onUpgrade(Database db, int oldversion, int newversion) {
    print("onUpgrade =====================================");
  }

  _onCreate(Database db, int version) async {
    await db.execute('''
  CREATE TABLE "delivery_oder" (
    "oid" TEXT  NOT NULL PRIMARY KEY ,
      "waybill_id" TEXT NOT NULL,
      "cod_final" TEXT NOT NULL,
      "order_type" TEXT NOT NULL,             
      "cust_name" TEXT NOT NULL,
       "name" TEXT NOT NULL,
         "address" TEXT NOT NULL,
          "phone" TEXT NOT NULL,
           "status" TEXT NOT NULL,
            "cust_internal" TEXT ,
            "prev_waybill" TEXT ,
              "ex_bag_waybill" TEXT ,
                "type" TEXT,
                 "err_msg" TEXT
               

    
      
    


  )
 ''');

    await db.execute('''
  CREATE TABLE "scanData" (
    "pick_id" INTEGER  NOT NULL PRIMARY KEY ,
      "scan_list" TEXT NOT NULL
    
      
    


  )
 ''');

    await db.execute('''
  CREATE TABLE "reason_list" (
    "reason_id" INTEGER  NOT NULL PRIMARY KEY ,
      "type" TEXT NOT NULL,
      "reason" TEXT NOT NULL
    
      
    


  )
 ''');

    await db.execute('''
  CREATE TABLE "pending" (
    "oId" INTEGER  NOT NULL PRIMARY KEY ,
    "wayBillId" INTEGER  NOT NULL ,
    "statusType" INTEGER  NOT NULL ,
      "dropdownValue" TEXT ,
      "dropdownValue2" TEXT ,
        "cod" TEXT ,
          "rescheduleDate" TEXT,
           "err" TEXT,
            "date" TEXT
          
        
           
    
      
    


  )
 ''');

    await db.execute('''
  CREATE TABLE "pending_image" (
    "waybill" INTEGER  NOT NULL PRIMARY KEY ,
    "image" TEXT  NOT NULL 
      
           
    
      
    


  )
 ''');
    await db.execute('''
  CREATE TABLE "exchange_image" (
    "waybill" INTEGER  NOT NULL PRIMARY KEY ,
    "image" TEXT  NOT NULL 
      
           
    
      
    


  )
 ''');

    await db.execute('''
  CREATE TABLE "deliver_error" (
    "oId" INTEGER  NOT NULL PRIMARY KEY ,
    "msg" TEXT  NOT NULL 
      
           
    
      
    


  )
 ''');

    await db.execute('''
  CREATE TABLE "exchange_order" (
    "oId" INTEGER  NOT NULL PRIMARY KEY ,
    "wayBill" TEXT  NOT NULL, 
    "ex_bag_waybill" TEXT  NOT NULL, 
    "prev_waybill" TEXT  NOT NULL,
      "date" TEXT
      
           
    
      
    


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

  replaceData(String sql, Map<String, dynamic> row) async {
    Database? mydb = await db;

    int response = await mydb!.insert(
      sql,
      row,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return response;
  }

  Future<void> truncateTable(String table) async {
    Database? mydb = await db;
    await mydb!.delete(table); // This deletes all rows from the 'items' table
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
