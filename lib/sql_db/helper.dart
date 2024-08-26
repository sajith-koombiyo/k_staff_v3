import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final _databaseName = "my_database.db";
  static final _databaseVersion = 1;

  static final table = 'orders';

  static final columnId = 'id';
  static final columnOid = 'oid';
  static final columnWaybillId = 'waybill_id';
  static final columnCodFinal = 'cod_final';
  static final columnOrderType = 'order_type';
  static final columnCustName = 'cust_name';
  static final columnName = 'name';
  static final columnAddress = 'address';
  static final columnPhone = 'phone';
  static final columnStatus = 'status';
  static final columnCustInternal = 'cust_internal';
  static final columnPrevWaybill = 'prev_waybill';
  static final columnExBagWaybill = 'ex_bag_waybill';

  // Singleton class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $table (
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnOid INTEGER UNIQUE NOT NULL,
        $columnWaybillId INTEGER NOT NULL,
        $columnCodFinal REAL NOT NULL,
        $columnOrderType INTEGER NOT NULL,
        $columnCustName TEXT NOT NULL,
        $columnName TEXT NOT NULL,
        $columnAddress TEXT NOT NULL,
        $columnPhone TEXT NOT NULL,
        $columnStatus TEXT NOT NULL,
        $columnCustInternal TEXT,
        $columnPrevWaybill TEXT,
        $columnExBagWaybill TEXT
      )
    ''');
  }

  Future<void> insertOrUpdate(Map<String, dynamic> row) async {
    Database db = await instance.database;
    await db.insert(
      table,
      row,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database db = await instance.database;
    return await db.query(table);
  }
}
