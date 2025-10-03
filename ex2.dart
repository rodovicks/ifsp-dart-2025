void main() {
  int informado = DateTime.now().month;
  ;
  int atual = 10;

  if (atual > informado)
    print('$atual é maior que $informado');
  else if (atual == informado)
    print('$atual é igual ao $informado');
  else
    print('$atual é menor que $informado');
}
