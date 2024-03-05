import 'package:get/get.dart';
import 'package:video_call/constants/api_constants.dart';
import 'package:video_call/constants/sizeConstant.dart';
import 'package:video_call/main.dart';

import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/singIn/bindings/sing_in_binding.dart';
import '../modules/singIn/views/sing_in_view.dart';
import '../modules/singUp/bindings/sing_up_binding.dart';
import '../modules/singUp/views/sing_up_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static String INITIAL =
      (isNullEmptyOrFalse(box.read(PrefStrings.isUserLogin)))
          ? Routes.SING_UP
          : Routes.HOME;

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
  ];
}
