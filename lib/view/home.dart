import 'package:card_swiper/card_swiper.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rimiosite/providers/product_provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

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
      body: StreamBuilder(
        stream: productProvider.fetchProductsStream(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return const MaterialApp(
              debugShowCheckedModeBanner: false,
              home: Center(
                child: CircularProgressIndicator(),
              ),
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
    );
  }
}
