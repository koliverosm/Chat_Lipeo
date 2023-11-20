class Message {
  final String idconversacion;
  final String idremitente;
  final String message;
  final DateTime timestamp;

  Message(
      {required this.idconversacion,
      required this.idremitente,
      required this.message,
      required this.timestamp});

  Map<String, dynamic> toMap() {
    return {
      "idconversacion": idconversacion,
      "idremitente": idremitente,
      "message": message
    };
  }
}
