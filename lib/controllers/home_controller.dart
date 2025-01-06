import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:my_thyngs_app/models/menu/MenuItem.dart';

class HomeController {
  Future<List<MenuItem>> loadJsonData() async {
    try {
      // Carrega o arquivo JSON
      String jsonString = await rootBundle.loadString('assets/mocks/home_menu.json');
      // Decodifica o JSON em uma lista dinâmica
      List<dynamic> jsonList = jsonDecode(jsonString);

      // Converte a lista de mapas JSON em uma lista de objetos MenuItem
      return jsonList.map((item) => MenuItem.fromJson(item)).toList();
    } catch (e) {
      throw Exception('Erro ao carregar JSON: $e');
    }
  }
}