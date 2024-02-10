class Group {
  String id;
  List<String> users;
  String lastMessage;
  List<String> messages;

  Group({
    required this.id,
    required this.users,
    required this.lastMessage,
    required this.messages,
  });

  void addUser(String user) {
    users.add(user);
  }

  void removeUser(String user) {
    users.remove(user);
  }

  void updateLastMessage(String message) {
    lastMessage = message;
  }

  void addMessage(String message) {
    messages.add(message);
  }

  void removeMessage(String message) {
    messages.remove(message);
  }
}
