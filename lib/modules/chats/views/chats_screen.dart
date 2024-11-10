import 'package:afrika_baba/modules/chats/views/chat_detail_screen.dart';
import 'package:afrika_baba/shared/themes/chart_color.dart';
import 'package:afrika_baba/shared/widgets/bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatScreen extends StatelessWidget {
  final List<Map<String, dynamic>> _dummyChats = [
    {
      "name": "Sarah Miller",
      "message": "Bonjour, je suis intéressé par votre produit",
      "time": "12:30",
      "image": "https://images.unsplash.com/photo-1494790108377-be9c29b29330",
      "unread": 2,
    },
    {
      "name": "John Cooper",
      "message": "Le prix est-il négociable? 🤔",
      "time": "10:45",
      "image": "https://images.unsplash.com/photo-1500648767791-00dcc994a43e",
      "unread": 1,
    },
    {
      "name": "Marie Dupont",
      "message": "Merci pour votre réponse rapide! 👍",
      "time": "09:15",
      "image": "https://images.unsplash.com/photo-1438761681033-6461ffad8d80",
      "unread": 0,
    },
    {
      "name": "David Chen",
      "message": "Est-ce toujours disponible?",
      "time": "Hier",
      "image": "https://images.unsplash.com/photo-1472099645785-5658abf4ff4e",
      "unread": 0,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0.0),
        centerTitle: true,
        elevation: 0,
        title: Padding(
          padding: EdgeInsets.only(top: screenHeight * 0.02),
          child: Text(
            'Messages',
            style: GoogleFonts.poppins(
              fontSize: screenHeight * 0.025,
              color: btnColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          const Divider(height: 1, color: textColor),
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.all(screenWidth * 0.04),
              itemCount: _dummyChats.length,
              separatorBuilder: (context, index) => SizedBox(height: screenHeight * 0.015),
              itemBuilder: (context, index) {
                final chat = _dummyChats[index];
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.08),
                        spreadRadius: 1,
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.04,
                      vertical: screenHeight * 0.012,
                    ),
                    leading: Stack(
                      children: [
                        CircleAvatar(
                          radius: screenHeight * 0.03,
                          backgroundImage: NetworkImage('${chat["image"]}?fit=crop&w=150&h=150'),
                        ),
                        if (chat["unread"] > 0)
                          Positioned(
                            right: 0,
                            top: 0,
                            child: Container(
                              padding: EdgeInsets.all(screenWidth * 0.01),
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                '${chat["unread"]}',
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: screenHeight * 0.012,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    title: Text(
                      chat["name"],
                      style: GoogleFonts.poppins(
                        fontSize: screenHeight * 0.018,
                        fontWeight: FontWeight.w600,
                        color: btnColor,
                      ),
                    ),
                    subtitle: Row(
                      children: [
                        Expanded(
                          child: Text(
                            chat["message"],
                            style: GoogleFonts.poppins(
                              fontSize: screenHeight * 0.016,
                              color: Colors.grey[600],
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          chat["time"],
                          style: GoogleFonts.poppins(
                            fontSize: screenHeight * 0.014,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                    onTap: () {
                      Get.to(() => ChatDetailScreen(userName: chat["name"]));
                    },
                  ),
                );
              },
            ),
          ),
          CustomBottomNavigationBar(selectedIndex: 1),
        ],
      ),
    );
  }
}
