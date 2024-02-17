import 'package:cloud_firestore/cloud_firestore.dart';
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
  bool isLoading = true;
  Map<String, String> groupname = {};
  String? uid = '';

  @override
  void initState() { 
    super.initState();
    // print("recuperation de la liste des groupe du user");
    getAllGroup();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Message'),
      ),
      body: Center(
        child: !haveGroup || isLoading
            ? const CircularProgressIndicator() // Show loading indicator if conversations are still loading
            : ListView.builder(
                itemCount: conversations.length,
                itemBuilder: (context, index) {
                  return conversations[index] != null ? MessageBox(
                    chatRoom: conversations[index]!,
                  ) : Container();
                },
              ),
      ),
    );
  }

  getAllGroup() async {
    // print("recuperation du uid");
    String? uik = await HelperFunction.getUserUIDSharedPreference();
    setState(() {
      uid = uik;
    });
    MessageService().getAllGroupsOfOneUser(uid!).then((value) async {
      if (value.isEmpty) { // Use isEmpty instead of comparing to []
        // print("aucun groupe trouver length 0");
        setState(() {
          haveGroup = false; // Update haveGroup to false
          isLoading = false; // Update isLoading to false
        });
      } else {
        // print("groupe trouver");
       
        setState(() {
          conversations = value;
          isLoading = false; // Update isLoading to false
        }); 
      }
    });
  }
}
