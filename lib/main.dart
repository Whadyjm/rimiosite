import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rimiosite/appConst.dart';
import 'package:rimiosite/firebase_options.dart';
import 'package:rimiosite/providers/product_provider.dart';
import 'package:rimiosite/providers/user_provider.dart';
import 'package:rimiosite/rootScreen.dart';
import 'package:rimiosite/view/aviso.dart';
import 'package:rimiosite/view/webView.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    final screenSize = MediaQuery.sizeOf(context).width > 600;

    return FutureBuilder(
      future: Firebase.initializeApp(),
      builder: (BuildContext context, AsyncSnapshot<FirebaseApp> snapshot) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_){
              return UserProvider();
            }),
            ChangeNotifierProvider(create: (_){
              return ProductsProvider();
            }),
          ],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: AppConst.themeColor),
              useMaterial3: true,
            ),
            home: screenSize
                ? const WebView()
                : const RootScreen(),
          ),
        );
      },
    );
  }
}
