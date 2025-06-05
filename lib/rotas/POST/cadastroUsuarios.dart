import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:sqlite3/common.dart';
import '../../database.dart';
import 'package:bcrypt/bcrypt.dart';


Future<Response> cadastroUsuarios(Request request) async{

  final body = await request.readAsString();
  final data = jsonDecode(body);

  final nome = data['nome'];
  final login = data['login'];
  final email = data['email'];
  final senha = data['senha'];



  //validações
  if (data['nome'] == null || data['nome'] == "") {
    return Response.badRequest(body: 'Preencha o nome do usuário.');
  }

  if (data['login'] == null || data['login'] == "") {
    return Response.badRequest(body: 'Preencha o login.');
  }

  if (data['senha'] == null || data['senha'] == "") {
    return Response.badRequest(body: 'Preencha a senha.');
  }

  // Gerar hash com salt embutido
  final hash = BCrypt.hashpw(senha, BCrypt.gensalt());
  //bool campoInvalido(String? campo) => campo == null || campo.trim().isEmpty;

  //controle
  print('Nome: $nome');
  print('Login: $login');
  print('E-mail: $email');
  print('Senha: $senha');
  print('Hash: $hash');

  //inserção no db
  try {
    final stmt = db.prepare(
        'INSERT INTO Usuarios (nome, login, email, senha) VALUES (?, ?, ?, ?)'
    );
    stmt.execute([nome, login, email, hash]);
    stmt.dispose();

    return Response.ok(
      jsonEncode({'mensagem': 'Usuário cadastrado com sucesso.'}),
      headers: {'Content-Type': 'application/json'},
    );

  } on SqliteException catch (e) {
    // Tratando violação de UNIQUE
    if (e.message.contains('UNIQUE') || e.message.contains('unique')) {
      return Response(
        409,
        body: jsonEncode({'erro': 'Login já está em uso. Escolha outro.'}),
        headers: {'Content-Type': 'application/json'},
      );
    }
    // Outro erro de SQLite
    return Response.internalServerError(
      body: jsonEncode({'erro': 'Erro no banco de dados.'}),
      headers: {'Content-Type': 'application/json'},
    );
  } catch (e) {
    // Erros genéricos
    return Response.internalServerError(
      body: jsonEncode({'erro': 'Erro inesperado.'}),
      headers: {'Content-Type': 'application/json'},
    );
  }

}
