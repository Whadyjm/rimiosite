import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
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
    );
  }
}
