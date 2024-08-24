import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rimiosite/providers/favoritos_provider.dart';
import 'package:rimiosite/widgets/customButton.dart';
import 'package:rimiosite/widgets/productWidget.dart';

class Favoritos extends StatefulWidget {
  const Favoritos({super.key});

  @override
  State<Favoritos> createState() => _FavoritosState();
}

class _FavoritosState extends State<Favoritos> {

  final isEmpty = false;

  @override
  Widget build(BuildContext context) {

    final favoritosProvider = Provider.of<FavoritosProvider>(context);

    return favoritosProvider.getFavoritos.isEmpty
        ? Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        automaticallyImplyLeading: false,
        title: const Text('Favoritos', style: TextStyle(color: Colors.white),),
      ),
      body: Align(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Sin artículos', style: TextStyle(fontSize: 22, color: Colors.deepPurple),),
            const SizedBox(height: 10,),
            CustomButton(
                onTap: () async {
                  // await Navigator.push(context, MaterialPageRoute(builder: (context){
                  //   return SearchPage();
                  // }));
                },
                height: 50,
                width: 180,
                color: Colors.deepPurple,
                radius: 50,
                text: '¡Empieza YA!',
                fontSize: 20,
                textColor: Colors.white,
                shadow: 0,
                colorShadow: Colors.transparent),
          ],
        ),
      ),
    ) : Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.deepPurple,
        elevation: 5,
        shadowColor: Colors.purpleAccent,
        title: Text('Favoritos (${favoritosProvider.getFavoritos.length})', style: const TextStyle(color: Colors.white),),
        actions: [
          IconButton(
              onPressed: () async {
            await showDialog(context: context, builder: (context){
              return AlertDialog(
                title: Column(
                  children: [
                    const Text('¿Seguro deseas eliminar tus favoritos?'),
                    Row(
                      children: [
                        TextButton(onPressed: (){Navigator.pop(context);}, child: const Text('Cancelar')),
                        TextButton(onPressed: () async {
                          await favoritosProvider.clearWishlistFromFirebase();
                          favoritosProvider.clearLocalFav();
                          Navigator.pop(context);
                        }, child: const Text('Confirmar')),
                      ],
                    )
                  ],
                ),
              );
            });
        },
              icon: const Icon(Icons.delete_rounded, color: Colors.white,))],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 15.0, right: 8, left: 8),
        child: DynamicHeightGridView(
          itemCount: favoritosProvider.getFavoritos.length,
          crossAxisCount: 2,
          builder: (context, index){
            return ProductWidget(productId: favoritosProvider.getFavoritos.values.toList()[index].productId,);
          },
        ),
      ),
    );
  }
}

