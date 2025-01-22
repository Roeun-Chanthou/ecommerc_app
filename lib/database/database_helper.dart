import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('orders.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    const orderTable = '''
    CREATE TABLE orders (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      location TEXT,
      contactNumber TEXT,
      couponCode TEXT,
      subtotal REAL,
      discount REAL,
      total REAL,
      date TEXT
    )
    ''';

    const orderItemsTable = '''
    CREATE TABLE order_items (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      orderId INTEGER,
      productName TEXT,
      productPrice REAL,
      productImage TEXT,
      quantity INTEGER,
      color TEXT,
      FOREIGN KEY (orderId) REFERENCES orders (id)
    )
    ''';

    await db.execute(orderTable);
    await db.execute(orderItemsTable);
  }

  Future<int> insertOrder(Map<String, dynamic> orderData) async {
    final db = await instance.database;
    return await db.insert('orders', orderData);
  }

  Future<int> insertOrderItem(Map<String, dynamic> orderItemData) async {
    final db = await instance.database;
    return await db.insert('order_items', orderItemData);
  }

  Future<List<Map<String, dynamic>>> fetchOrders() async {
    final db = await instance.database;
    return await db.query('orders');
  }

  Future<List<Map<String, dynamic>>> fetchOrderItems(int orderId) async {
    final db = await instance.database;
    return await db.query(
      'order_items',
      where: 'orderId = ?',
      whereArgs: [orderId],
    );
  }
}
