import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

void main() {
  runApp(const MainApp());
}

class Localizacao {
  double latitude = 0.0;
  double longitude = 0.0;

  Future<String?> pegaLocalizacaoAtual() async {
    // Verificar se o GPS está ativado
    bool servicoAtivo = await Geolocator.isLocationServiceEnabled();
    if (!servicoAtivo) {
      return "Serviço de localização desativado. Ative o GPS.";
    }

    // Verificar permissões
    LocationPermission permissao = await Geolocator.checkPermission();

    if (permissao == LocationPermission.denied) {
      permissao = await Geolocator.requestPermission();
      if (permissao == LocationPermission.denied) {
        return "Permissão negada.";
      }
    }

    if (permissao == LocationPermission.deniedForever) {
      return "Permissão permanentemente negada. Vá nas configurações.";
    }

    // Obter posição
    Position pos = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    latitude = pos.latitude;
    longitude = pos.longitude;

    return null; // sucesso
  }
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  Localizacao local = Localizacao();
  bool carregando = true;
  String? erro;

  @override
  void initState() {
    super.initState();
    pegarLocal();
  }

  Future<void> pegarLocal() async {
    final resultadoErro = await local.pegaLocalizacaoAtual();

    setState(() {
      erro = resultadoErro;
      carregando = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text("Busca Local")),
        body: Center(
          child: carregando
              ? const CircularProgressIndicator()
              : erro != null
                  ? Text(
                      erro!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 18, color: Colors.red),
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Latitude: ${local.latitude}",
                          style: const TextStyle(fontSize: 20),
                        ),
                        Text(
                          "Longitude: ${local.longitude}",
                          style: const TextStyle(fontSize: 20),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () async {
                            setState(() => carregando = true);
                            pegarLocal();
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
