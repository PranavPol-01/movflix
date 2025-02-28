// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_database/firebase_database.dart';
// // import 'ChatScreen.dart'; // Import ChatScreen
//
// class GroupListPage extends StatefulWidget {
//   @override
//   _GroupListPageState createState() => _GroupListPageState();
// }
//
// class _GroupListPageState extends State<GroupListPage> {
//   final DatabaseReference _groupsRef = FirebaseDatabase.instance.ref().child('groups');
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Community Groups"),
//         backgroundColor: Colors.redAccent,
//       ),
//       body: StreamBuilder(
//         stream: _groupsRef.onValue,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           }
//
//           if (!snapshot.hasData || snapshot.data?.snapshot.value == null) {
//             return Center(child: Text("No groups available"));
//           }
//
//           Map<dynamic, dynamic> groups = snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
//           List groupList = groups.entries.toList();
//
//           return ListView.builder(
//             itemCount: groupList.length,
//             itemBuilder: (context, index) {
//               String groupId = groupList[index].key;
//               String groupName = groupList[index].value['name'];
//
//               return Card(
//                 elevation: 3,
//                 margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//                 child: ListTile(
//                   leading: Icon(Icons.group, color: Colors.redAccent),
//                   title: Text(groupName, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//                   trailing: ElevatedButton(
//                     style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
//                     onPressed: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => ChatScreen(groupId: groupId, groupName: groupName),
//                         ),
//                       );
//                     },
//                     child: Text("Join"),
//                   ),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         backgroundColor: Colors.redAccent,
//         onPressed: () => _showCreateGroupDialog(context),
//         child: Icon(Icons.add),
//       ),
//     );
//   }
//
//   void _showCreateGroupDialog(BuildContext context) {
//     TextEditingController groupNameController = TextEditingController();
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text("Create New Group"),
//           content: TextField(
//             controller: groupNameController,
//             decoration: InputDecoration(hintText: "Enter group name"),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: Text("Cancel"),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 _createGroup(groupNameController.text.trim());
//                 Navigator.pop(context);
//               },
//               child: Text("Create"),
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   void _createGroup(String groupName) {
//     if (groupName.isNotEmpty) {
//       String groupId = _groupsRef.push().key!;
//       _groupsRef.child(groupId).set({
//         'name': groupName,
//         'messages': {} // Initialize messages structure
//       }).then((_) {
//         print("Group created successfully");
//       }).catchError((error) {
//         print("Error creating group: $error");
//       });
//     }
//   }
// }
//
//
//
//
// class ChatScreen extends StatefulWidget {
//   final String groupId;
//   final String groupName;
//
//   ChatScreen({required this.groupId, required this.groupName});
//
//   @override
//   _ChatScreenState createState() => _ChatScreenState();
// }
//
// class _ChatScreenState extends State<ChatScreen> {
//   final DatabaseReference _messagesRef = FirebaseDatabase.instance.ref().child('messages');
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final TextEditingController _messageController = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.groupName),
//         backgroundColor: Colors.redAccent,
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: StreamBuilder(
//               stream: _messagesRef.child(widget.groupId).onValue,
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return Center(child: CircularProgressIndicator());
//                 }
//
//                 if (!snapshot.hasData || snapshot.data?.snapshot.value == null) {
//                   return Center(child: Text("No messages yet"));
//                 }
//
//                 Map<dynamic, dynamic> messages = snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
//                 List messageList = messages.entries.toList();
//                 messageList.sort((a, b) => a.value['timestamp'].compareTo(b.value['timestamp']));
//
//                 return ListView.builder(
//                   itemCount: messageList.length,
//                   itemBuilder: (context, index) {
//                     String message = messageList[index].value['message'];
//                     String sender = messageList[index].value['sender'];
//                     bool isMe = _auth.currentUser?.email == sender;
//
//                     return Align(
//                       alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
//                       child: Container(
//                         margin: EdgeInsets.symmetric(vertical: 4, horizontal: 16),
//                         padding: EdgeInsets.all(10),
//                         decoration: BoxDecoration(
//                           color: isMe ? Colors.redAccent : Colors.grey[300],
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               sender,
//                               style: TextStyle(
//                                 fontSize: 12,
//                                 fontWeight: FontWeight.bold,
//                                 color: isMe ? Colors.white : Colors.black,
//                               ),
//                             ),
//                             SizedBox(height: 5),
//                             Text(
//                               message,
//                               style: TextStyle(fontSize: 16, color: isMe ? Colors.white : Colors.black),
//                             ),
//                           ],
//                         ),
//                       ),
//                     );
//                   },
//                 );
//               },
//             ),
//           ),
//           _buildMessageInput(),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildMessageInput() {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Row(
//         children: [
//           Expanded(
//             child: TextField(
//               controller: _messageController,
//               decoration: InputDecoration(
//                 hintText: "Enter message",
//                 border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
//                 contentPadding: EdgeInsets.symmetric(horizontal: 16),
//               ),
//             ),
//           ),
//           SizedBox(width: 10),
//           IconButton(
//             icon: Icon(Icons.send, color: Colors.redAccent),
//             onPressed: _sendMessage,
//           ),
//         ],
//       ),
//     );
//   }
//
//   void _sendMessage() async {
//     if (_messageController.text.trim().isNotEmpty) {
//       User? user = _auth.currentUser;
//       if (user != null) {
//         _messagesRef.child(widget.groupId).push().set({
//           'message': _messageController.text.trim(),
//           'sender': user.email,
//           'timestamp': DateTime.now().toIso8601String(),
//         }).then((_) {
//           print("Message sent successfully");
//         }).catchError((error) {
//           print("Error sending message: $error");
//         });
//         _messageController.clear();
//       } else {
//         print("User not logged in");
//       }
//     } else {
//       print("Message cannot be empty");
//     }
//   }
// }

//
// import 'package:flutter/material.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'ChatScreen.dart';
//
// class GroupListPage extends StatefulWidget {
//   @override
//   _GroupListPageState createState() => _GroupListPageState();
// }
//
// class _GroupListPageState extends State<GroupListPage> {
//   final DatabaseReference _groupsRef = FirebaseDatabase.instance.ref().child('groups');
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black, // Netflix dark theme
//       appBar: AppBar(
//         title: Text("Community Groups", style: TextStyle(fontWeight: FontWeight.bold)),
//         backgroundColor: Colors.redAccent,
//       ),
//       body: StreamBuilder(
//         stream: _groupsRef.onValue,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator(color: Colors.redAccent));
//           }
//
//           if (!snapshot.hasData || snapshot.data?.snapshot.value == null) {
//             return Center(child: Text("No groups available", style: TextStyle(color: Colors.white70)));
//           }
//
//           Map<dynamic, dynamic> groups = snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
//           List groupList = groups.entries.toList();
//
//           return ListView.builder(
//             itemCount: groupList.length,
//             padding: EdgeInsets.all(16),
//             itemBuilder: (context, index) {
//               String groupId = groupList[index].key;
//               String groupName = groupList[index].value['name'];
//
//               return GestureDetector(
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => ChatScreen(groupId: groupId, groupName: groupName),
//                     ),
//                   );
//                 },
//                 child: Card(
//                   elevation: 5,
//                   color: Colors.grey[900],
//                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                   margin: EdgeInsets.only(bottom: 12),
//                   child: ListTile(
//                     contentPadding: EdgeInsets.all(12),
//                     leading: Icon(Icons.movie, color: Colors.redAccent, size: 32),
//                     title: Text(groupName, style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
//                     trailing: Icon(Icons.arrow_forward_ios, color: Colors.white70),
//                   ),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         backgroundColor: Colors.redAccent,
//         onPressed: () => _showCreateGroupDialog(context),
//         child: Icon(Icons.add, size: 30),
//       ),
//     );
//   }
//
//   void _showCreateGroupDialog(BuildContext context) {
//     TextEditingController groupNameController = TextEditingController();
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           backgroundColor: Colors.grey[900],
//           title: Text("Create New Group", style: TextStyle(color: Colors.white)),
//           content: TextField(
//             controller: groupNameController,
//             style: TextStyle(color: Colors.white),
//             decoration: InputDecoration(
//               hintText: "Enter group name",
//               hintStyle: TextStyle(color: Colors.white60),
//               enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.redAccent)),
//               focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.redAccent, width: 2)),
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: Text("Cancel", style: TextStyle(color: Colors.white)),
//             ),
//             ElevatedButton(
//               style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
//               onPressed: () {
//                 _createGroup(groupNameController.text.trim());
//                 Navigator.pop(context);
//               },
//               child: Text("Create"),
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   void _createGroup(String groupName) {
//     if (groupName.isNotEmpty) {
//       String groupId = _groupsRef.push().key!;
//       _groupsRef.child(groupId).set({'name': groupName, 'messages': {}}).then((_) {
//         print("Group created successfully");
//       }).catchError((error) {
//         print("Error creating group: $error");
//       });
//     }
//   }
// }
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:movflix/screens/chat_screen.dart';

class GroupListPage extends StatefulWidget {
  @override
  _GroupListPageState createState() => _GroupListPageState();
}

class _GroupListPageState extends State<GroupListPage> {
  final DatabaseReference _groupsRef = FirebaseDatabase.instance.ref().child('groups');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Community Groups", style: TextStyle(color: Colors.white, fontSize: 22)),
        backgroundColor: Colors.red,
        centerTitle: true,
        elevation: 0,
      ),
      body: StreamBuilder(
        stream: _groupsRef.onValue,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color: Colors.redAccent));
          }

          if (!snapshot.hasData || snapshot.data?.snapshot.value == null) {
            return Center(child: Text("No groups available", style: TextStyle(color: Colors.white, fontSize: 18)));
          }

          Map<dynamic, dynamic> groups = snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
          List groupList = groups.entries.toList();

          return ListView.builder(
            itemCount: groupList.length,
            itemBuilder: (context, index) {
              String groupId = groupList[index].key;
              String groupName = groupList[index].value['name'];

              return Card(
                color: Color(0xFF504A4A),
                elevation: 5,
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  leading: Icon(Icons.group, color: Colors.redAccent),
                  title: Text(groupName, style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  trailing: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatScreen(groupId: groupId, groupName: groupName),
                        ),
                      );
                    },
                    child: Text("Join", style: TextStyle(color: Colors.white)),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red.shade800,
        onPressed: () => _showCreateGroupDialog(context),
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _showCreateGroupDialog(BuildContext context) {
    TextEditingController groupNameController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Color(0xFF6D0F0F),
          title: Text("Create New Group", style: TextStyle(color: Colors.white)),
          content: TextField(
            controller: groupNameController,
            decoration: InputDecoration(hintText: "Enter group name", hintStyle: TextStyle(color: Colors.white)),
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel", style: TextStyle(color: Colors.white)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
              onPressed: () {
                _createGroup(groupNameController.text.trim());
                Navigator.pop(context);
              },
              child: Text("Create", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void _createGroup(String groupName) {
    if (groupName.isNotEmpty) {
      String groupId = _groupsRef.push().key!;
      _groupsRef.child(groupId).set({
        'name': groupName,
        'messages': {}
      }).then((_) {
        print("Group created successfully");
      }).catchError((error) {
        print("Error creating group: $error");
      });
    }
  }
}
