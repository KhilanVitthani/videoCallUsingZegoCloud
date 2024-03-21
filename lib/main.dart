import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:get_storage/get_storage.dart';
import 'package:video_call/constants/app_module.dart';

import 'app/routes/app_pages.dart';
import 'firebase_options.dart';

final navigatorKey = GlobalKey<NavigatorState>();
final GetIt getIt = GetIt.instance;
GetStorage box = GetStorage();
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await GetStorage.init();
  setUp();
  runApp(
    GetMaterialApp(
      navigatorKey: navigatorKey,
      title: "Application",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    ),
  );
}
