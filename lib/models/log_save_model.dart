class LogFields {
  static final String carimbo = 'Carimbo de data/hora';
  static final String erro = 'ERRO';
  static final String funcao = 'FUNÇÃO';

  static List<String> getFields() => [carimbo, erro, funcao];
}

class LogSave {
  final String carimbo;
  final String erro;
  final String funcao;

  const LogSave(
      {required this.carimbo, required this.erro, required this.funcao});

  Map<String, String> toJson() => {
        LogFields.carimbo: carimbo,
        LogFields.erro: erro,
        LogFields.funcao: funcao,
      };
}
