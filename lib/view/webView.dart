import 'package:animate_do/animate_do.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rimiosite/models/categoria_model.dart';
import 'package:rimiosite/providers/product_provider.dart';
import 'package:rimiosite/view/authPages/login.dart';
import 'package:rimiosite/view/authPages/registro.dart';
import 'package:rimiosite/widgets/categoryWidget.dart';

class WebView extends StatefulWidget {
  const WebView({super.key});

  @override
  State<WebView> createState() => _WebViewState();
}

class _WebViewState extends State<WebView> {

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

    for (var url in bannerImages) {
      precacheImage(NetworkImage(url),context);
    }

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        title: Column(
          children: [
            Center(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(height: 40,'assets/Rimio_w.png'),
                    const SizedBox(width: 40,),
                    SizedBox(
                      height: 40,
                      width: 500,
                      child: TextField(
                        // onChanged: (value){
                        //   setState(() {
                        //     productListSearch = productsProvider.searchQuery(searchText: searchTextController.text, passedList: productList);
                        //   });
                        // },
                        textCapitalization: TextCapitalization.words,
                        // onSubmitted: (value) {
                        //   setState(() {
                        //     productListSearch = productsProvider.searchQuery(searchText: searchTextController.text, passedList: productList);
                        //   });
                        // // },
                        // controller: searchTextController,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(5),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          prefixIcon: const Icon(Icons.search_rounded, color: Colors.deepPurple,),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.clear, color: Colors.redAccent, size: 20,),
                            onPressed: () {
                              FocusScope.of(context).unfocus();
                            },),
                          hintText: '¡Encuentralo en Rimio!',
                          hintStyle: const TextStyle(fontWeight: FontWeight.w400),
                        ),
                      ),
                    ),
                    const SizedBox(width: 30,),
                    TextButton(onPressed: (){
                      showDialog(context: context, builder: (context){
                        return FadeInUp(
                          duration: const Duration(milliseconds: 500),
                            child: const Registro());
                      });
                    }, child: const Text('Crea tu cuenta', style: TextStyle(color: Colors.white),)),
                    TextButton(onPressed: (){
                      showDialog(context: context, builder: (context){
                        return FadeInUp(
                            duration: const Duration(milliseconds: 500),
                            child: const Login());
                      });
                    }, child: const Text('Ingresa', style: TextStyle(color: Colors.white),)),
                    GestureDetector(
                        child: MaterialButton(onPressed: () {  },
                        child: Image.asset(height: 40,'assets/google-play.png'))),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10,),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                      onPressed: (){}, child: const Row(
                    children: [
                      Text('Categorías', style: TextStyle(color: Colors.white),),
                      Icon(Icons.arrow_drop_down, color: Colors.white,)
                    ],
                  )),
                  const SizedBox(width: 900,),
                ],
              ),
            )
          ],
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                StreamBuilder(
                  stream: productProvider.fetchProductsStream(),
                  builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return const Center(
                          child: CircularProgressIndicator(),
                        );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: SelectableText(snapshot.error.toString()),
                      );
                    } else if (snapshot.data == null) {
                      return const Center(
                          child: CircularProgressIndicator(color: Colors.deepPurple,)
                      );
                    }
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        height: 450,
                        width: 850,
                        child: Swiper(
                          control: const SwiperControl(
                            size: 40,
                            color: Colors.white38,
                            iconNext: Icons.arrow_circle_right,
                            iconPrevious: Icons.arrow_circle_left,
                          ),
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
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                const SizedBox(width: 350,),
                Text('Categorías', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),),
              ],
            ),
          ),
          const SizedBox(height: 8,),
          Center(
            child: SizedBox(
              height: 80,
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
          ),
        ],
      ),
    );
  }
}
