import 'package:video_call/constants/progress_dialog_utils.dart';

import '../../main.dart';
import '../services/FirebaseService.dart';

void setUp() {
  getIt.registerSingleton<CustomDialogs>(CustomDialogs());
  getIt.registerSingleton<FirebaseService>(FirebaseService());
  // getIt.registerSingleton<AdService>(AdService());
}
