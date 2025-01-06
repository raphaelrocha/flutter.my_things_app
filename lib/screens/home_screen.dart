import 'package:flutter/material.dart';
import 'package:my_thyngs_app/models/menu/MenuItem.dart';
import 'package:my_thyngs_app/screens/user_details_screen.dart';

import '../controllers/auth_controller.dart';
import '../controllers/home_controller.dart';
import '../models/User.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeController controller = HomeController(); // Instancia a controller
  List<MenuItem> buttonData = [];

  @override
  void initState() {
    super.initState();
    loadMenu(); // Carrega o menu ao inicializar
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Things App'),
        centerTitle: true,
        leading: FutureBuilder<User?>(
          future: AuthController().getUser(), // Chama o método getUser
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(), // Indicador de carregamento
              );
            } else if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
              return Icon(Icons.error); // Ícone de erro se falhar
            } else {
              final User user = snapshot.data!;
              return GestureDetector(
                onTap: () {
                  print('Imagem clicada!');
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => UserDetailsScreen()),
                  );
                  // Ação ao clicar na imagem
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0), // Espaçamento ao redor da imagem
                  child: ClipOval(
                    child: Image.network(
                      user.photoURL, // URL da imagem vinda do objeto User
                      fit: BoxFit.cover, // Ajusta a imagem dentro do espaço disponível
                      width: 40.0, // Largura da imagem
                      height: 40.0, // Altura da imagem
                      loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                        if (loadingProgress == null) return child; // Exibe a imagem carregada
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1)
                                : null,
                          ),
                        );
                      },
                      errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                        return Icon(Icons.error); // Ícone exibido caso a imagem falhe ao carregar
                      },
                    ),
                  ),
                ),
              );
            }
          },
        ),
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