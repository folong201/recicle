import 'package:cloud_firestore/cloud_firestore.dart';

class MessageService {
  final String? uid;
  MessageService({this.uid});
  final CollectionReference messages =
      FirebaseFirestore.instance.collection('messages');
  final CollectionReference groups =
      FirebaseFirestore.instance.collection('groups');
  Future sendMessage(senderuid, receiveruid, groupId, message) async {
    try {
      messages.add({
        'sender': senderuid,
        'receiver': receiveruid,
        'groupId': groupId,
        'message': message,
        'timestamp': FieldValue.serverTimestamp(),
      });
      print("message envoyé");

      return true;
    } catch (e) {
      print("message non envoyé");

      print(e.toString());
      return false;
    }
  }

  Stream<QuerySnapshot> getMessages(groupId) {
    CollectionReference messages =
        FirebaseFirestore.instance.collection('messages');
    return messages
        .where('groupId', isEqualTo: groupId)
        .orderBy('timestamp')
        .snapshots();
  }

  Stream<QuerySnapshot> getGroupsUserGroup() {
    return groups.where('members', arrayContains: uid).snapshots();
  }

  Future createGroup(groupName, members) async {
    // Vérifier s'il y a déjà un groupe avec les mêmes membres
    groups
        .where('members', arrayContains: members)
        .get()
        .then((QuerySnapshot querySnapshot) {
      if (querySnapshot.docs.isEmpty) {
        // Aucun groupe trouvé, créer un nouveau groupe
        groups.add({
          'name': "group Name",
          'members': members,
          'latestMessage': 'latest message here',
        });
      } else {
        // Un groupe avec les mêmes membres existe déjà
        print('Un groupe avec les mêmes membres existe déjà');
      }
    });
  }

// Recuperer un groupe a partir de deux utilisateur ou en creer s'il n'existe pas
  Future<DocumentReference> getOrCreateGroup(List<String> userIds) async {
    print("recuperation de tout les groupes");
    final groupsSnapshot = await FirebaseFirestore.instance
        .collection('groups')
        .where('members', arrayContainsAny: userIds)
        .get();

    if (groupsSnapshot.docs.isNotEmpty) {
      // Groupe trouvé, retourner le premier groupe correspondant
      print("aucun groupe trouve");
      return groupsSnapshot.docs.first.reference;
    } else {
      //recuperer les utilisateur a traver leur id
      print("recuperation des deux participants");
      final userDocs = await Future.wait(
        userIds.map((userId) => FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .get()
            .then((userDoc) => userDoc.data())),
      );

      // Afficher la liste des utilisateurs
      var userList = [];
      for (var userDoc in userDocs) {
        if (userDoc != null) {
          // print(
          //     'Utilisateur : ${userDoc['name']} ${userDoc['name']}, UID : ${userDoc['uid']}}');
          userList.add(userDoc['uid']);
        } else {
          print('Utilisateur avec UID  introuvable.');
        }
      }

      // Aucun groupe trouvé, créer un nouveau groupe
      return FirebaseFirestore.instance.collection('groups').add({
        'members': userList,
        'latestMessage': 'latest message here',
        'name': 'groupe Name',
      });
    }
  }

//recuperer tout les groupes d'un utilisateur
  Future getAllGroupsOfOneUser(String uid) async {
    print("Récupération de tous les groupes de l'utilisateur $uid");

    // Requête Firestore pour obtenir tous les groupes où l'utilisateur est membre
    final groupsSnapshot = await FirebaseFirestore.instance
        .collection('groups')
        .where('members', arrayContainsAny: [uid]).get();

    // Si des groupes ont été trouvés
    if (groupsSnapshot.docs.isNotEmpty) {
      print("Liste des groupes trouvée pour $uid");
      // Parcourir les documents et retourner une liste de Maps
      //boucle sur les groupes et aficher les nom et les id
      for (var group in groupsSnapshot.docs) {
        print('Groupe : ${group['name']}, ID : ${group.id}');
      }
      return groupsSnapshot.docs;
    } else {
      print("Aucun groupe trouvé pour $uid");
      // Retourner un tableau vide
      return [];
    }
  }
}
