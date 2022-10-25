import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import '../constants.dart';

final _firestore = FirebaseFirestore.instance;
late User loggedInUser;

class ChatScreen extends StatefulWidget {
  static const String id = 'chat_screen';

  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController messageTextController = TextEditingController();
  late String user;
  final _auth = FirebaseAuth.instance;
  late String messageText;

  // void inputData() {
  //   final User user = _auth.loggedInUser;
  //   final uid = user.uid;
  //   // here you write the codes to input the data into firestore
  // }
  // late var myVariable = messageText as Map;
  @override
  void initState(){
    super.initState();
    getCurrentUser();
    // Firebase.initializeApp().whenComplete(() {
    //   print("completed");
    //   setState(() {});
    // });
  }

  Future<void> getCurrentUser() async {
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        print(loggedInUser.email);
      }
    } catch (e) {
      print(e);
    }
  }

  //future
  // void getMessages() async {
  //    final messages = await _firestore.collection('messages').get();
  //    for (var message in messages.docs){
  //      print(message.data());
  //    }
  // }
  //
  //stream
  // void messagesStream() async {
  //   await for (var snapshot in _firestore.collection('messages').snapshots()) {
  //     for (var message in snapshot.docChanges) {
  //       print(message.doc);
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                // messagesStream(); stream function
                _auth.signOut();
                Navigator.pop(context);
                //Implement logout functionality
              }),
        ],
        title: const Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const MessagesStream(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageTextController,
                      onChanged: (value) {
                        messageText = value;
                        //Do something with the user input.
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                        messageTextController.clear();
                        _firestore.collection('messages').add({
                          'text': messageText,
                          'sender': loggedInUser.email,
                      });
                        setState(() {});
                      //Implement send functionality.
                    },
                    child: const Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessagesStream extends StatefulWidget {
  const MessagesStream({Key? key}) : super(key: key);

  @override
  State<MessagesStream> createState() => _MessagesStreamState();
}

class _MessagesStreamState extends State<MessagesStream> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('messages').snapshots(),
      builder: (context, snapshot){
        if(!snapshot.hasData){
          return const Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }//QuerySnapshot<Object?> documentData = snapshot.data!;
        //here there is a problem need correct it at time msgs disappearing
        final messages = snapshot.data?.docChanges.reversed;
        List<MessageBubble> messageBubbles = [];
        for(var message in messages!){
          final messageText = message.doc['text'];
          final messageSender = message.doc['sender'];

          final currentUser = loggedInUser.email;

          if(currentUser == messageSender){
            //the message from the logged in user,
          }

          final messageBubble = MessageBubble(sender: messageSender,
              text: messageText,
            isMe: currentUser == messageSender,);

          messageBubbles.add(messageBubble);
        }
        return Expanded(
          child: ListView(
            reverse: true,
            padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 20.0),
            children: messageBubbles,
          ),
        );
      },
    );
  }
}


class MessageBubble extends StatelessWidget {
  const MessageBubble({Key? key, required this.sender, required this.text, required this.isMe}) : super(key: key);

  final String sender;
  final String text;
   final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: isMe? CrossAxisAlignment.end:CrossAxisAlignment.start,
        children: [
          Text(sender,
          style: const TextStyle(
            fontSize: 12.0,
            color: Colors.black54,
          ),),
          Material(
            borderRadius:
            isMe? const BorderRadius.only(
                topLeft: Radius.circular(30.0),
                bottomLeft: Radius.circular(30.0),
              bottomRight: Radius.circular(30.0)):
                const BorderRadius.only(
                    bottomLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0),
                  topRight: Radius.circular(30.0)
                ),
            elevation: 5.0,
            color: isMe? Colors.lightBlueAccent: Colors.white ,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 20.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

//
// class MessagesStream extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<QuerySnapshot>(
//       stream: _firestore.collection('messages').snapshots(),
//       builder: (context, snapshot) {
//         if (!snapshot.hasData) {
//           return Center(
//             child: CircularProgressIndicator(
//               backgroundColor: Colors.lightBlueAccent,
//             ),
//           );
//         }
//         final messages = snapshot.data.documents.reversed;
//         List<MessageBubble> messageBubbles = [];
//         for (var message in messages) {
//           final messageText = message.data['text'];
//           final messageSender = message.data['sender'];
//
//           final currentUser = loggedInUser.email;
//
//           final messageBubble = MessageBubble(
//             sender: messageSender,
//             text: messageText,
//             isMe: currentUser == messageSender,
//           );
//
//           messageBubbles.add(messageBubble);
//         }
//         return Expanded(
//           child: ListView(
//             reverse: true,
//             padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
//             children: messageBubbles,
//           ),
//         );
//       },
//     );
//   }
// }
//dummy
// Future<void> getCurrentUser() async {
//   final User? user =  await _auth.currentUser;
//   final uid = user?.uid;
//   print(user?.email);
//   // here you write the codes to input the data into firestore
// }
// Future<void> getCurrentUser() async {
//   try{
//   final user = await _auth.currentUser;
//   var uid = user?.uid;
//   if(user != null) {
//     uid = user as String ;
//     print(user.email);
//   }} catch (e){
//     print(e);
//   }
// }