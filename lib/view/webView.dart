import 'package:flutter/material.dart';
import 'package:rimiosite/view/authPages/login.dart';
import 'package:rimiosite/view/authPages/registro.dart';

class WebView extends StatefulWidget {
  const WebView({super.key});

  @override
  State<WebView> createState() => _WebViewState();
}

class _WebViewState extends State<WebView> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        title: Column(
          children: [
            Row(
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
                    return Registro();
                  });
                }, child: const Text('Crea tu cuenta', style: TextStyle(color: Colors.white),)),
                TextButton(onPressed: (){
                  showDialog(context: context, builder: (context){
                    return Login();
                  });
                }, child: const Text('Ingresa', style: TextStyle(color: Colors.white),)),
                GestureDetector(
                    child: MaterialButton(onPressed: () {  },
                    child: Image.asset(height: 40,'assets/google-play.png'))),
              ],
            ),
            const SizedBox(height: 10,),
            Row(
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
            )
          ],
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }
}
