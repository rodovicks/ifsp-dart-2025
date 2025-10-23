import 'package:flutter/material.dart';

void main() => runApp(const ChatApp());

class ChatApp extends StatelessWidget {
  const ChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Whats Zap',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF075E54)),
        useMaterial3: true,
      ),
      home: const ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final input = TextEditingController();
  final scroll = ScrollController();
  final mensagens = <Map<String, dynamic>>[];
  bool souEu = true;

  void enviar() {
    final texto = input.text.trim();
    if (texto.isEmpty) return;

    final agora = DateTime.now();

    setState(() {
      mensagens.add({"text": texto, "me": souEu, "time": agora});
      souEu = !souEu;
      input.clear();
    });

    // Scroll suave até o final após enviar a mensagem
    Future.delayed(const Duration(milliseconds: 150), () {
      if (!scroll.hasClients) return;
      scroll.animateTo(
        scroll.position.maxScrollExtent + 100,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  String hhmm(DateTime d) =>
      "${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFECE5DD),
      appBar: AppBar(
        backgroundColor: const Color(0xFF075E54),
        elevation: 0,
        titleSpacing: 0,
        title: Row(
          children: [
            const CircleAvatar(
              radius: 18,
              backgroundImage: AssetImage('assets/avatar.png'),
              backgroundColor: Colors.white,
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('Bruno',
                    style: TextStyle(fontSize: 18, color: Colors.white)),
                Text('online agora',
                    style: TextStyle(fontSize: 12, color: Color(0xFFE0F2F1))),
              ],
            ),
          ],
        ),
        actions: const [
          Icon(Icons.videocam, color: Colors.white),
          SizedBox(width: 16),
          Icon(Icons.call, color: Colors.white),
          SizedBox(width: 16),
          Icon(Icons.more_vert, color: Colors.white),
          SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // ---------------- MENSAGENS ----------------
          Expanded(
            child: ListView.builder(
              controller: scroll,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              itemCount: mensagens.length,
              itemBuilder: (context, i) {
                final m = mensagens[i];
                final me = m["me"] as bool;
                final txt = m["text"] as String;
                final time = m["time"] as DateTime;

                return Align(
                  alignment: me ? Alignment.centerRight : Alignment.centerLeft,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * .75,
                    ),
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      padding: const EdgeInsets.fromLTRB(12, 10, 12, 6),
                      decoration: BoxDecoration(
                        color: me
                            ? const Color(0xFFDFF8C6)
                            : Colors.white, // cores diferentes
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(16),
                          topRight: const Radius.circular(16),
                          bottomLeft: me
                              ? const Radius.circular(16)
                              : const Radius.circular(4),
                          bottomRight: me
                              ? const Radius.circular(4)
                              : const Radius.circular(16),
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x1A000000),
                            blurRadius: 3,
                            offset: Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              txt,
                              style: const TextStyle(
                                  fontSize: 16,
                                  height: 1.3,
                                  color: Colors.black87),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            hhmm(time),
                            style: TextStyle(
                                fontSize: 11, color: Colors.grey.shade600),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // ---------------- INPUT ----------------
          SafeArea(
            top: false,
            child: Container(
              color: const Color(0xFFECE5DD),
              padding: const EdgeInsets.fromLTRB(10, 6, 10, 10),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: const [
                          BoxShadow(
                              color: Color(0x11000000),
                              blurRadius: 2,
                              offset: Offset(0, 1))
                        ],
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.emoji_emotions_outlined,
                                color: Color(0xFF667781)),
                          ),
                          Expanded(
                            child: TextField(
                              controller: input,
                              minLines: 1,
                              maxLines: 4,
                              textInputAction: TextInputAction.newline,
                              decoration: const InputDecoration(
                                hintText: 'Mensagem',
                                border: InputBorder.none,
                              ),
                              onSubmitted: (_) => enviar(),
                            ),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.attach_file,
                                color: Color(0xFF667781)),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.camera_alt_outlined,
                                color: Color(0xFF667781)),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: enviar,
                    child: const CircleAvatar(
                      radius: 25,
                      backgroundColor: Color(0xFF075E54),
                      child: Icon(Icons.send, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
