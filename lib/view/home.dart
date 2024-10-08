import 'package:card_swiper/card_swiper.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rimiosite/models/categoria_model.dart';
import 'package:rimiosite/providers/product_provider.dart';
import 'package:rimiosite/providers/vistoReciente_provider.dart';
import 'package:rimiosite/widgets/categoryWidget.dart';
import 'package:rimiosite/widgets/itemTile.dart';
import 'package:rimiosite/widgets/productWidget.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  List<CategoriaModel> categoriaLista = [
    CategoriaModel(id: 'Guitarras', name: 'Guitarras', image: 'assets/guitarra.png'),
    CategoriaModel(id: 'Bajos', name: 'Bajos', image: 'assets/bass.png'),
    CategoriaModel(id: 'Amps', name: 'Amps', image: 'assets/amp.png'),
    CategoriaModel(id: 'Baterias', name: 'Baterias', image: 'assets/bateria.png'),
    CategoriaModel(id: 'Teclados', name: 'Teclados', image: 'assets/teclado.png'),
    CategoriaModel(id: 'Folklore', name: 'Folklore', image: 'assets/tradicional.png'),
    CategoriaModel(id: 'Orquesta', name: 'Orquesta', image: 'assets/orquesta.png'),
    CategoriaModel(id: 'Dj', name: 'Dj', image: 'assets/dj.png'),
    CategoriaModel(id: 'Microfonos', name: 'Micrófonos', image: 'assets/microphone.png'),
    CategoriaModel(id: 'Aire', name: 'Aire', image: 'assets/aire.png'),
    CategoriaModel(id: 'Estudio', name: 'Estudio', image: 'assets/estudio.png'),
    CategoriaModel(id: 'Merch', name: 'Merch', image: 'assets/camisa.png'),
    CategoriaModel(id: 'Iluminacion', name: 'Iluminación', image: 'assets/spotlight.png'),
    CategoriaModel(id: 'Pedales', name: 'Pedales', image: 'assets/guitar-pedal.png'),
    CategoriaModel(id: 'Servicios', name: 'Servicios', image: 'assets/servicio.png'),
    CategoriaModel(id: 'Accesorios', name: 'Accesorios', image: 'assets/pick.png'),
    CategoriaModel(id: 'Repuestos', name: 'Repuestos', image: 'assets/metal.png'),
  ];

  List<String> bannerImages = [];

  @override
  void initState() {
    super.initState();
    fetchBanners();
  }

  /// Fetching banners
  Future<void> fetchBanners() async {
    try {
      //final userDoc = await FirebaseFirestore.instance.collection("banners").doc('homescreenbanners').get();
      final ref1 = FirebaseStorage.instance.ref().child('bannerImages').child('banner1.jpg');
      final ref2 = FirebaseStorage.instance.ref().child('bannerImages').child('banner2.jpg');
      final ref3 = FirebaseStorage.instance.ref().child('bannerImages').child('banner3.jpg');
      final ref4 = FirebaseStorage.instance.ref().child('bannerImages').child('bannerUsa.png');

      String banner1 = await ref1.getDownloadURL();
      String banner2 = await ref2.getDownloadURL();
      String banner3 = await ref3.getDownloadURL();
      String banner4 = await ref4.getDownloadURL();

      bannerImages = [banner4, banner1, banner2, banner3];
    } catch (e) {}
  }
  /// /// /// /// ///

  @override
  Widget build(BuildContext context) {

    final productProvider = Provider.of<ProductsProvider>(context);
    final vistoProvider = Provider.of<VistoRecienteProvider>(context);

    for (var url in bannerImages) {
      precacheImage(NetworkImage(url),context);
    }

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset(height: 40,'assets/Rimio_w.png'),
            const SizedBox(width: 25,),
            GestureDetector(
                child: MaterialButton(onPressed: () {  },
                child: Image.asset(height: 30,'assets/google-play.png'))),
          ],
        ),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(onPressed: () {
            }, icon: const Icon(Icons.search_rounded, color: Colors.white, size: 30, ),),
          ),
          /*Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: const Badge(
                  label: Text('6'),
                  backgroundColor: Colors.redAccent,
                  child: Icon(Icons.favorite_rounded, color: Colors.white, size: 30,)),
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context){
                  return CartPage();
                }));
              },),
          ),*/
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            StreamBuilder(
            stream: productProvider.fetchProductsStream(),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return  const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: SelectableText(snapshot.error.toString()),
                );
              } else if (snapshot.data == null) {
                return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(color: Colors.deepPurple,),
                    )
                );
              }
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: 300,
                  width: MediaQuery.of(context).size.width,
                  child: Swiper(
                    containerWidth: MediaQuery.of(context).size.width,
                    autoplay: true,
                    autoplayDelay: 5000,
                    duration: 2000,
                    curve: Curves.ease,
                    itemBuilder: (BuildContext context,int index){
                      return ClipRRect(
                          borderRadius: BorderRadius.circular(21),
                          child: Image.network(fit: BoxFit.fill, bannerImages[index]));
                    },
                    itemCount: bannerImages.length,
                    // pagination: const SwiperPagination(
                    //     builder: SwiperPagination.dots
                    // ),
                  ),
                ),
              );
            },
          ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text('Categorías', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),),
                ],
              ),
            ),
            const SizedBox(height: 8,),
            SizedBox(
              height: 100,
              child: ListView(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  children: List.generate(categoriaLista.length, (index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: CategoryWidget(image: categoriaLista[index].image, categoria: categoriaLista[index].name),
                    );
                  })),
            ),
            Visibility(
              visible: vistoProvider.getVisto.isNotEmpty,
              child: Padding(
                padding: const EdgeInsets.only(top: 4.0, left: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Visibility(
                        visible: productProvider.getProducts.isNotEmpty,
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: Text('Vistos recientemente', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),),
                        )),
                  ],
                ),
              ),
            ),
            Visibility(
              visible: vistoProvider.getVisto.isNotEmpty,
              child: SizedBox(
                height: 310,
                width: double.maxFinite,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: vistoProvider.getVisto.length < 10
                        ? vistoProvider.getVisto.length
                        : 10,
                    itemBuilder: (context, index){
                      return Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: ProductWidget(productId: vistoProvider.getVisto.values.toList()[index].productId,),
                      );
                    }),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4.0, left: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Visibility(
                      visible: productProvider.getProducts.isNotEmpty,
                      child: const Text('Publicaciones recientes', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),)),
                  GestureDetector(
                      onTap: (){},
                      child: TextButton(
                        onPressed: () {
                          // Navigator.pushNamed(context, SearchPage.routeName);
                        },
                        child: Visibility(
                            visible: productProvider.getProducts.isNotEmpty,
                            child: const Text('Ver más', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.purple),)),)),
                ],
              ),
            ),
            Visibility(
              visible: productProvider.getProducts.isNotEmpty,
              child: SizedBox(
                height: 310,
                width: double.maxFinite,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: productProvider.getProducts.length < 10
                        ? productProvider.getProducts.length
                        : 10,
                    itemBuilder: (context, index){
                      return ChangeNotifierProvider.value(
                          value: productProvider.getProducts[index],
                          child: itemTile());
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
