//Put all Database methods here. Use
//the Dogs sqLite demo as your template.
import 'package:path/path.dart' as pathPackage;
import 'package:sqflite/sqflite.dart' as sqflitePackage;

import 'package:app4dmit2504/models/stock.dart';

class DatabaseHelper {
  sqflitePackage.Database db;

  Future<void> getOrCreateDatabaseHandle() async {
    var databasesPath = await sqflitePackage.getDatabasesPath();
    print('$databasesPath');
    var path = pathPackage.join(databasesPath, 'stock_database.db');
    print('$path');
    db = await sqflitePackage.openDatabase(
      path,
      onCreate: (sqflitePackage.Database db1, int version) async {
        await db1.execute(
          "CREATE TABLE stocks( id INTEGER PRIMARY KEY symbol TEXT, name TEXT, price REAL)",
        );
      },
      version: 1,
    );
    print('$db');
  }

  Future<void> insertStock(Stock stock) async {
    // Insert the Dog into the correct table. Also specify the
    // `conflictAlgorithm`. In this case, if the same dog is inserted
    // multiple times, it replaces the previous data.
    await db.insert(
      'stocks',
      stock.toMap(),
      conflictAlgorithm: sqflitePackage.ConflictAlgorithm.replace,
    );
  }

  Future<void> printAllStocksInDb() async {
    List<Stock> listOfStocks = await this.getAllStocksFromDb();
    if (listOfStocks.length == 0) {
      print('No Stocks in the list');
    } else {
      listOfStocks.forEach((stock) {
        print(
            'stock{symbol: ${stock.symbol}, name: ${stock.name}, price: ${stock.price}');
      });
    }
  }

  Future<List<Stock>> getAllStocksFromDb() async {
    final List<Map<String, dynamic>> stockMap = await db.query('stocks');
    return List.generate(stockMap.length, (i) {
      return Stock(
        stockMap[i]['id'],
        stockMap[i]['Symbol'],
        stockMap[i]['name'],
        stockMap[i]['price'],
      );
    });
  }

  Future<void> deleteDoStock(Stock stock) async {
    // Remove the Dog from the database.
    await db.delete(
      'stocks',
      // Use a `where` clause to delete a specific dog.
      where: "id = ?",
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [stock.id],
    );
  }
}
