import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:rimiosite/publicar/publicar.dart';
import 'package:rimiosite/view/comunidad.dart';
import 'package:rimiosite/view/favoritos.dart';
import 'package:rimiosite/view/home.dart';
import 'package:rimiosite/view/perfil.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {

  late List<Widget> screens;
  int currentScreen = 0;
  late PageController controller;

  @override
  void initState() {
    super.initState();
    screens = const [
      Home(),
      Favoritos(),
      Publicar(),
      Comunidad(),
      Perfil(),
    ];
    controller = PageController(initialPage: currentScreen);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: controller,
          children: screens,
        ),
      ),
      bottomNavigationBar: NavigationBar(
        height: 70,
        selectedIndex: currentScreen,
        onDestinationSelected: (index){
          setState(() {
            currentScreen = index;
          });
          controller.jumpToPage(currentScreen);
        },
        destinations: const [
          NavigationDestination(selectedIcon: Icon(IconlyBold.home, color: Colors.deepPurple,), icon: Icon(IconlyLight.home), label: 'Inicio'),
          NavigationDestination(selectedIcon: Icon(IconlyBold.heart, color: Colors.deepPurple,), icon: Icon(IconlyLight.heart), label: 'Favoritos'),
          NavigationDestination(selectedIcon: Icon(IconlyBold.upload, color: Colors.deepPurple,), icon: Icon(IconlyLight.upload), label: 'Publicar'),
          NavigationDestination(selectedIcon: Icon(Icons.people, color: Colors.deepPurple, size: 30,), icon: Icon(Icons.people_outline, size: 30,), label: 'Comunidad'),
          NavigationDestination(selectedIcon: Icon(IconlyBold.profile, color: Colors.deepPurple,), icon: Icon(IconlyLight.profile), label: 'Perfil'),
        ],
      ),
    );
  }
}
