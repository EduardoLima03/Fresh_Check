import 'package:flutter/material.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/icons/loja4.png'),
              const SizedBox(
                height: 20.0,
              ),
              const Text(
                'Coletor de Validade',
                style: TextStyle(color: Colors.green, fontSize: 24.0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
