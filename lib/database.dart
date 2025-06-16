import 'dart:io';
import 'package:sqlite3/sqlite3.dart';
import 'package:path/path.dart' as p;


late Database db;

void iniciaBanco() {
  final dbPath = p.join(Directory.current.path, 'api_tradicional.db');
  db = sqlite3.open(dbPath);

  db.execute('''
  
CREATE TABLE IF NOT EXISTS Entidades (
id INTEGER PRIMARY KEY AUTOINCREMENT,
sigla TEXT NOT NULL,
nome TEXT NOT NULL,
fundado DATE NOT NULL,
rt INTEGER NOT NULL,
cidade TEXT NOT NULL,
endereco TEXT,
verificado BOOLEAN NOT NULL DEFAULT 0,
UNIQUE (sigla, nome, rt)
);

CREATE TABLE IF NOT EXISTS Eventos (
id INTEGER PRIMARY KEY AUTOINCREMENT,
organizador TEXT NOT NULL,
dataRealizacao DATE NOT NULL,
tipoEvento TEXT NOT NULL,
dataInscricao DATE,
cidade TEXT NOT NULL,
endereco TEXT NOT NULL,
premio TEXT,
contato TEXT,
verificado BOOLEAN NOT NULL DEFAULT 0,
UNIQUE (tipoEvento, dataRealizacao, organizador, endereco)
);

CREATE TABLE IF NOT EXISTS Usuarios(
id INTEGER PRIMARY KEY AUTOINCREMENT,
nome TEXT NOT NULL,
login TEXT NOT NULL UNIQUE,
email TEXT,
senha TEXT NOT NULL,
admin BOOLEAN NOT NULL DEFAULT 0
);
    
IF NOT EXISTS(SELECT TOP 1 1 FROM Usuarios WHERE login = 'admin')
 BEGIN
  INSERT Usuarios VALUES('Administrador do Sistema', 'admin', null, 'senha', 0)
 END
    
  ''');

}

