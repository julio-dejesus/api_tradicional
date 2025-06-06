import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

bool verificarJWT(String token) {
  try {
    final jwt = JWT.verify(token, SecretKey('minha_chave_secreta'));
    return true;
  } catch (e) {
    // Token inválido ou expirado
    return false;
  }
}
