import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/menu/MenuItem.dart';

class UserDetailsController {
  Future<List<MenuItem>> loadJsonData() async {
    try {
      // Carrega o arquivo JSON
      String jsonString = await rootBundle.loadString('assets/mocks/user_details_menu.json');
      // Decodifica o JSON em uma lista
      List<dynamic> jsonList = jsonDecode(jsonString);

      // Converte a lista de mapas JSON em uma lista de objetos MenuItem
      return jsonList.map((item) => MenuItem.fromJson(item)).toList();
    } catch (e) {
      throw Exception('Erro ao carregar JSON: $e');
    }
  }
}