import 'dart:io';
import 'package:tradicional/rotas/GET/entidadesVerificar.dart';
import 'package:tradicional/rotas/GET/eventosVerificar.dart';
import 'package:tradicional/rotas/GET/listarEventos.dart';
import 'package:tradicional/rotas/GET/listarUsuarios.dart';
import 'package:tradicional/rotas/GET/procuraEntidades.dart';
import 'package:tradicional/rotas/GET/procuraEventos.dart';
import 'package:tradicional/rotas/POST/cadastroEntidades.dart';
import 'package:tradicional/rotas/GET/listarEntidades.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:tradicional/database.dart';
import 'package:tradicional/rotas/POST/cadastroEventos.dart';
import 'package:tradicional/rotas/POST/cadastroUsuarios.dart';
import 'package:tradicional/rotas/POST/logar.dart';
import 'package:tradicional/rotas/DELETE/deletarEntidade.dart';
import 'package:tradicional/rotas/DELETE/deletarEvento.dart';
import 'package:tradicional/rotas/DELETE/deletarUsuario.dart';

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

  if (method == 'POST') {

    if(path == 'cadastroEntidades'){
      return cadastroEntidades(request);
    }

    if(path == 'cadastroEventos'){
      return cadastroEventos(request);
    }

    if(path == 'cadastroUsuarios'){
      return cadastroUsuarios(request);
    }

    if(path == 'logar'){
      return logar(request);
    }

  }

  if (method == 'GET') {

    if(path == 'entidadesVerificar') {
      return await entidadesVerificar(request);
    }

    if(path == 'eventosVerificar'){
      return eventosVerificar(request);
    }

    if(path == 'listarEntidades'){
      return listarEntidades(request);
    }

    if(path == 'listarEventos'){
      return listarEventos(request);
    }

    if(path == 'procuraEntidades'){
      return procuraEntidade(request);
    }

    if(path == 'procuraEventos'){
      return procuraEventos(request);
    }

    if(path == 'listarUsuarios'){
      return listarUsuarios(request);
    }

  }

  if (method == 'DELETE') {

    if (path.startsWith('entidade/')) {
      final id = path.replaceFirst('entidade/', '');
      return deletarEntidade(request, id);
    }

    if (path.startsWith('evento/')) {
      final id = path.replaceFirst('evento/', '');
      return deletarEvento(request, id);
    }

    if (path.startsWith('usuario/')) {
      final id = path.replaceFirst('usuario/', '');
      return deletarUsuario(request, id);
    }

  }


  return Response.notFound('Rota não encontrada');
}