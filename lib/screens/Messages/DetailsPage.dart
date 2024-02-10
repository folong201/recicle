import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:recicle/services/MessageService.dart';
import 'package:recicle/services/helper_function.dart';

class MessageDetailsPage extends StatefulWidget {
  String? senderuid;
  String? receiveruid;
  var chatRoom;
  MessageDetailsPage({this.senderuid, this.receiveruid, this.chatRoom});
  @override
  _MessageDetailsPageState createState() => _MessageDetailsPageState();
}

class _MessageDetailsPageState extends State<MessageDetailsPage> {
  MessageService messageService = MessageService();

  TextEditingController messageController = TextEditingController();
  ScrollController scrollController = ScrollController();

  void sendMessage() async {
    String message = messageController.text;
    bool ok = await messageService.sendMessage(
        widget.senderuid, widget.receiveruid, widget.chatRoom.id, message);
    if (ok) {
      setState(() {
        messageController.clear();
        if (scrollController.hasClients) {
          scrollController.jumpTo(scrollController
              .position.maxScrollExtent); // Scroll to the bottom
        }
      });
    }
  }

  setParams() async {
    widget.senderuid = await HelperFunction.getUserUIDSharedPreference()!;
    widget.receiveruid = widget.chatRoom['members'][0] == widget.senderuid
        ? widget.chatRoom['members'][1]
        : widget.chatRoom['members'][0];
  }

  Stream<QuerySnapshot> getMessages(groupId) {
    CollectionReference messages =
        FirebaseFirestore.instance.collection('messages');
    return messages
        .where('groupId', isEqualTo: groupId)
        .orderBy('timestamp')
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Détails de la discussion'),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: getMessages(
                  widget.chatRoom.id), // Pass the group ID to getMessages
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    controller: scrollController, // Assign scroll controller
                    itemCount: snapshot.data?.docs.length,
                    itemBuilder: (context, index) {
                      var message = snapshot.data!.docs[index].data()
                          as Map<String, dynamic>;
                      if (message != null) {
                        return Align(
                          alignment: message['sender'] == widget.senderuid
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Container(
                            margin: EdgeInsets.symmetric(vertical: 4.0),
                            padding: EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              color: message['sender'] == widget.senderuid
                                  ? Colors.blue[100]
                                  : Colors.grey[300],
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Text(message['message']),
                          ),
                        );
                      } else {
                        return Container(); // Return an empty container if message is null
                      }
                    },
                  );
                } else if (snapshot.hasError) {
                  return Text("Error: ${snapshot.error}");
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: InputDecoration(
                      hintText: 'Saisissez votre message',
                    ),
                  ),
                ),
                SizedBox(width: 8.0),
                ElevatedButton(
                  onPressed: sendMessage,
                  child: Text('Envoyer'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
