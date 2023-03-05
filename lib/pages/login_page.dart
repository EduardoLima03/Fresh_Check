import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: SingleChildScrollView(
            child: Center(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const Text(
                      "Login",
                      style: TextStyle(color: Colors.black, fontSize: 36.0),
                    ),
                    const SizedBox(
                      height: 50.0,
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: "Email",
                        border: OutlineInputBorder(),
                        hintText: 'Enter valid mail id as abc@gmail.com',
                      ),
                      controller: _emailTextControl,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if(value!.isEmpty){
                          return "campo obrigatorio";
                        }else if(value!.contains('.api') && value!.contains('@')){
                          return null;
                        }else{
                          return "Deve ter @ e .api para ser considerado um email";
                        }
                      },
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: "Senha",
                        border: OutlineInputBorder(),
                      ),
                      controller: _passwordTextControl,
                      obscureText: true,
                      enableSuggestions: false,
                      autocorrect: false,
                      validator: (value) {
                        if (value!.isEmpty) return 'Campo obrigatorio';
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    SizedBox(
                      width: 250,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: isSave
                            ? null
                            : () async {
                                if (_formKey.currentState!.validate()) {}
                              },
                        // ignore: sort_child_properties_last
                        child: Visibility(
                          visible: isSave,
                          replacement: const Text(
                            "Login",
                            style: TextStyle(fontSize: 25.0),
                          ),
                          child: const CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          shape: const BeveledRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /*
  * informar qua esta enviado os dados
  * */
  bool isSave = false;

  final _formKey = GlobalKey<FormState>();
  final _emailTextControl = TextEditingController();
  final _passwordTextControl = TextEditingController();

  String? textFieldValidate(var value) {
    if (value!.isEmpty) return 'Campo obrigatorio';
    return null;
  }
}
