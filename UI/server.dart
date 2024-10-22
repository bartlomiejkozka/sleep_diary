import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;

void main() async {
  final router = Router();

  // Definiujemy endpoint
  router.get('/hello', (Request request) {
    return Response.ok('{"message": "Hello, World!"}',
        headers: {'Content-Type': 'application/json'});
  });

  // Tworzymy serwer
  final handler = const Pipeline()
      .addMiddleware(logRequests()) // Middleware do logowania żądań
      .addHandler(router);

  final server = await shelf_io.serve(handler, 'localhost', 10200);
  print('Serwer uruchomiony na porcie: ${server.port}');
}
