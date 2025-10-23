import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('pt_BR', null); // Inicializa o locale
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: const Locale('pt', 'BR'),
      supportedLocales: const [Locale('pt', 'BR')],
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime atual = DateTime.now();
  int aba = 3;

  final eventos = [
    {"date": DateTime(2024, 4, 1), "title": "Aniversário do João", "time": "18:30"},
    {"date": DateTime(2024, 4, 12), "title": "Aniversário da Nayara", "time": "20:00"},
    {"date": DateTime(2024, 4, 20), "title": "Reunião no Zoom", "time": "10:30 - 12:30"},
    {"date": DateTime(2024, 5, 5), "title": "Partida de Futebol", "time": "14:30 - 17:30"},
  ];

  // ---------- MÉTODOS AUXILIARES ----------
  List<DateTime> diasDoMes(DateTime d) {
    final fim = DateTime(d.year, d.month + 1, 0);
    return List.generate(fim.day, (i) => DateTime(d.year, d.month, i + 1));
  }

  String mesNome(int m) {
    const meses = [
      "Janeiro", "Fevereiro", "Março", "Abril", "Maio", "Junho",
      "Julho", "Agosto", "Setembro", "Outubro", "Novembro", "Dezembro"
    ];
    return meses[m - 1];
  }

  String mesCurto(int m) {
    const meses = ["Jan", "Fev", "Mar", "Abr", "Mai", "Jun", "Jul", "Ago", "Set", "Out", "Nov", "Dez"];
    return meses[m - 1];
  }

  String diaSemanaCurto(int w) {
    const dias = ["Seg", "Ter", "Qua", "Qui", "Sex", "Sáb", "Dom"];
    return dias[w - 1];
  }

  void anterior() {
    setState(() => atual = DateTime(atual.year, atual.month - 1, 1));
  }

  void proximo() {
    setState(() => atual = DateTime(atual.year, atual.month + 1, 1));
  }

  bool temEvento(DateTime d) {
    return eventos.any((e) {
      final data = e["date"] as DateTime;
      return data.year == d.year && data.month == d.month && data.day == d.day;
    });
  }

  @override
  Widget build(BuildContext context) {
    final dias = diasDoMes(atual);
    final tituloMes = "${mesNome(atual.month)} ${atual.year}";

    final eventosDoMes = eventos
        .where((e) =>
            (e["date"] as DateTime).month == atual.month &&
            (e["date"] as DateTime).year == atual.year)
        .toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 64,
        titleSpacing: 8,
        title: Row(
          children: [
            IconButton(
              onPressed: anterior,
              icon: const Icon(Icons.chevron_left, color: Colors.black87),
            ),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (child, anim) => FadeTransition(opacity: anim, child: child),
                child: Text(
                  tituloMes,
                  key: ValueKey(tituloMes),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),
            IconButton(
              onPressed: proximo,
              icon: const Icon(Icons.chevron_right, color: Colors.black87),
            ),
          ],
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: Icon(Icons.tune, color: Colors.black54),
          ),
        ],
      ),
      body: Column(
        children: [
          // ---------------- CALENDÁRIO ----------------
          SizedBox(
            height: 88,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: dias.length,
              itemBuilder: (context, i) {
                final d = dias[i];
                final selecionado =
                    d.day == atual.day && d.month == atual.month && d.year == atual.year;
                final possuiEvento = temEvento(d);

                return GestureDetector(
                  onTap: () => setState(() => atual = d),
                  child: Container(
                    width: 64,
                    margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          diaSemanaCurto(d.weekday),
                          style: const TextStyle(color: Colors.black54, fontSize: 12),
                        ),
                        const SizedBox(height: 6),
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: 38,
                              height: 38,
                              decoration: BoxDecoration(
                                color: selecionado
                                    ? const Color(0xFF5E35B1)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: const Color(0xFF5E35B1)),
                              ),
                              child: Center(
                                child: Text(
                                  "${d.day}",
                                  style: TextStyle(
                                    color: selecionado ? Colors.white : Colors.black87,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            if (possuiEvento && !selecionado)
                              Positioned(
                                bottom: 4,
                                child: Container(
                                  width: 6,
                                  height: 6,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF5E35B1),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // ---------------- LISTA DE EVENTOS ----------------
          Expanded(
            child: eventosDoMes.isEmpty
                ? const Center(
                    child: Text(
                      "Nenhum evento neste mês 😴",
                      style: TextStyle(color: Colors.black54, fontSize: 16),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    itemCount: eventosDoMes.length,
                    itemBuilder: (context, i) {
                      final e = eventosDoMes[i];
                      return _EventoCard(
                        data: e["date"] as DateTime,
                        titulo: e["title"].toString(),
                        horario: e["time"].toString(),
                        mesCurtoFn: mesCurto,
                      );
                    },
                  ),
          ),
        ],
      ),

      // ---------------- BOTÃO DE AÇÃO ----------------
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: const Color(0xFF5E35B1),
        child: const Icon(Icons.add, color: Colors.white),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,

      // ---------------- NAVEGAÇÃO INFERIOR ----------------
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: aba,
        onTap: (i) => setState(() => aba = i),
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFFF7F5FF),
        selectedItemColor: const Color(0xFF5E35B1),
        unselectedItemColor: Colors.black45,
        showUnselectedLabels: true,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.email_outlined), label: 'Email'),
          BottomNavigationBarItem(icon: Icon(Icons.task_alt_outlined), label: 'Tarefas'),
          BottomNavigationBarItem(icon: Icon(Icons.video_call_outlined), label: 'Reunião'),
          BottomNavigationBarItem(icon: Icon(Icons.event_note_outlined), label: 'Agenda'),
          BottomNavigationBarItem(icon: Icon(Icons.cloud_outlined), label: 'Arquivos'),
        ],
      ),
    );
  }
}

class _EventoCard extends StatelessWidget {
  final DateTime data;
  final String titulo;
  final String horario;
  final String Function(int) mesCurtoFn;

  const _EventoCard({
    required this.data,
    required this.titulo,
    required this.horario,
    required this.mesCurtoFn,
  });

  @override
  Widget build(BuildContext context) {
    final diaSemana = DateFormat('EEE', 'pt_BR').format(data).toUpperCase();

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(color: Color(0x08000000), blurRadius: 8, offset: Offset(0, 2))
        ],
      ),
      child: Row(
        children: [
          const SizedBox(width: 10),
          Container(
            width: 58,
            margin: const EdgeInsets.symmetric(vertical: 12),
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F7),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.black12),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(mesCurtoFn(data.month).toUpperCase(),
                    style: const TextStyle(fontSize: 12, color: Colors.black54)),
                Text(data.day.toString().padLeft(2, '0'),
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w700)),
                Text(diaSemana,
                    style: const TextStyle(
                        fontSize: 10, color: Colors.black45, height: 1.2)),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(titulo,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.access_time, size: 14, color: Colors.black45),
                      const SizedBox(width: 4),
                      Text(horario,
                          style: const TextStyle(
                              fontSize: 13, color: Colors.black54)),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Icon(Icons.event_available_outlined,
                color: Colors.deepPurple.shade300),
          ),
        ],
      ),
    );
  }
}
