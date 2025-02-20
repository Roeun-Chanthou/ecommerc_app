import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Future<Database> _initDatabase() async {
  //   final dbPath = await getDatabasesPath();
  //   final path = join(dbPath, 'orders_database.db');

  //   return openDatabase(
  //     path,
  //     version: 3,
  //     onCreate: (db, version) async {
  //       await db.execute(
  //           'CREATE TABLE orders (id TEXT PRIMARY KEY, status TEXT, datetime TEXT)');

  //       await db.execute(
  //           'CREATE TABLE order_items (id INTEGER PRIMARY KEY AUTOINCREMENT, order_id TEXT, name TEXT, price REAL, image TEXT, quantity INTEGER, FOREIGN KEY(order_id) REFERENCES orders(id))');
  //     },
  //     onUpgrade: (db, oldVersion, newVersion) async {
  //       if (oldVersion < 3) {
  //         await db.execute(
  //             'CREATE TABLE order_items (id INTEGER PRIMARY KEY AUTOINCREMENT, order_id TEXT, name TEXT, price REAL, image TEXT, quantity INTEGER, FOREIGN KEY(order_id) REFERENCES orders(id))');
  //       }
  //     },
  //   );
  // }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'orders_database.db');

    return openDatabase(
      path,
      version: 4, // Increment the version number
      onCreate: (db, version) async {
        await db.execute(
            'CREATE TABLE orders (id TEXT PRIMARY KEY, status TEXT, datetime TEXT, user_id INTEGER)'); // Add user_id

        await db.execute(
            'CREATE TABLE order_items (id INTEGER PRIMARY KEY AUTOINCREMENT, order_id TEXT, name TEXT, price REAL, image TEXT, quantity INTEGER, FOREIGN KEY(order_id) REFERENCES orders(id))');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 4) {
          await db.execute(
              'ALTER TABLE orders ADD COLUMN user_id INTEGER'); // Add this line
        }
      },
    );
  }

  Future<void> saveOrder(Order order) async {
    final db = await database;

    await db.insert(
      'orders',
      order.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    for (var item in order.items) {
      await db.insert(
        'order_items',
        item.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  // Future<void> saveOrder(Order order) async {
  //   final db = await database;

  //   await db.insert(
  //     'orders',
  //     order.toMap(),
  //     conflictAlgorithm: ConflictAlgorithm.replace,
  //   );

  //   for (var item in order.items) {
  //     await db.insert(
  //       'order_items',
  //       item.toMap(),
  //       conflictAlgorithm: ConflictAlgorithm.replace,
  //     );
  //   }
  // }

  Future<List<Order>> getOrders(int userId) async {
    final db = await database;
    final List<Map<String, dynamic>> orderMaps = await db.query(
      'orders',
      where: 'user_id = ?',
      whereArgs: [userId],
    );

    List<Order> orders = [];

    for (var orderMap in orderMaps) {
      final List<Map<String, dynamic>> itemMaps = await db.query(
        'order_items',
        where: 'order_id = ?',
        whereArgs: [orderMap['id']],
      );

      List<OrderItem> items =
          itemMaps.map((map) => OrderItem.fromMap(map)).toList();

      orders.add(Order.fromMap(orderMap, items));
    }

    return orders;
  }

  // Future<List<Order>> getOrders() async {
  //   final db = await database;
  //   final List<Map<String, dynamic>> orderMaps = await db.query('orders');

  //   List<Order> orders = [];

  //   for (var orderMap in orderMaps) {
  //     final List<Map<String, dynamic>> itemMaps = await db.query(
  //       'order_items',
  //       where: 'order_id = ?',
  //       whereArgs: [orderMap['id']],
  //     );

  //     List<OrderItem> items =
  //         itemMaps.map((map) => OrderItem.fromMap(map)).toList();

  //     orders.add(Order.fromMap(orderMap, items));
  //   }

  //   return orders;
  // }

  Future<void> deleteOrder(String id) async {
    final db = await database;

    await db.delete('order_items', where: 'order_id = ?', whereArgs: [id]);
    await db.delete('orders', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> updateOrderStatus(String orderId, String newStatus) async {
    final db = await database;

    await db.update(
      'orders',
      {'status': newStatus},
      where: 'id = ?',
      whereArgs: [orderId],
    );
  }
}

// class Order {
//   final String id;
//   final String status;
//   final DateTime datetime;
//   final List<OrderItem> items;

//   Order({
//     required this.id,
//     required this.status,
//     required this.datetime,
//     required this.items,
//   });

//   Map<String, dynamic> toMap() {
//     return {
//       'id': id,
//       'status': status,
//       'datetime': datetime.toIso8601String(),
//     };
//   }

//   static Order fromMap(Map<String, dynamic> map, List<OrderItem> items) {
//     return Order(
//       id: map['id'],
//       status: map['status'],
//       datetime: DateTime.parse(map['datetime']),
//       items: items,
//     );
//   }
// }

class Order {
  final String id;
  final String status;
  final DateTime datetime;
  final List<OrderItem> items;
  final int userId; // Add this line

  Order({
    required this.id,
    required this.status,
    required this.datetime,
    required this.items,
    required this.userId, // Add this line
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'status': status,
      'datetime': datetime.toIso8601String(),
      'user_id': userId, // Add this line
    };
  }

  static Order fromMap(Map<String, dynamic> map, List<OrderItem> items) {
    return Order(
      id: map['id'],
      status: map['status'],
      datetime: DateTime.parse(map['datetime']),
      items: items,
      userId: map['user_id'], // Add this line
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
      'name': name,
      'price': price,
      'image': image,
      'quantity': quantity,
    };
  }

  static OrderItem fromMap(Map<String, dynamic> map) {
    return OrderItem(
      orderId: map['order_id'],
      name: map['name'],
      price: map['price'],
      image: map['image'],
      quantity: map['quantity'],
    );
  }
}
