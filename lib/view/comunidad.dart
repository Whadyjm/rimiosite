import 'package:flutter/material.dart';

class Comunidad extends StatelessWidget {
  const Comunidad({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.deepPurple,
      body: Center(
        child: Text('¡Próximamente!', style: TextStyle(fontSize: 30, color: Colors.white),),
      ),
    );
  }
}
