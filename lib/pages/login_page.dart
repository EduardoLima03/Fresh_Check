import 'package:coleta_de_validade_lj04/controller/login_controller.dart';
import 'package:coleta_de_validade_lj04/pages/form_page.dart';
import 'package:coleta_de_validade_lj04/widgets/utils/snackbar_custom.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final LoginController _controller = LoginController();

  @override
  void initState() {
    _controller.verificarToken().then((value) {
      if (value) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => FormPage()));
      }
    });
    super.initState();
  }

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
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      "Login",
                      style: TextStyle(color: Colors.black, fontSize: 36.0),
                    ),
                    const SizedBox(
                      height: 50.0,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: "Email",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: BorderSide.none,
                        ),
                        fillColor:
                            Theme.of(context).primaryColor.withOpacity(0.1),
                        filled: true,
                        prefixIcon: const Icon(Icons.email_outlined),
                      ),
                      controller: _emailTextControl,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "campo obrigatorio";
                        } else if (value!.contains('.') &&
                            value!.contains('@')) {
                          return null;
                        } else {
                          return "Deve ter @ e .api para ser considerado um email";
                        }
                      },
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.password_outlined),
                        hintText: "Senha",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: BorderSide.none,
                        ),
                        fillColor:
                            Theme.of(context).primaryColor.withOpacity(0.1),
                        filled: true,
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
                                if (_formKey.currentState!.validate()) {
                                  try {
                                    String? teste = await _controller.login(
                                        email: _emailTextControl.text.toString(),
                                        password: _passwordTextControl.text.toString(),);
                                    if (teste != 'erro') {
                                      // ignore: use_build_context_synchronously
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const FormPage()));
                                    } else {
                                      // ignore: use_build_context_synchronously
                                      SnackbarCustom().show(context,
                                          "Usuario invalido", Colors.red);
                                    }
                                  } catch (e) {
                                    SnackbarCustom().show(context, "ERRO: ${e.runtimeType}", Colors.red);
                                  }
                                }
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

  @override
  void dispose() {
    _passwordTextControl.dispose();
    _emailTextControl.dispose();
    super.dispose();
  }

  String? textFieldValidate(var value) {
    if (value!.isEmpty) return 'Campo obrigatorio';
    return null;
  }

  
}
