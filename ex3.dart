void main() {
  DateTime hoje = DateTime.now();
  int ano = hoje.year;
  int mes = hoje.month;

  DateTime primeiroDiaMes = DateTime(ano, mes, 1);

  print('| D | S | T | Q | Q | S | S |');

  String linha = '';
  for (int i = 0; i < primeiroDiaMes.weekday % 7; i++) {
    linha += '    ';
  }

  for (int dia = 1; dia <= hoje.day; dia++) {
    DateTime data = DateTime(ano, mes, dia);

    String diaFormatado = dia.toString().padLeft(2, '0');
    linha += ' $diaFormatado ';

    if (data.weekday % 7 == 0) {
      print(linha);
      linha = '';
    }
  }

  if (linha.isNotEmpty) {
    print(linha);
  }
}
