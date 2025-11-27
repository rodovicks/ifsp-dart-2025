import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(MaterialApp(
    home: Calculadora(),
    debugShowCheckedModeBanner: false,
  ));
}

class Calculadora extends StatefulWidget {
  @override
  _CalculadoraState createState() => _CalculadoraState();
}

class _CalculadoraState extends State<Calculadora> {
  String tela = "";

  void clicar(String valor) {
    if (valor == "=") {
      calcular();
      return;
    }

    setState(() {
      tela += valor;
    });
  }

  void limpar() {
    setState(() {
      tela = "";
    });
  }

  void calcular() {
    try {
      String expressao = tela.replaceAll("x", "*");

      Parser parser = Parser();
      Expression exp = parser.parse(expressao);

      double resultado = exp.evaluate(EvaluationType.REAL, ContextModel());

      setState(() {
        tela = resultado.toString();
      });
    } catch (e) {
      setState(() {
        tela = "Erro";
      });
    }
  }

  Widget botao(String txt) {
    return ElevatedButton(
      onPressed: () => clicar(txt),
      child: Text(
        txt,
        style: TextStyle(
          fontFamily: 'Orbitron',
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Color.fromARGB(255, 57, 56, 60),
        minimumSize: Size(66, 48),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(9),
        ),
        elevation: 4,
        shadowColor: Colors.black,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16),
              child: Text(
                tela,
                textAlign: TextAlign.right,
                style: GoogleFonts.orbitron(
                  fontSize: 48,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 20),

            // PRIMEIRA LINHA: AC / x / - / /
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: limpar,
                  child: Text(
                    "AC",
                    style: TextStyle(
                      fontFamily: "Orbitron",
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 57, 56, 60),
                    minimumSize: Size(66, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9),
                    ),
                  ),
                ),
                botao("/"),
                botao("x"),
                botao("-"),
              ],
            ),
            SizedBox(height: 10),

            // 7 8 9 +
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                botao("7"),
                botao("8"),
                botao("9"),
                botao("+"),
              ],
            ),
            SizedBox(height: 10),

            // 4 5 6 =
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                botao("4"),
                botao("5"),
                botao("6"),
                botao("="),
              ],
            ),
            SizedBox(height: 10),

            // 1 2 3 0
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                botao("1"),
                botao("2"),
                botao("3"),
                botao("0"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
