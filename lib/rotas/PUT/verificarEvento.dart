import 'dart:convert';
import 'package:shelf/shelf.dart';
import '../../database.dart';
import '../../verificarJWT.dart';

Future<Response> verificarEvento(Request request, String id) async {
  // Verifica se o token está presente e é válido
  final token = request.headers['Authorization']?.replaceFirst('Bearer ', '');

  if (token == null || !verificarJWT(token)) {
    return Response.forbidden(jsonEncode({'erro': 'Token inválido ou ausente'}));
  }

  // Lê e valida o corpo da requisição
  final body = await request.readAsString();
  final data = jsonDecode(body);

  if (data['verificado'] != 'ok') {
    return Response.badRequest(body: jsonEncode({'erro': 'Corpo inválido. Esperado: {"verificado":"ok"}'}));
  }

  // Realiza o UPDATE
  final stmt = db.prepare('UPDATE Eventos SET verificado = 1 WHERE id = ?');
  stmt.execute([id]);
  final changes = db.getUpdatedRows();
  stmt.dispose();

  if (changes == 0) {
    return Response.notFound(jsonEncode({'erro': 'Evento não encontrado'}));
  }

  return Response.ok(jsonEncode({'mensagem': 'Evento verificado com sucesso'}));
}
