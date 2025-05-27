import 'dart:io';
import 'package:sqlite3/sqlite3.dart';
import 'package:path/path.dart' as p;


late Database db;

void iniciaBanco() {
  final dbPath = p.join(Directory.current.path, 'tradicional.db');
  db = sqlite3.open(dbPath);

  db.execute('''
  
    DROP TABLE Entidades;
  
    CREATE TABLE IF NOT EXISTS Entidades (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      sigla TEXT NOT NULL,
      nome TEXT NOT NULL,
      fundado DATE NOT NULL,
      rt INT NOT NULL,
      cidade TEXT NOT NULL,
      endereco TEXT,
      verificado BOOLEAN NOT NULL DEFAULT 0
    );
  ''');





}

