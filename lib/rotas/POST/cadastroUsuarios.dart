import 'dart:convert';
import 'package:shelf/shelf.dart';
import '../../database.dart';
import 'package:bcrypt/bcrypt.dart';


Future<Response> cadastroUsuarios(Request request) async{

  final body = await request.readAsString();
  final data = jsonDecode(body);

  final nome = data['nome'];
  final login = data['login'];
  final email = data['email'];
  final senha = data['senha'];

  if (data['nome'] == null || data['nome'] == "") {
    return Response.badRequest(body: 'Preencha o nome do usuário.');
  }

  if (data['login'] == null || data['login'] == "") {
    return Response.badRequest(body: 'Preencha o login.');
  }

  if (data['email'] == "") {
    return Response.badRequest(body: 'Caso não deseje informar o email digite NULL.');
  }

  if (data['senha'] == null || data['senha'] == "") {
    return Response.badRequest(body: 'Preencha a senha.');
  }

  // Gerar hash com salt embutido
  final hash = BCrypt.hashpw(senha, BCrypt.gensalt());



  final stmt = db.prepare(
      'INSERT INTO Usuarios (nome, login, email, senha) VALUES (?, ?, ?, ?)'
  );

  stmt.execute([nome, login, email, hash]);
  stmt.dispose();

  return Response.ok(
      jsonEncode({'mensagem': 'Evento cadastrado com sucesso.'})
  );

}
