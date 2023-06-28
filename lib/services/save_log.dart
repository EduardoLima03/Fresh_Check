import 'package:intl/intl.dart';

import '../models/log_save_model.dart';

class SaveLog{
  void log(String erro, String funcao) async {
    final logSave = {
      LogFields.carimbo:
      DateFormat("dd/MM/yyyy HH:mm:ss").format(DateTime.now()),
      LogFields.erro: erro,
      LogFields.funcao: funcao,
    };

    //await LogSheetsApi.insert([logSave]);
  }

}