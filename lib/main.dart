import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hearai/app.dart';
import 'package:hearai/store.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const bool isProd = bool.fromEnvironment('dart.vm.product');
  await dotenv.load(fileName: isProd ? ".env.prod" : ".env");

  runApp(ChangeNotifierProvider(create: (_) => Store(), child: App()));
}
