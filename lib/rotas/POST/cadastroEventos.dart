import 'dart:convert';

import 'package:shelf/shelf.dart';

import '../../database.dart';

Future<Response> cadastroRodeio(Request request) async{

  final body = await request.readAsString();
  final data = jsonDecode(body);

  final organizador = data['organizador'];
  final dataRealizacao = data['dataRealizacao'];
  final tipoEvento = data['tipoEvento'];
  final dataInscricao = data['dataInscricao'];
  final cidade = data['cidade'];
  final endereco = data['endereco'];
  final premio = data['premio'];
  final contato = data['contato'];

  if (data['organizador'] == null || data['organizador'] == "") {
    return Response.badRequest(body: 'Preencha o organizador do evento.');
  }

  if (data['dataRealizacao'] == null || data['dataRealizacao'] == "") {
    return Response.badRequest(body: 'Preencha a data de realizacao do evento.');
  }

  if (data['tipoEvento'] == null || data['tipoEvento'] == "") {
    return Response.badRequest(body: 'Preencha o tipo de evento.');
  }

  if (data['dataInscricao'] == "") {
    return Response.badRequest(body: 'Preencha a data limite de inscricao, se não houver digite null.');
  }

  if (data['cidade'] == null || data['cidade'] == "") {
    return Response.badRequest(body: 'Preencha a cidade em que será realizado o evento.');
  }

  if (data['endereco'] == null || data['endereco'] == "") {
    return Response.badRequest(body: 'Preencha o endereco em que será realizado o evento.');
  }

  if (data['premio'] == "") {
    return Response.badRequest(body: 'Se o evento não possuir nenhuma premiação passe o valor null');
  }

  if (data['contato'] == null || data['contato'] == "") {
    return Response.badRequest(body: 'Insira alguma maneira de contato com o organizador do evento.');
  }

  final stmt = db.prepare(
      'INSERT INTO Eventos (organizador, dataRealizacao, tipoEvento, dataInscricao, cidade, endereco, premio, contato) '
          'VALUES (?, ?, ?, ?, ?, ?, ?, ?)'
  );

  stmt.execute([organizador, dataRealizacao, tipoEvento, dataInscricao, cidade, endereco, premio, contato]);
  stmt.dispose();

  return Response.ok(
    jsonEncode({'mensagem': 'Evento cadastrado com sucesso.'})
  );

}
