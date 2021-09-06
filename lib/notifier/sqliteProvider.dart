import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class SQLiteDbProvider {
  SQLiteDbProvider._();
  static final SQLiteDbProvider db = SQLiteDbProvider._();
  static  Database? _database;

  Future<Database?> get database async {
    if (_database != null)
      return _database;
    _database = await initDB();
    return _database;
  }
  initDB() async {
    Directory documentsDirectory = await
    getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "sqflite_ex.db");
    return await openDatabase(
        path, version: 1,
        onOpen: (db) {},
        onCreate: (Database db, int version) async {
          await db.execute(
              "CREATE TABLE userDetails_tbl ("
                  "id,"
                  "email TEXT,"
                  "password TEXT,"
                  "uid TEXT"
                  ")"
          );

        }
    );
  }
  getUID() async{
    final db = await database;
   List<dynamic> json=await db!.rawQuery('SELECT uid FROM userDetails_tbl WHERE id=?',[1]);
   // print(json[0]['uid']);
    return json[0]['uid'];
  }
/*  Future<List<Product>> getAllProducts() async {
    final db = await database;
    List<Map> results = await db.query(
        "Product", columns: Product.columns, orderBy: "id ASC"
    );
    List<Product> products = new List();
    results.forEach((result) {
      Product product = Product.fromMap(result);
      products.add(product);
    });
    return products;
  }

  Future<Product> getProductById(int id) async {
    final db = await database;
    var result = await db.query("Product", where: "id = ", whereArgs: [id]);
    return result.isNotEmpty ? Product.fromMap(result.first) : Null;
  }

  insert(Product product) async {
    final db = await database;
    var maxIdResult = await db.rawQuery("SELECT MAX(id)+1 as last_inserted_id FROM Product");
    var id = maxIdResult.first["last_inserted_id"];
    var result = await db.rawInsert(
        "INSERT Into Product (id, name, description, price, image)"
            " VALUES (?, ?, ?, ?, ?)",
        [id, product.name, product.description, product.price, product.image]
    );
    return result;
  }

  update(Product product) async {
    final db = await database;
    var result = await db.update(
        "Product", product.toMap(), where: "id = ?", whereArgs: [product.id]
    );
    return result;
  }*/
  delete(int id) async {
    final db = await database;
    db!.delete("Product", where: "id = ?", whereArgs: [id]);
  }
}