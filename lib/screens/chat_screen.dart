// import 'package:flutter/material.dart';
// import 'package:movflix/screens/community.dart'; // Import the Group List Page
//
// class CommunityForumScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Community Forum")),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => GroupListPage()), // Navigate to Group List
//             );
//           },
//           child: Text("Join a Community Group"),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class ChatScreen extends StatefulWidget {
  final String groupId;
  final String groupName;

  ChatScreen({required this.groupId, required this.groupName});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final DatabaseReference _messagesRef = FirebaseDatabase.instance.ref().child('messages');
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(widget.groupName),
        backgroundColor: Colors.redAccent,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: _messagesRef.child(widget.groupId).onValue,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator(color: Colors.redAccent));
                }

                if (!snapshot.hasData || snapshot.data?.snapshot.value == null) {
                  return Center(child: Text("No messages yet", style: TextStyle(color: Colors.white70)));
                }

                Map<dynamic, dynamic> messages = snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
                List messageList = messages.entries.toList();
                messageList.sort((a, b) => a.value['timestamp'].compareTo(b.value['timestamp']));

                return ListView.builder(
                  itemCount: messageList.length,
                  padding: EdgeInsets.all(12),
                  itemBuilder: (context, index) {
                    String message = messageList[index].value['message'];
                    String sender = messageList[index].value['sender'];
                    bool isMe = _auth.currentUser?.email == sender;

                    return Align(
                      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 6),
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isMe ? Colors.redAccent : Colors.grey[800],
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(sender, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white60)),
                            SizedBox(height: 5),
                            Text(message, style: TextStyle(fontSize: 16, color: Colors.white)),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Enter message...",
                hintStyle: TextStyle(color: Colors.white60),
                filled: true,
                fillColor: Colors.grey[900],
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
              ),
            ),
          ),
          SizedBox(width: 10),
          IconButton(
            icon: Icon(Icons.send, color: Colors.redAccent),
            onPressed: _sendMessage,
          ),
        ],
      ),
    );
  }

  void _sendMessage() {
    if (_messageController.text.trim().isNotEmpty) {
      _messagesRef.child(widget.groupId).push().set({
        'message': _messageController.text.trim(),
        'sender': _auth.currentUser?.email,
        'timestamp': DateTime.now().toIso8601String(),
      });
      _messageController.clear();
    }
  }
}
