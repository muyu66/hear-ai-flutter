import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hearai/app.dart';
import 'package:hearai/tools/haptics_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const bool isProd = bool.fromEnvironment('dart.vm.product');
  await dotenv.load(fileName: isProd ? ".env.prod" : ".env");

  await GetStorage.init();
  HapticsManager.init();

  runApp(const App());
}
