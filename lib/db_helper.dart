import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('books.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE books (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT NOT NULL,
      author TEXT NOT NULL,
      imagePath TEXT NOT NULL
    )
  ''');

    // Insertar libros de ejemplo
    await _insertSampleBooks(db);
  }

  Future<void> _insertSampleBooks(Database db) async {
    final sampleBooks = [
      {'title': 'Cien Años de Soledad', 'author': 'Gabriel García Márquez', 'imagePath': ''},
      {'title': 'Don Quijote de la Mancha', 'author': 'Miguel de Cervantes', 'imagePath': ''},
      {'title': '1984', 'author': 'George Orwell', 'imagePath': ''},
      {'title': 'El Principito', 'author': 'Antoine de Saint-Exupéry', 'imagePath': ''},
      {'title': 'Orgullo y Prejuicio', 'author': 'Jane Austen', 'imagePath': ''},
      {'title': 'El Gran Gatsby', 'author': 'F. Scott Fitzgerald', 'imagePath': ''},
      {'title': 'Matar a un Ruiseñor', 'author': 'Harper Lee', 'imagePath': ''},
      {'title': 'Crimen y Castigo', 'author': 'Fyodor Dostoevsky', 'imagePath': ''},
      {'title': 'Ulises', 'author': 'James Joyce', 'imagePath': ''},
      {'title': 'La Odisea', 'author': 'Homero', 'imagePath': ''}
    ];

    for (var book in sampleBooks) {
      await db.insert('books', book);
    }
  }


  Future<int> insertBook(Map<String, dynamic> book) async {
    final db = await instance.database;
    return await db.insert('books', book);
  }

  Future<List<Map<String, dynamic>>> fetchBooks() async {
    final db = await instance.database;
    return await db.query('books');
  }
}
