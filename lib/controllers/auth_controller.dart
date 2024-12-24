import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class AuthController {
  final String loginUrl = dotenv.env['LOGIN_URL']!;

  Future<bool> loginUser({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      // Corpo da requisição
      print("URL loginUrl = $loginUrl");

      final Map<String, String> requestBody = {
        'userName': email,
        'password': password,
      };

      // Fazendo a requisição POST
      final response = await http.post(
        Uri.parse(loginUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      // Lidando com a resposta
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login bem-sucedido!')),
        );
        // Aqui você pode navegar para outra tela ou salvar o token
        print('Token recebido: ${data['token']}');
        return true;
      } else {
        final errorData = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro: ${errorData['message']}')),
        );
        return false;
      }
    } catch (e) {
      // Lidando com erros de conexão
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao conectar ao servidor: $e')),
      );
      return false;
    }
  }
}
