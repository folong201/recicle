import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:recicle/screens/Messages/DetailsPage.dart';
import 'package:recicle/services/MessageService.dart';
import 'package:recicle/services/helper_function.dart';

class UserService {
  static void messageOwner(context, String productOwner) async {
    String? uid = await HelperFunction.getUserUIDSharedPreference()!;
    print("uid: $uid");
    print("productOwner: $productOwner");
    if (uid != null && productOwner != FirebaseAuth.instance.currentUser!.uid) {
      print("requette chatroom");
      var chatRoom =
          await MessageService().getOrCreateGroup([uid, productOwner]);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => MessageDetailsPage(chatRoom: chatRoom)));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Vous ne pouvez pas envoyer de message à vous-même'),
          duration: const Duration(seconds: 3),
          
        ),
      );
    }
  }

  Future<void> updateProfile(String displayName) async {
    User? user = FirebaseAuth.instance.currentUser;
    await user!.updateDisplayName(displayName);
  }

  Future<void> updateEmail(String email) async {
    User? user = FirebaseAuth.instance.currentUser;
    await user!.updateEmail(email);
  }
}
