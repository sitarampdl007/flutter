import 'package:get_it/get_it.dart';

import '../network/api_manager.dart';

GetIt locator = GetIt.instance;

Future<void> setupLocator() async {
  // * API Manager
  locator.registerLazySingleton<ApiManager>(() => ApiManager());
}
