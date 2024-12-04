import 'package:afrika_baba/providers/api_provider.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;



class ChatProvider {
  
  final  ApiProvider apiProvider =  Get.find<ApiProvider>();

  // final LocalStorageProvider localStorage = get.Get.find<LocalStorageProvider>();

  Future<dio.Response?> createConversation(int userId) async {
    try {
      final response = await apiProvider.dio.post("/conversations", data: {"user_two_id": userId});
      return response;
    } catch (e) {
      throw Exception('Erreur lors de la création de la conversation : $e');
    }
  }

  Future<dio.Response?> sendMessage(Map<String, dynamic> data) async {
    try {
      final response = await apiProvider.dio.post("/conversations/send-message", data: data);
      return response;
    } catch (e) {

      throw Exception('Erreur lors de l\'envoi du message : $e');
    }
  }
  
  Future<dio.Response?> getMessages(int conversationId) async {
    try {
      final response = await apiProvider.dio.get("/conversations/$conversationId/messages");
      return response;
    } catch (e) {
      throw Exception('Erreur lors de la récupération des messages : $e');
    }
  }

  Future<dio.Response?> getConversations() async {
    try {
      final response = await apiProvider.dio.get("/conversations");
      return response;
    } catch (e) {
      throw Exception('Erreur lors de la récupération des conversations : $e');
    }
  }

  Future<dio.Response?> deleteMessage(int messageId) async {
    try {
      final response = await apiProvider.dio.delete("/messages/$messageId");
      return response;
    } catch (e) {
      throw Exception('Erreur lors de la suppression du message : $e');
    }
  }
}


// Route pour créer une conversation privée entre deux utilisateurs
// Route::post('/conversations', [ChatController::class, 'createConversation']);
//     // Route pour envoyer un message dans une conversation spécifique
// Route::post('/conversations/{conversationId}/send-message', [ChatController::class, 'sendMessage']);
//     // Route pour récupérer tous les messages d'une conversation spécifique
// Route::get('/conversations/{conversationId}/messages', [ChatController::class, 'getMessages']);