import 'dart:js';

import 'package:coleta_de_validade_lj04/pages/login_page.dart';
import 'package:coleta_de_validade_lj04/pages/splash_page.dart';
import 'package:coleta_de_validade_lj04/resources/data/user_data_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


void main() async {
  runApp(const SplashPage());
  WidgetsFlutterBinding.ensureInitialized();
  //await UserSheetsApi.init();
  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(create: (context) => UserDataProivder());
    ],
    child: const MyApp(),
    )
  );
  
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Coletor de Validade',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const LoginPage(),
    );
  }
}
