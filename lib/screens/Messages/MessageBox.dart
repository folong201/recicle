import 'package:flutter/material.dart';
import 'package:recicle/screens/Messages/DetailsPage.dart';
import 'package:recicle/services/MessageService.dart';
import 'package:recicle/services/helper_function.dart';

class MessageBox extends StatefulWidget {
  var chatRoom;

  MessageBox({required this.chatRoom});

  @override
  State<MessageBox> createState() => _MessageBoxState();
}

class _MessageBoxState extends State<MessageBox> {
  String? uid;
  getUserId() async {
    String? ui = await HelperFunction.getUserUIDSharedPreference();
    setState(() {
      uid = ui;
    });
  }

  @override
  void initState() {
    super.initState();
    getUserId();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    MessageDetailsPage(chatRoom: widget.chatRoom)));
      },
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Container(
          padding: EdgeInsets.all(06),
          decoration: BoxDecoration(
            color: Colors.black54,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    MessageService()
                        .getGroupNameByuserId(widget.chatRoom['name'], uid!),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.chatRoom[
                        "latestMessage"], // Remplacer par le dernier message
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              // const Text(
              //   "Date et heure", // Remplacer par la date et l'heure du dernier message
              //   style: TextStyle(
              //     color: Colors.white,
              //     fontSize: 14,
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
