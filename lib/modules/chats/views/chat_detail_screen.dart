import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:afrika_baba/shared/themes/chart_color.dart';

class ChatDetailScreen extends StatelessWidget {
  final String userName;
  
  ChatDetailScreen({
    Key? key,
    this.userName = "Li Chang",
  }) : super(key: key);

  final List<Map<String, dynamic>> _messages = [
    {
      "text": "Le Lorem Ipsum est simplement du faux texte utilisé dans la composition et la mise en",
      "isMe": false,
      "time": "14:22"
    },
    {
      "text": "Le Lorem Ipsum est simplement du faux texte utilisé dans la composition et la mise en",
      "isMe": true,
      "time": "14:23"
    },
    {
      "text": "Le Lorem Ipsum est simplement du faux texte utilisé dans la composition et la mise en",
      "isMe": false,
      "time": "14:24"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: btnColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          children: [
            Text(
              'Chat',
              style: GoogleFonts.poppins(
                color: btnColor,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const Divider(height: 1, color: Colors.grey),
          // User Profile Section
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(
                    'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?fit=crop&w=150&h=150'
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  userName,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: btnColor,
                  ),
                ),
                Text(
                  'en ligne',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ),
          // Messages Section
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return Align(
                  alignment: message['isMe'] 
                      ? Alignment.centerRight 
                      : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.75,
                    ),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: message['isMe'] 
                          ? const Color(0xFF464B5F)
                          : Colors.grey[200],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      message['text'],
                      style: GoogleFonts.poppins(
                        color: message['isMe'] ? Colors.white : Colors.black87,
                        fontSize: 14,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          // Message Input Section
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(0, -1),
                ),
              ],
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.emoji_emotions_outlined, 
                    color: Color(0xFF464B5F)),
                  onPressed: () {},
                ),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Type de message',
                      hintStyle: GoogleFonts.poppins(
                        color: Colors.grey[400],
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.camera_alt_outlined, 
                    color: Color(0xFF464B5F)),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.attach_file, 
                    color: Color(0xFF464B5F)),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
} 