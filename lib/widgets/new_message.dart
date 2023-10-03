import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NewMessages extends StatefulWidget {
  const NewMessages({super.key});

  @override
  State<NewMessages> createState() => _NewMessagesState();
}

class _NewMessagesState extends State<NewMessages> {
  final _messagesController = TextEditingController();
  @override
  void dispose() {
    _messagesController.dispose();
    super.dispose();
  }

  void _submitMessages() async {
    final entredMessage = _messagesController.text;
    if (entredMessage.trim().isEmpty) {
      return;
    }
    FocusScope.of(context).unfocus();
    _messagesController.clear();
    final user = FirebaseAuth.instance.currentUser!;
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();
    FirebaseFirestore.instance.collection('chat').add({
      'text': entredMessage,
      'createdAt': Timestamp.now(),
      'userId': user.uid,
      'username': userData.data()!['username'],
      'userImage': userData.data()!['image_url']
    });

    
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16, right: 1, left: 15),
      child: Row(
        children: [
          Expanded(
              child: TextField(
            controller: _messagesController,
            textCapitalization: TextCapitalization.sentences,
            autocorrect: true,
            enableSuggestions: true,
            decoration: const InputDecoration(
              label: Text('Send a message...'),
            ),
          )),
          IconButton(onPressed: _submitMessages, icon: const Icon(Icons.send))
        ],
      ),
    );
  }
}
