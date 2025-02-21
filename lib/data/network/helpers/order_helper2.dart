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
      version: 2,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE IF NOT EXISTS orders (
            id TEXT PRIMARY KEY,
            status TEXT NOT NULL,
            datetime TEXT NOT NULL,
            user_id INTEGER NOT NULL
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
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute('ALTER TABLE orders ADD COLUMN user_id INTEGER');
        }
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
          'user_id': order.userId,
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

  static Future<List<OrderSingle>> getOrders(int userId) async {
    final db = await database;

    final List<Map<String, dynamic>> orderMaps = await db.query(
      'orders',
      where: 'user_id = ?',
      whereArgs: [userId],
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

  static Future<void> deleteOrder(String id) async {
    final db = await database;

    await db.transaction((txn) async {
      await txn.delete(
        'order_items',
        where: 'order_id = ?',
        whereArgs: [id],
      );

      await txn.delete(
        'orders',
        where: 'id = ?',
        whereArgs: [id],
      );
    });
  }

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
  final int userId;

  OrderSingle({
    required this.id,
    required this.status,
    required this.datetime,
    required this.items,
    required this.userId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'status': status,
      'datetime': datetime.toIso8601String(),
      'user_id': userId,
    };
  }

  static OrderSingle fromMap(Map<String, dynamic> map, List<OrderItem> items) {
    return OrderSingle(
      id: map['id'],
      status: map['status'],
      datetime: DateTime.parse(map['datetime']),
      items: items,
      userId: map['user_id'],
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
