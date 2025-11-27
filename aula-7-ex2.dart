import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  double? temperatura;
  double? umidade;
  double? vento;
  String? erro;
  bool carregando = true;

  final String apiKey = "135f23f1bb7468fec91c9a28940f64d8";

  @override
  void initState() {
    super.initState();
    carregarClima();
  }

  Future<void> carregarClima() async {
    try {
      // 1. Verificar se GPS está ativo
      bool gpsAtivo = await Geolocator.isLocationServiceEnabled();
      if (!gpsAtivo) {
        setState(() {
          erro = "O GPS está desativado. Ative a localização.";
          carregando = false;
        });
        return;
      }

      // 2. Verificar permissões
      LocationPermission perm = await Geolocator.checkPermission();

      if (perm == LocationPermission.denied) {
        perm = await Geolocator.requestPermission();
        if (perm == LocationPermission.denied) {
          setState(() {
            erro = "Permissão de localização negada.";
            carregando = false;
          });
          return;
        }
      }

      if (perm == LocationPermission.deniedForever) {
        setState(() {
          erro = "Permissão negada permanentemente. Vá nas configurações.";
          carregando = false;
        });
        return;
      }

      // 3. Obter localização
      Position pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      double lat = pos.latitude;
      double lon = pos.longitude;

      // 4. Chamar API
      String url =
          "https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$apiKey&units=metric&lang=pt_br";

      var resposta = await http.get(Uri.parse(url));

      if (resposta.statusCode != 200) {
        setState(() {
          erro = "Erro ao buscar clima (${resposta.statusCode})";
          carregando = false;
        });
        return;
      }

      // 5. Decodificar JSON
      var dados = jsonDecode(resposta.body);

      setState(() {
        temperatura = (dados["main"]["temp"] ?? 0).toDouble();
        umidade = (dados["main"]["humidity"] ?? 0).toDouble();
        vento = (dados["wind"]["speed"] ?? 0).toDouble();
        carregando = false;
      });

    } catch (e) {
      setState(() {
        erro = "Ocorreu um erro inesperado: $e";
        carregando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text("Clima Atual")),
        body: Center(
          child: carregando
              ? const CircularProgressIndicator()

              : erro != null
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          erro!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.red,
                          ),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              carregando = true;
                              erro = null;
                            });
                            carregarClima();
                          },
                          child: const Text("Tentar novamente"),
                        )
                      ],
                    )

                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Temperatura: ${temperatura?.toStringAsFixed(1)} °C",
                          style: const TextStyle(fontSize: 20),
                        ),
                        Text(
                          "Umidade: ${umidade?.toStringAsFixed(0)} %",
                          style: const TextStyle(fontSize: 20),
                        ),
                        Text(
                          "Vento: ${vento?.toStringAsFixed(1)} m/s",
                          style: const TextStyle(fontSize: 20),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              carregando = true;
                            });
                            carregarClima();
                          },
                          child: const Text("Atualizar"),
                        ),
                      ],
                    ),
        ),
      ),
    );
  }
}
