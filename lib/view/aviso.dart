import 'package:flutter/material.dart';

class Aviso extends StatelessWidget {
  const Aviso({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(height: 300, 'assets/logo.png'),
            const SizedBox(
                width: 250,
                child: Text('Lo sentimos :(\n\nEn estos momentos la página se encuentra en mantenimiento.', style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.w500),))
          ],
        ),
      )
    );
  }
}
