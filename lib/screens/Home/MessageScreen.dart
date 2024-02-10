import 'package:flutter/material.dart';
import 'package:recicle/screens/Messages/MessageBox.dart';
import 'package:recicle/services/MessageService.dart';
import 'package:recicle/services/helper_function.dart';

class MessageScreen extends StatefulWidget {
  const MessageScreen({Key? key});

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  List<dynamic> conversations = [];
  bool haveGroup = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("recuperation de la liste des groupe du user");
    this.getAllGroup();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Message'),
      ),
      body: Center(
        child: !haveGroup
            ? const CircularProgressIndicator() // Show loading indicator if conversations are still loading
            : ListView.builder(
                itemCount: conversations.length,
                itemBuilder: (context, index) {
                  return MessageBox(
                    chatRoom: conversations[index],
                  );
                },
              ),
      ),
    );
  }

  getAllGroup() async {
    print("recuperation du uid");
    String? uid = await HelperFunction.getUserUIDSharedPreference();
    MessageService().getAllGroupsOfOneUser(uid!).then((value) {
      if (value.length == []) {
        print("aucun groupe trouver length 0");
        setState(() {
          haveGroup = !haveGroup;
        });
      } else { 
        setState(() {
          print("groupe trouver");
          conversations = value;
        });
      }
    });
  }
}
