import 'dart:convert';
import 'package:afrika_baba/data/models/conversations_model.dart';
import 'package:afrika_baba/modules/chats/views/chat_detail_screen.dart';
import 'package:afrika_baba/providers/local_storage_provider.dart';
import 'package:get/get.dart';
import 'package:afrika_baba/services/pusher_service.dart';
import 'package:afrika_baba/services/notification_service.dart';
import 'package:afrika_baba/providers/chat_provider.dart';

class ChatController extends GetxController {
  
  var conversations = <Conversation>[].obs;
  final isLoading = true.obs;

  final PusherService _pusherService = Get.find<PusherService>();
  final ChatProvider chatProvider = ChatProvider();
  final LocalStorageProvider localStorage = Get.find<LocalStorageProvider>();
  
  @override
  void onInit() {
    super.onInit();
    loadConversations();
    // Écoute des événements de Pusher
    PusherService.eventStream.listen((eventData) {
      _handleIncomingEvent(eventData);
    });
  }


  void _handleIncomingEvent(String eventData) {
    try {
      var jsonData = json.decode(eventData);
      if (jsonData is Map<String, dynamic> && jsonData['message'] != null) {

        var messageData = jsonData['message'];
        final currentUser = localStorage.getUser();  
        if (messageData['user_id'] != currentUser?.id) {
          final conversation = getConversation(messageData['conversation_id']);
          conversation.messages.add(Message.fromJson(messageData));
          NotificationService.showInstantNotification(
            'Nouveau message',
            messageData['message'] ?? 'Vous avez reçu un nouveau message',
          );
        }
      }
    } catch (e) {
      print('Erreur lors de la réception des données : $e');
    }
  }

 
  Future<void> sendMessage(String message, int conversationId) async {
    try {
      final data = {"conversation_id": conversationId, "message": message};
      final response = await chatProvider.sendMessage(data);
      if (response != null && response.data['message'] != null) {
        final conversation = getConversation(conversationId);
        conversation.messages.add(Message.fromJson(response.data['message']));
      }
    } catch (e) {
      print('Erreur lors de l\'envoi du message : $e');
    }
  }


  Future<void> loadConversations() async {
    try {
      isLoading.value = true;
      final response = await chatProvider.getConversations();
      if (response != null && response.data['data'] is List) {
        conversations.value = List<Conversation>.from(
          (response.data['data'] as List).map((item) {
            return Conversation.fromJson(item as Map<String, dynamic>);
          }),
        );
        for (var conv in conversations) {
          await _pusherService.subscribeToConversation(conv.id);
        }
      } else {
        print('Erreur : les données de conversation ne sont pas au format attendu.');
      }
    } catch (e, stackTrace) {
      print('Erreur lors du chargement des conversations : $e\nStack Trace: $stackTrace');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadMessages(int conversationId) async {
  try {
    final conversation = getConversation(conversationId);
    if (conversation.messages.isEmpty) {
      final response = await chatProvider.getMessages(conversationId);
      if (response != null && response.data['data'] is List) {
        conversation.messages.addAll(
          List<Message>.from((response.data['data'] as List).map((item) {
            return Message.fromJson(item as Map<String, dynamic>);
          })),
        );
      } else {
        print('Erreur : les données de messages ne sont pas au format attendu.');
      }
    }
  } catch (e, stackTrace) {
    print('Erreur lors du chargement des messages pour la conversation $conversationId : $e\nStack Trace: $stackTrace');
  }
}


  Future<void> createConversation(int userid) async {
    try {
      final response = await chatProvider.createConversation(userid);
      if (response != null && response.data['data'] != null) {
        final conversation = Conversation.fromJson(response.data['data']);
        if(!conversations.any((conv) => conv.id == conversation.id)) {
          conversations.add(conversation);
          await _pusherService.subscribeToConversation(conversation.id);
        }
        Get.to(() => ChatDetailScreen(conversationId: conversation.id));
      }
    } catch (e) {
      Get.snackbar(
        'Erreur',
        'Impossible de créer la conversation. Veuillez réessayer.',
        snackPosition: SnackPosition.BOTTOM
      );
    }
  }

  Conversation getConversation(int conversationId) {
    return conversations.firstWhere((conv) => conv.id == conversationId);
  }

  @override
  void onClose() {
    super.onClose();
    _pusherService.disconnect();
  }

  Future<void> deleteMessage(int messageId, int conversationId) async  {
    final response = await chatProvider.deleteMessage(messageId);
    if(response != null){
      final conversation = getConversation(conversationId);
      conversation.messages.removeWhere((message) => message.id == messageId);
      update();
    }
  }
}
