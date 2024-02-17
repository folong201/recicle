import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String email = '';
  final user = FirebaseAuth.instance.currentUser;
  String displayName = '';
  String phone = '';
  String photo = '';
  bool isLoading = false;

  void updateEmail(String newEmail) {
    setState(() {
      email = newEmail;
    });
  }

  void updateDisplayName(String newDisplayName) {
    setState(() {
      displayName = newDisplayName;
    });
  }

  void updatePhone(String newPhone) {
    setState(() {
      phone = newPhone;
    });
  }

  void updatePhoto(String newPhoto) {
    setState(() {
      photo = newPhoto;
    });
  }

  void resetPassword() {
    setState(() {
      isLoading = true;
    });

    // Simulating an asynchronous operation
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        isLoading = false;
      }); 
    });
  }

  updateInfo() async {
    setState(() {
      isLoading = true;
    });
    await user!.updateEmail(email);
    await user!.updateDisplayName(displayName);
    await user!.updatePhotoURL(photo);
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("SettingsScreen"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  "SettingsScreen",
                  style: TextStyle(
                    fontSize: 30,
                  ),
                ),
                TextField(
                  onChanged: (value) => updateEmail(value),
                  decoration: const InputDecoration(
                    labelText: 'Email',
                  ),
                ),
                TextField(
                  onChanged: (value) => updateDisplayName(value),
                  decoration: const InputDecoration(
                    labelText: 'Display Name',
                  ),
                ),
                ElevatedButton(
                  onPressed: isLoading ? null : updateInfo,
                  child: const Text('Update'),
                ),
                const SizedBox(height: 16),
                if (isLoading) const CircularProgressIndicator(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
