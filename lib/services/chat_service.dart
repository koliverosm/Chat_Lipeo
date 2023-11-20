 /* import 'package:http/http.dart' as http;
  import 'dart:convert';
import 'dart:async';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
  class Chat_Service{
  
  Future<void> _loadMessage(String conversationId) async {
    print('Verificar Que ID Entra en La petición POST $conversationId');

    const String url = 'http://192.168.1.2:5000/usuarios/buscar_conversacion';

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
          final int id = messageData['id'];
          //DateTime timestamp = DateTime.parse(fecha1);
          //int fecha = timestamp.millisecondsSinceEpoch;
          // var createdAt = DateTime.parse(fecha).millisecondsSinceEpoch;
          print(
              'ID: $id -- PHONE: $phone -- CONTENIDO: $content -- FECHA: $fecha1');

          var newMessage = types.TextMessage(
            author: (phone == me.id) ? me : otherUser,
            id: '$id',
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

  Future<void> mandarmensajes(
    String idconversacion, String idremitente, String message) async {
  const String url = 'http://192.168.1.2:5000/usuarios/crear_message';
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
}



*/