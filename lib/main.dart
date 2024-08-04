import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:rimiosite/appConst.dart';
import 'package:rimiosite/firebase_options.dart';
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

    final screenSize = MediaQuery.sizeOf(context).width >= 600;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppConst.themeColor),
        useMaterial3: true,
      ),
       home: Aviso(),
       // screenSize
       //     ? const WebView()
       //     : const RootScreen(),
    );
  }
}
