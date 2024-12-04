import 'package:afrika_baba/modules/chats/controllers/ChatController.dart';
import 'package:get/get.dart';


class ChatBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ChatController());
  }
}
