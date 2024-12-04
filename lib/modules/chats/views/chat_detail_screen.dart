import 'package:afrika_baba/core/utils/utils.dart';
import 'package:afrika_baba/modules/chats/controllers/ChatController.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:afrika_baba/shared/themes/chart_color.dart';
import 'package:get/get.dart'; // Importer le ChatController

class ChatDetailScreen extends GetView<ChatController> {
  final int conversationId;
  final TextEditingController _messageController = TextEditingController();

  ChatDetailScreen({
    super.key,
    required this.conversationId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundAppColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: btnColor, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            const CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage(
                'https://www.shutterstock.com/image-vector/user-profile-icon-vector-avatar-600nw-2247726673.jpg'
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${controller.getConversation(conversationId).userTwo.lastname} ${controller.getConversation(conversationId).userTwo.firstname}',
                  style: GoogleFonts.poppins(
                    color: btnColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'en ligne',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Messages Section
          Expanded(
            child: Obx(() {
              return controller.getConversation(conversationId).messages.isNotEmpty
                  ? ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                      itemCount: controller.getConversation(conversationId).messages.length,
                      itemBuilder: (context, index) {
                        final message = controller.getConversation(conversationId).messages[index];
                        final bool isMe = message.userId == controller.localStorage.getUser()?.id;

                        return Align(
                          alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            constraints: BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width * 0.75,
                            ),
                            child: Material(
                              elevation: 2,
                              shadowColor: Colors.black.withOpacity(0.1),
                              borderRadius: BorderRadius.only(
                                topLeft: const Radius.circular(20),
                                topRight: const Radius.circular(20),
                                bottomLeft: isMe ? const Radius.circular(20) : const Radius.circular(5),
                                bottomRight: isMe ? const Radius.circular(5) : const Radius.circular(20),
                              ),
                              color: isMe ? btnColor : Colors.grey[100],
                              child: InkWell(
                                onLongPress: isMe ? () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        backgroundColor: Colors.white,
                                        title: Row(
                                          children: [
                                            const Icon(Icons.delete_outline, color: Colors.red, size: 25),
                                            const SizedBox(width: 10),
                                            Text(
                                              'Supprimer le message',
                                              style: GoogleFonts.poppins(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                        content: Text(
                                          'Voulez-vous vraiment supprimer ce message ?',
                                          style: GoogleFonts.poppins(
                                            fontSize: 15,
                                            color: Colors.grey[800],
                                          ),
                                        ),
                                        actions: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              TextButton(
                                                style: TextButton.styleFrom(
                                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(10),
                                                  ),
                                                ),
                                                child: Text(
                                                  'Annuler',
                                                  style: GoogleFonts.poppins(
                                                    color: Colors.grey[600],
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                 ),
                                                onPressed: () => Navigator.of(context).pop(),
                                              ),
                                              const SizedBox(width: 8),
                                              ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.red[400],
                                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(10),
                                                  ),
                                                ),
                                                child: Text(
                                                  'Supprimer',
                                                  style: GoogleFonts.poppins(
                                                    color: Colors.white,
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                onPressed: () {
                                                  controller.deleteMessage(message.id, conversationId);
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                            ],
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                } : null,
                                borderRadius: BorderRadius.circular(20),
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Column(
                                    crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        message.message,
                                        style: GoogleFonts.poppins(
                                          color: isMe ? Colors.white : textColor,
                                          fontSize: 14,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        Utils.formatDate(message.createdAt),
                                        style: GoogleFonts.poppins(
                                          color: isMe ? Colors.white70 : Colors.grey[600],
                                          fontSize: 11,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    )
                  : Center(
                      child: Text(
                        'Aucun message',
                        style: GoogleFonts.poppins(
                          color: Colors.grey[500],
                          fontSize: 16,
                        ),
                      ),
                    );
            }),
          ),
          // Message Input Section
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.emoji_emotions_outlined, color: btnColor, size: 28),
                  onPressed: () {},
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: 'Écrivez votre message...',
                        hintStyle: GoogleFonts.poppins(
                          color: Colors.grey[400],
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: btnColor,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.send_rounded, color: Colors.white),
                    onPressed: () {
                      if (_messageController.text.trim().isNotEmpty) {
                        controller.sendMessage(_messageController.text, conversationId);
                        _messageController.clear();
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
