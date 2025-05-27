import 'dart:io';
import 'package:tradicional/rotas/POST/cadastroEntidades.dart';
import 'package:tradicional/rotas/GET/listarEntidades.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:tradicional/database.dart';

void main() async {
  iniciaBanco();//inicia o sqlite

  // Define o handler da requisição
  final handler = Pipeline().
  addMiddleware(logRequests()).
  //addMiddleware(verificarJWTMiddleware()).
  addHandler(_router);

  //final server = await io.serve(handler, InternetAddress.anyIPv4, 8080);// Inicia o servidor na porta 8080
  final server = await io.serve(handler, InternetAddress.anyIPv4, int.parse(Platform.environment['PORT'] ?? '8080'));//altera para que o endpoint possa definir a porta

  print('Servidor rodando: http://${server.address.address}:${server.port}');
}

Future<Response> _router(Request request) async {
  final path = request.url.path;
  final method = request.method;

  if (path == 'novaEntidade' && method == 'POST') {
    return cadastroEntidades(request);
  }

  if (path == 'entidades' && method == 'GET') {
    return await listarEntidades(request);
  }

  return Response.notFound('Rota não encontrada');
}