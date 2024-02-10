class Message {
  String sender;
  String receiver;
  DateTime date;
  String heure;
  String groupeId;
  String content;
  String type;

  Message({
    required this.sender,
    required this.receiver,
    required this.date,
    required this.heure,
    required this.groupeId,
    required this.content,
    required this.type,
  });

  void sendMessage() {
    // Logique pour envoyer le message
  }

  void receiveMessage() {
    // Logique pour recevoir le message
  }

  void deleteMessage() {
    // Logique pour supprimer le message
  }

  // Autres méthodes relatives au message

}
