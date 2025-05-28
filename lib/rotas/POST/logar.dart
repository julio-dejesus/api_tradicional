import 'dart:convert';
import 'package:bcrypt/bcrypt.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:shelf/shelf.dart';
import '../../database.dart';


Future<Response> logar(Request request) async {
  final body = await request.readAsString();
  final data = jsonDecode(body);
  final hash = BCrypt.hashpw(data['senha'], BCrypt.gensalt());

  final stmt = db.prepare(
      'SELECT * FROM Usuarios WHERE login = ? AND senha = ?;'
  );

  final result = stmt.select([data['nome'], hash]);
  stmt.dispose();

  if (result.isEmpty) {
    return Response(401, body: 'Usuário ou senha incorretos');
  }

  final usuario = result.first;

  // 🔐 Gera token JWT
  final jwt = JWT(
    { 'id': usuario['id'],
      'nome': usuario['nome'],
      'email': usuario['email'],
      'admin': usuario['admin'],
      'exp': DateTime.now().add(Duration(minutes: 30)).millisecondsSinceEpoch ~/ 1000},// 🔥 Aqui está a expiração
    issuer: 'minha_api',
  );

  final token = jwt.sign(SecretKey('minha_chave_secreta'));

  return Response.ok(
    jsonEncode({'token': token}),
    headers: {'Content-Type': 'application/json'},
  );
}
