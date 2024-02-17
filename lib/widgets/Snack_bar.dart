import 'package:flutter/material.dart';

class SnackBarWidget {
  static showSnackBar(context, message) {
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erreur lors de l\'enregistrement du message')));
  }
}
