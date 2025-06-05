import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:sqlite3/common.dart';
import '../../database.dart';

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


  //validações
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

  //controle
  print('sigla: $sigla');
  print('nome: $nome');
  print('fundado: $fundado');
  print('rt: $rt');
  print('cidade: $cidade');
  print('endereco: $endereco');

  //inserção no db
  try {
    final stmt = db.prepare(
        'INSERT INTO Entidades (sigla, nome, fundado, rt, cidade, endereco) VALUES (?, ?, ?, ?, ?, ?);'
    );
    stmt.execute([sigla, nome, fundado, rt, cidade, endereco]);
    stmt.dispose();

    return Response.ok(
      jsonEncode({'mensagem': 'Entidade cadastrada com sucesso.'}),
      headers: {'Content-Type': 'application/json'},
    );

  } on SqliteException catch (e) {
    // Tratando violação de UNIQUE
    if (e.message.contains('UNIQUE') || e.message.contains('unique')) {
      return Response(
        409,
        body: jsonEncode({
          'erro': 'Já existe uma entidade com essa sigla, nome e RT.'
        }),
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