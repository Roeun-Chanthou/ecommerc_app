import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class OrderDatabaseHelper {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database!;
  }

  static Future<Database> initDatabase() async {
    String path = join(await getDatabasesPath(), 'orders.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE IF NOT EXISTS orders (
            id TEXT PRIMARY KEY,
            status TEXT NOT NULL,
            datetime TEXT NOT NULL
          )
        ''');

        await db.execute('''
          CREATE TABLE IF NOT EXISTS order_items (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            order_id TEXT NOT NULL,
            name TEXT NOT NULL,
            price REAL NOT NULL,
            image TEXT NOT NULL,
            quantity INTEGER NOT NULL,
            FOREIGN KEY (order_id) REFERENCES orders (id) ON DELETE CASCADE
          )
        ''');
      },
    );
  }

  static Future<void> saveOrder(OrderSingle order) async {
    final db = await database;

    await db.transaction((txn) async {
      print('Saving order with ID: ${order.id}');

      await txn.insert(
        'orders',
        {
          'id': order.id,
          'status': order.status,
          'datetime': order.datetime.toIso8601String(),
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      for (var item in order.items) {
        await txn.insert(
          'order_items',
          {
            'order_id': item.orderId,
            'name': item.name,
            'price': item.price,
            'image': item.image,
            'quantity': item.quantity,
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    });
  }

  static Future<List<OrderSingle>> getOrders() async {
    final db = await database;

    final List<Map<String, dynamic>> orderMaps = await db.query(
      'orders',
      orderBy: 'datetime DESC',
    );

    return Future.wait(orderMaps.map((orderMap) async {
      final List<Map<String, dynamic>> itemMaps = await db.query(
        'order_items',
        where: 'order_id = ?',
        whereArgs: [orderMap['id']],
      );

      final items =
          itemMaps.map((itemMap) => OrderItem.fromMap(itemMap)).toList();
      return OrderSingle.fromMap(orderMap, items);
    }));
  }

  static Future<bool> hasOrders() async {
    final db = await database;
    final count =
        Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM orders'));
    return (count ?? 0) > 0;
  }

  // Add method to delete an order
  static Future<void> deleteOrder(String id) async {
    final db = await database;

    await db.transaction((txn) async {
      // Delete order items first
      await txn.delete(
        'order_items',
        where: 'order_id = ?',
        whereArgs: [id],
      );

      // Delete the order
      await txn.delete(
        'orders',
        where: 'id = ?',
        whereArgs: [id],
      );
    });
  }

  // Add method to update order status
  static Future<void> updateOrderStatus(
      String orderId, String newStatus) async {
    final db = await database;

    await db.update(
      'orders',
      {'status': newStatus},
      where: 'id = ?',
      whereArgs: [orderId],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}

class OrderSingle {
  final String id;
  final String status;
  final DateTime datetime;
  final List<OrderItem> items;

  OrderSingle({
    required this.id,
    required this.status,
    required this.datetime,
    required this.items,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'status': status,
      'datetime': datetime.toIso8601String(),
    };
  }

  static OrderSingle fromMap(Map<String, dynamic> map, List<OrderItem> items) {
    return OrderSingle(
      id: map['id'],
      status: map['status'],
      datetime: DateTime.parse(map['datetime']),
      items: items,
    );
  }
}

class OrderItem {
  final String orderId;
  final String name;
  final double price;
  final String image;
  final int quantity;

  OrderItem({
    required this.orderId,
    required this.name,
    required this.price,
    required this.image,
    required this.quantity,
  });

  Map<String, dynamic> toMap() {
    return {
      'order_id': orderId,
      'name': name.trim(),
      'price': price,
      'image': image.trim(),
      'quantity': quantity,
    };
  }

  static OrderItem fromMap(Map<String, dynamic> map) {
    return OrderItem(
      orderId: map['order_id'] ?? '',
      name: map['name'] ?? '',
      price: (map['price'] as num?)?.toDouble() ?? 0.0,
      image: map['image'] ?? '',
      quantity: map['quantity'] ?? 0,
    );
  }
}
