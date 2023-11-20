// ignore_for_file: file_names

/*

import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class ChatScreen extends StatefulWidget {
  final String myName;
  final String otherName;

  const ChatScreen({Key? key, required this.myName, required this.otherName})
      : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<types.Message> _messages = [];
  final TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff164863),
        title: Text(widget.otherName),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return ListTile(
                  title: Text(message.author.firstName),
                  subtitle: Text(message.text),
                  trailing: Text(
                    // Formatea la hora del mensaje según tus necesidades.
                    DateTime.fromMillisecondsSinceEpoch(message.createdAt!)
                        .toString(),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: InputDecoration(
                      hintText: 'Type a message',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    _sendMessage(_textController.text);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage(String text) {
    // Aquí puedes enviar el mensaje al servidor o procesarlo según tus necesidades.
    final newMessage = types.TextMessage(
      author: types.User(id: '1', firstName: widget.myName),
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: text,
    );

    setState(() {
      _messages.add(newMessage);
      _textController.clear();
    });
  }
}

void main() {
  runApp(
    MaterialApp(
      home: ChatScreen(myName: 'TuNombre', otherName: 'NombreAmigo'),
    ),
  );
}

*/