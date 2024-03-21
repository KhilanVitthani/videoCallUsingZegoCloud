import 'package:get/get.dart';

import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/peerChatPage/bindings/peer_chat_page_binding.dart';
import '../modules/peerChatPage/views/peer_chat_page_view.dart';
import '../modules/singIn/bindings/sing_in_binding.dart';
import '../modules/singIn/views/sing_in_view.dart';
import '../modules/singUp/bindings/sing_up_binding.dart';
import '../modules/singUp/views/sing_up_view.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static String INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.SING_UP,
      page: () => const SingUpView(),
      binding: SingUpBinding(),
    ),
    GetPage(
      name: _Paths.SING_IN,
      page: () => const SingInView(),
      binding: SingInBinding(),
    ),
    GetPage(
      name: _Paths.SPLASH,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: _Paths.PEER_CHAT_PAGE,
      page: () => const PeerChatPageView(),
      binding: PeerChatPageBinding(),
    ),
  ];
}
