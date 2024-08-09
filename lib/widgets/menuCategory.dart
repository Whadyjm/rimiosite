import 'package:flutter/material.dart';
import 'package:rimiosite/models/categoria_model.dart';

class MenuCategory extends StatelessWidget {
  const MenuCategory({super.key, required this.categoria});

  final String categoria;

  @override
  Widget build(BuildContext context) {

    return SizedBox(
      height: 20,
      width: 100,
      child: Text(categoria)
    );
  }
}
