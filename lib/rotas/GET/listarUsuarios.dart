import 'dart:convert';
import 'package:shelf/shelf.dart';
import '../../database.dart';

Future<Response> listarUsuarios(Request request) async{

  final result = db.select('SELECT id, nome, login, email, senha, admin FROM Usuarios');
  final usuarios = result.map((row) =>{
    'id': row['id'],
    'nome': row['organizador'],
    'login': row['dataRealizacao'],
    'email': row['tipoEvento'],
    'senha': row['dataInscricao'],
    'admin': row['admin']
  }).toList();

  return Response.ok(
    jsonEncode(usuarios),
    headers: {'Content-Type': 'application/json'},
  );

}