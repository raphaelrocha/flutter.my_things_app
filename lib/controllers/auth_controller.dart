import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/User.dart';

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

        // Salva os dados no armazenamento local
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', data['token']);
        await prefs.setString('refreshToken', data['refreshToken']);
        await prefs.setString('user', jsonEncode(data['user'])); // Serializa o objeto user

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login bem-sucedido!')),
        );

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
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao conectar ao servidor: $e')),
      );
      return false;
    }
  }

  // Método para recuperar o token salvo
  Future<String?> getAuthToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token'); // Ajustado para pegar a chave 'token'
  }

  // Método para recuperar o refresh token salvo
  Future<String?> getRefreshToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('refreshToken'); // Ajustado para pegar a chave 'refreshToken'
  }

  // Método para recuperar o objeto user salvo
  Future<User?> getUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userJson = prefs.getString('user');
    if (userJson != null) {
      final Map<String, dynamic> userMap = jsonDecode(userJson);
      return User.fromJson(userMap); // Converte o JSON para uma instância de User
    }
    return null; // Retorna null se não houver usuário salvo
  }

  // Método para limpar os dados (logout)
  Future<void> logoutUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('refreshToken');
    await prefs.remove('user');
  }
}