import 'package:get/get.dart';

import '../controllers/peer_chat_page_controller.dart';

class PeerChatPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PeerChatPageController>(
      () => PeerChatPageController(),
    );
  }
}
