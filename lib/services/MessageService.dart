import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

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
      // print("message non envoyé");

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

  //recuperer ou creer un groupe

  Future<DocumentReference> getOrCreateGroup(List<String> userIds) async {
    print("recuperation de tout les groupes");
    final groupsSnapshot =
        await FirebaseFirestore.instance.collection('groups').get();
    final matchingGroups = groupsSnapshot.docs.where((doc) {
      final members = List<String>.from(doc['members']);
      members.sort();
      final sortedUserIds = List<String>.from(userIds)..sort();
      return listEquals(members, sortedUserIds);
    });
    if (matchingGroups.isNotEmpty) {
      // Groupe trouvé, retourner le premier groupe correspondant
      print("groupe trouve");
      return matchingGroups.first.reference;
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
          userList.add(userDoc['uid']);
        } else {
          print('Utilisateur avec UID  introuvable.');
        }
      }
      var groupName = userDocs[0]!['uid'] +
          '_' +
          userDocs[0]!['email'] +
          ' & ' +
          userDocs[0]!['uid'] +
          "_" +
          userDocs[1]!['email'];
      // Aucun groupe trouvé, créer un nouveau groupe
      return FirebaseFirestore.instance.collection('groups').add({
        'members': userList,
        'latestMessage': 'latest message here',
        'name': groupName,
        // 'users': userDocs,
      });
    }
  }

//recuperer tout les groupes d'un utilisateur
  Future getAllGroupsOfOneUser(String uid) async {
    // print("Récupération de tous les groupes de l'utilisateur $uid");

    // Requête Firestore pour obtenir tous les groupes où l'utilisateur est membre
    final groupsSnapshot = await FirebaseFirestore.instance
        .collection('groups')
        .where('members', arrayContainsAny: [uid]).get();

    // Si des groupes ont été trouvés
    if (groupsSnapshot.docs.isNotEmpty) {
      // print("Liste des groupes trouvée pour $uid");
      // Parcourir les documents et retourner une liste de Maps
      //boucle sur les groupes et aficher les nom et les id
      for (var group in groupsSnapshot.docs) {
        // print('Groupe : ${group['name']}, ID : ${group.id}');
      }
      return groupsSnapshot.docs;
    } else {
      // print("Aucun groupe trouvé pour $uid");
      // Retourner un tableau vide
      return [];
    }
  }

  getGroupNameByuserId(OriginalName, authUserId) {
    var user1 = OriginalName.split('&')[0];
    var user2 = OriginalName.split('&')[1];
    if (user1 == authUserId) {
      return user1.plit('_')[1];
    } else {
      return user2.split('_')[1];
    }
  }
}
