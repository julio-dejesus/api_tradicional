import 'dart:convert';
import 'package:shelf/shelf.dart';
import '../database.dart';

Future<Response> cadastroEntidades(Request request) async {
  final body = await request.readAsString();
  final data = jsonDecode(body);
  print(data);

  final sigla = data['sigla'];
  final nome = data['nome'];
  final fundado = data['fundado'];
  final rt = data['rt'];
  final cidade = data['cidade'];
  final endereco = data['endereco'];

  if (data['sigla'] == null || data['sigla'] == "") {
    return Response.badRequest(body: 'Preencha a sigla que a entidade pertence.');
  }

  if (data['nome'] == null || data['nome'] == "") {
    return Response.badRequest(body: 'Preencha o nome da entidade.');
  }

  if (data['fundado'] == null || data['fundado'] == "") {
    return Response.badRequest(body: 'Preencha a data de fundação da entidade.');
  }

  if (data['rt'] == null || data['rt'] == "") {
    return Response.badRequest(body: 'Preencha a região tradicionalista da entidade.');
  }

  if (data['cidade'] == null || data['cidade'] == "") {
    return Response.badRequest(body: 'Preencha a cidade da entidade.');
  }

  final stmt = db.prepare(
      'INSERT INTO Entidades (sigla, nome, fundado, rt, cidade, endereco) VALUES (?, ?, ?, ?, ?, ?);'
  );


  stmt.execute([sigla, nome, fundado, rt, cidade, endereco]);
  print('sigla: $sigla');
  print('nome: $nome');
  print('fundado: $fundado');
  print('rt: $rt');
  print('cidade: $cidade');
  print('endereco: $endereco');

  stmt.dispose();

  return Response.ok(
    jsonEncode({'mensagem': 'Usuário cadastrado com sucesso'}),
    headers: {'Content-Type': 'application/json'},
  );
}