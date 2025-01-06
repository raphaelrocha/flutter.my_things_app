import 'package:flutter/material.dart';
import 'package:my_thyngs_app/controllers/auth_controller.dart';
import 'package:my_thyngs_app/models/menu/MenuItem.dart';
import 'package:my_thyngs_app/screens/login_screen.dart';
import '../controllers/user_details_controller.dart';

class UserDetailsScreen extends StatefulWidget {
  const UserDetailsScreen({Key? key}) : super(key: key);

  @override
  State<UserDetailsScreen> createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  List<MenuItem> buttonData = [];
  final UserDetailsController controller = UserDetailsController();

  @override
  void initState() {
    super.initState();
    loadMenu(); // Carrega o menu ao inicializar
  }// Instancia a controller

  Future<void> loadMenu() async {
    try {
      List<MenuItem> data = await controller.loadJsonData();
      setState(() {
        buttonData = data;
      });
    } catch (e) {
      print('Erro ao carregar o menu: $e');
    }
  }

  handleClick(String action) async {
    switch(action){
      case "logout": {
        await AuthController().logoutUser();
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()), // Altere para sua tela inicial
              (route) => false, // Remove todas as rotas anteriores
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes da conta'),
        centerTitle: true,
      ),
      body: buttonData.isEmpty
          ? Center(child: CircularProgressIndicator()) // Indicador de carregamento
          : ListView.builder(
        padding: EdgeInsets.all(16.0),
        itemCount: buttonData.length,
        itemBuilder: (context, index) {
          final button = buttonData[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0), // Bordas arredondadas
              ),
              elevation: 4,
              child: InkWell(
                borderRadius: BorderRadius.circular(12.0),
                onTap: () {
                  print('${button.action} foi acionada!');
                  handleClick(button.action);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 12.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        button.label, // Label à esquerda
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios, // Ícone à direita
                        size: 20,
                        color: Colors.grey[600],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}