import 'package:coleta_de_validade_lj04/api/busca_desc/busca_desc.dart';
import 'package:coleta_de_validade_lj04/pages/about_page.dart';
import 'package:coleta_de_validade_lj04/pages/login_page.dart';
import 'package:coleta_de_validade_lj04/services/login_service.dart';
import 'package:coleta_de_validade_lj04/widgets/utils/snackbar_custom.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/sheets/user_sheets_api.dart';
import '../controller/selected_dropdown_button.dart';
import '../models/user_fields_model.dart';
import '../widgets/text_field_custom.dart';

class FormPage extends StatefulWidget {
  const FormPage({
    Key? key,
  }) : super(key: key);

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final _formKey = GlobalKey<FormState>();
  var codControl = TextEditingController();
  var eanControl = TextEditingController();
  var descControl = TextEditingController();
  final _dateContrl = TextEditingController();
  final _qualyControl = TextEditingController();

  SelectedDropdownButton _selectedDropdownButton = SelectedDropdownButton();
  final LoginService _service = LoginService();

  /// barcode*/
  String _scanBarcode = 'Unknown';

  //TOKEN
  var _token;

  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _scanBarcode = barcodeScanRes;
    });
    await mostraDesc();
  }

  mostraDesc() async {
    isSave = true;
    var text;
    if (_scanBarcode != 'Unknown') {
      eanControl.text = _scanBarcode;
      try{
        text = await BuscaDesc().getDesc(eanControl, context, _token);
      }catch(e){
        SnackbarCustom().show(context, "ERRO: ${e.runtimeType}", Colors.red);
      }

      print(text['code']);
      setState(() {
        descControl.text = text['descricao'].toString();
        codControl.text = text['code'].toString();
        isSave = false;
      });
    } else {
      try{
        text = await BuscaDesc().getDesc(eanControl, context, _token);
      }catch(e){
        SnackbarCustom().show(context, "ERRO: ${e.runtimeType}", Colors.red);
      }
      setState(() {
        descControl.text = text.toString();
        codControl.text = text['code'].toString();
        isSave = false;
      });
    }
  }

  /*
  * informar qua esta enviado os dados
  * */
  bool isSave = false;

  @override
  initState() {
    getToken().then((value) {
      _token = value.toString();
    });
    _service.readToken();
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  @override
  void dispose() {
    codControl.dispose();
    eanControl.dispose();
    descControl.dispose();
    _dateContrl.dispose();
    _qualyControl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro Loja 04'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const AboutPage()));
            },
            icon: const Icon(Icons.help),
          ),
          IconButton(onPressed: (){
            try{
              _service.logout().then((value) {
                if(value){
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> const LoginPage()));
                }
              });
            }catch (e){
              SnackbarCustom().show(context, 'ERRO: ${e.runtimeType.toString()}', Colors.red);
            }

          }, icon: const Icon(Icons.logout_outlined)),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFieldCustom(
                  label: "Code",
                  controler: codControl,
                  inputType: TextInputType.number,
                ),
                Row(
                  children: [
                    Flexible(
                      flex: 6,
                      child: TextFormField(
                        decoration: const InputDecoration(
                          labelText: "EAN",
                        ),
                        controller: eanControl,
                        validator: (value) {
                          if (value!.isEmpty) return 'Campo obrigatorio';
                          return null;
                        },
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: () async => await mostraDesc(),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: IconButton(
                        icon: const Icon(Icons.qr_code_scanner),
                        onPressed: () => scanBarcodeNormal(),
                      ),
                    ),
                  ],
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: "Descrição"),
                  controller: descControl,
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        value == "Erro" ||
                        value == "null" ||
                        value == "Null") {
                      return 'Campo obrigatorio';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _qualyControl,
                  decoration: const InputDecoration(
                      hintText: "Quantidade", labelText: "Quantidade"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Campo obrigatorio';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.number,
                ),
                TextFormField(
                  controller: _dateContrl,
                  decoration: const InputDecoration(labelText: "Validade"),
                  onTap: () async {
                    var date1 = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2030));
                    _dateContrl.text = date1.toString();
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Campo obrigatorio';
                    }
                    return null;
                  },
                ),
                ValueListenableBuilder(
                  valueListenable: _selectedDropdownButton.selectedAuditor,
                  builder: (BuildContext context, String value, _) {
                    return SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: DropdownButtonFormField<String>(
                        hint: const Text('AUDITOR'),
                        decoration: const InputDecoration(
                          label: Text('AUDITOR'),
                        ),
                        value: (value.isEmpty) ? null : value,
                        onChanged: (escolha) => _selectedDropdownButton
                            .selectedAuditor.value = escolha.toString(),
                        items: _selectedDropdownButton.auditor
                            .map((e) => DropdownMenuItem(
                                  value: e,
                                  child: Text(e),
                                ))
                            .toList(),
                      ),
                    );
                  },
                ),
                ValueListenableBuilder(
                  valueListenable: _selectedDropdownButton.selectedSetor,
                  builder: (BuildContext context, String value, _) {
                    return SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: DropdownButtonFormField<String>(
                        hint: const Text(
                          'SELECIONE O SETOR AUDITADO',
                          style: TextStyle(fontSize: 12.0),
                        ),
                        decoration: const InputDecoration(
                          label: Text(
                            'SELECIONE O SETOR AUDITADO',
                            style: TextStyle(fontSize: 12.0),
                          ),
                        ),
                        value: (value.isEmpty) ? null : value,
                        onChanged: (escolha) => _selectedDropdownButton
                            .selectedSetor.value = escolha.toString(),
                        items: _selectedDropdownButton.setor
                            .map((e) => DropdownMenuItem(
                                  value: e,
                                  child: Text(
                                    e,
                                    style: const TextStyle(fontSize: 12.0),
                                  ),
                                ))
                            .toList(),
                      ),
                    );
                  },
                ),
                const SizedBox(
                  height: 10.0,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: ElevatedButton(
                    onPressed: isSave
                        ? null
                        : () async {
                            if (_formKey.currentState!.validate()) {
                              if (_selectedDropdownButton
                                      .selectedAuditor.value.isEmpty ||
                                  _selectedDropdownButton
                                      .selectedSetor.value.isEmpty) {
                                SnackbarCustom().show(
                                    context,
                                    'Campo Auditor e Setor obrigatorio!',
                                    Colors.red);
                              } else {
                                final user = {
                                  UserFields.carimbo:
                                      DateFormat("dd/MM/yyyy HH:mm:ss")
                                          .format(DateTime.now()),
                                  UserFields.auditor:
                                      "${_service.name.value} - ${_service.function.value}",
                                  UserFields.setor: _selectedDropdownButton
                                      .selectedSetor.value,
                                  UserFields.descricao: descControl.text,
                                  UserFields.ean: eanControl.text,
                                  UserFields.quantidade: _qualyControl.text,
                                  UserFields.validade: DateFormat("dd/MM/yyy")
                                      .format(DateTime.parse(
                                          _dateContrl.text.toString())),
                                };
                                var isSuccess =
                                    await UserSheetsApi.insert([user]);
                                if (isSuccess) {
                                  // ignore: use_build_context_synchronously
                                  SnackbarCustom().show(context,
                                      "Sucesso ao Salvar!", Colors.green);

                                  clearForm();
                                } else {
                                  // ignore: use_build_context_synchronously
                                  SnackbarCustom().show(
                                      context, "Erro ao Salvar!", Colors.red);
                                }
                              }
                            }
                          },
                    child: Visibility(
                      visible: isSave,
                      replacement: const Text("Enviar"),
                      child: const CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void clearForm() {
    setState(() {
      codControl.text = "";
      eanControl.text = "";
      descControl.text = "";
      _dateContrl.text = "";
      _qualyControl.text = '';
    });
  }

  Future<String> getToken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString('token').toString();
  }
}
