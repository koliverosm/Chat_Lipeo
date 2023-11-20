// ignore_for_file: non_constant_identifier_names, avoid_print, unused_element, unused_import

import 'dart:convert';
import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
//import 'package:web_socket_client/web_socket_client.dart';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as status;

class ChatPage extends StatefulWidget {
  const ChatPage({
    Key? key,
    required this.iduser,
    required this.myname,
    required this.myphone,
    required this.Otherid,
    required this.Othername,
    required this.Otherphone,
    required this.idconversation,
  }) : super(key: key);
  final String iduser;
  final String myname;
  final String myphone;
  final String Otherid;
  final String Othername;
  final String Otherphone;
  final String idconversation;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  /* final socket =
      WebSocket(Uri.parse('ws://10.0.1.2:8080')); */ // Aqui LLama Al Socket
  final WebSocketChannel channel = IOWebSocketChannel.connect(
      'wss://socket-server-lipeo-15f0a5c07d6e.herokuapp.com');
  /////////////////////////////////////////////

  final List<types.Message> _messages = [];
  late types.User otherUser;
  late types.User me;
//////////////////////////////////////////////////////
  ///
  ///
  ///

  @override
  void initState() {
    super.initState();

    // Imprime un mensaje en la consola con el ID de la conversación.
    print('Estoy en el chat ID CONVERSACION: ${widget.idconversation}');

    _loadMessage(widget.idconversation);

    // Inicializa los usuarios (otherUser y me).
    otherUser = types.User(id: widget.Otherphone, firstName: widget.Othername);
    me = types.User(id: widget.myphone, firstName: widget.myname);
    print('DATOS MIOS: NOMBRE: ${widget.myname} -- TELEFONO ${widget.myphone}');
    print(
        'DATOS CONTACTO: NOMBRE: ${widget.Othername} -- TELEFONO ${widget.Otherphone}');

    ///////////////CONEXION DEL SOCKET//////////////////
    ///
    channel.stream.listen((message) {
      List<String> parts = message.split(' from ');
      //channel.sink.add('received!');
      if (parts.length == 2) {
        String jsonString = parts[0];
        print('Mensaje: $jsonString');
        try {
          onMessageReceived(jsonString);
        } catch (e) {
          print('Error al analizar JSON: $e');
        }
      } else {
        print('Estas : $message');
      }
      // channel.sink.close(status.goingAway);
    });

    /*  socket.messages.listen((incomingMessage) {
      List<String> parts = incomingMessage.split(' from ');

      if (parts.length == 2) {
        String jsonString = parts[0];
        print('Mensaje: $jsonString');
        try {
          onMessageReceived(jsonString);
        } catch (e) {
          print('Error al analizar JSON: $e');
        }
      } else {
        print('Formato de mensaje no esperado: $incomingMessage');
      }
    });*/
    /////////////////END CONEXIOn/////////////
  }
////////////////AQUI CIERRA EL VOID ///////////////

////////////////////////Este Es El Chat////////////////////////////////
  final TextEditingController _textEditingController =
      TextEditingController(); //focus para cerrar conexion
  bool isSendButtonEnabled = false;
///////////////////////////////////7
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(' ${widget.Othername} '),
      ),
      body: Column(
        children: [
          Expanded(
            child: Chat(
              onSendPressed: _handleSendPressed,
              user: me,
              messages: _messages,
              theme: DefaultChatTheme(
                  backgroundColor: Theme.of(context).dialogBackgroundColor),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    channel.sink.close();
    print('Servidor Cerrado');
    super.dispose();
  }

///////////////////

  ////////////////////////////////////////

  Widget _buildChatInput() {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _textEditingController,
              onChanged: (text) {
                setState(() {
                  isSendButtonEnabled = text.trim().isNotEmpty;
                });
              },
              decoration: const InputDecoration(
                hintText: 'Escribe tu mensaje...',
              ),
            ),
          ),
        ],
      ),
    );
  }

/////////////////////////////////////////////////////////
////////////////////////randomString()///////////////////////////////////////////////
  String randomString() {
    final random = Random.secure();
    final values = List<int>.generate(16, (i) => random.nextInt(255));
    return base64UrlEncode(values);
  }

//////////////////////////Void on MessageReceiver////////////////////////////////////////////

  void onMessageReceived(String message) {
    try {
      Map<String, dynamic> data = jsonDecode(message);

      // Verifica si la estructura del mensaje es la esperada
      if (data.containsKey('id') &&
          data.containsKey('msg') &&
          data.containsKey('timestamp')) {
        print("Estoy Mirando La Data $data");

        var newMessage = types.TextMessage(
          author: otherUser,
          id: randomString().toString(),
          text: data['msg'],
          createdAt: DateTime.now().millisecondsSinceEpoch,
        );

        // Agrega el nuevo mensaje a tu lista o realiza la acción necesaria
        _addMessage(newMessage);
      } else {
        print('Formato de mensaje JSON no esperado: $message');
      }
    } catch (e) {
      print('Error al analizar JSON del mensaje: $e');
    }
  }

/////////////////////////////////////////////////////////

  void _addMessage(types.Message message) {
    //este es el metodo que imprime lo que esta e la caja de texto ala parte del chat
    setState(() {
      _messages.insert(0, message);
    });
  }

  /////////////////////////////////////////////////

  void _handleSendPressed(types.PartialText message) {
    final textMessage = types.TextMessage(
      author: me,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: randomString().toString(),
      text: message.text,
    );

    var payload = {
      //Este es json que se va a mandar al socket con los datos del usuario de la app
      'id': me.id, // obtiene su ID atravez del me
      'msg': message.text, // este mensaje viene atravez de la funcion
      'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
    };

    channel.sink.add(json.encode(payload)); //manda la data al socket
    // channel.sink.close(status.goingAway);
    ///

    mandarmensajes(widget.idconversation, widget.iduser, message.text);
    //se van los mensajes al servidor en la nube

    _addMessage(textMessage); // carga el mensaje en la pantalla del chat
  }

  ///////////////////isSendButtonEnabled = false;//////////////////////////////

  Future<void> _loadMessage(String conversationId) async {
    print('Verificar Que ID Entra en La petición POST $conversationId');

    const String url =
        'https://api-chat-lipeo-7ed91d26c81f.herokuapp.com/usuarios/buscar_conversacion';

    final Map<String, dynamic> datosUsuario = {
      "idconversacion": conversationId
    };

    final String jsonDatosUsuario = jsonEncode(datosUsuario);

    try {
      final response = await http.post(
        Uri.parse(url),
        body: jsonDatosUsuario,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);
        print('Llegaron ${responseData.length} Mensajes De Esta Conversacion');

        for (var messageData in responseData) {
          final String content = messageData['content'];
          final String fecha1 = messageData['date'];
          final String phone = messageData['phone'];
          //final int id = messageData['id'];
          //DateTime timestamp = DateTime.parse(fecha1);
          //int fecha = timestamp.millisecondsSinceEpoch;
          // var createdAt = DateTime.parse(fecha).millisecondsSinceEpoch;
          //  print('ID: $id -- PHONE: $phone -- CONTENIDO: $content -- FECHA: $fecha1');

          var newMessage = types.TextMessage(
            author: (phone == me.id) ? me : otherUser,
            id: randomString().toString(),
            text: content,
            createdAt: DateTime.parse(fecha1).millisecondsSinceEpoch,
          );

          // Agregamos el nuevo mensaje a la lista
          _addMessage(newMessage);
        }
      } else {
        print('No Hay Mensajes En Esta Conversacion: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}

Future<void> mandarmensajes(
    String idconversacion, String idremitente, String message) async {
  const String url =
      'https://api-chat-lipeo-7ed91d26c81f.herokuapp.com/usuarios/crear_message';
  print(
      'ID:$idconversacion -- IDREMITENTE: $idremitente -- MENSAJE: $message ');
  final Map<String, dynamic> datosUsuario = {
    "idconversacion": idconversacion,
    "idremitente": idremitente,
    "message": message
  };

  final String jsonDatosUsuario = jsonEncode(datosUsuario);

  try {
    final response = await http.post(
      Uri.parse(url),
      body: jsonDatosUsuario,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> responseData = json.decode(response.body);
      print('Respuesta: ${responseData.length} ');
    } else {}
  } catch (e) {
    print('Error: $error');
  }
  await Future.delayed(const Duration(seconds: 3));
}
