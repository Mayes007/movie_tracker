import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/book.dart';

class LibraryDatabase {

  static final LibraryDatabase instance = LibraryDatabase._init();

  static Database? _database;

  LibraryDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('library.db');
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

  Future _createDB(Database db, int version) async {

    await db.execute('''
      CREATE TABLE books(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        author TEXT,
        borrowed INTEGER
      )
    ''');
  }

  Future<int> createBook(Book book) async {
    final db = await instance.database;
    return await db.insert('books', book.toMap());
  }

  Future<List<Book>> readAllBooks() async {

    final db = await instance.database;

    final result = await db.query('books');

    return result.map((json) => Book.fromMap(json)).toList();
  }

  Future<int> deleteBook(int id) async {

    final db = await instance.database;

    return await db.delete(
      'books',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}