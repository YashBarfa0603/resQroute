import 'package:flutter/material.dart';
import 'package:res_q_route/HomePage/welcome.dart';
import 'package:res_q_route/services/hive_service.dart';
import 'package:res_q_route/theme/app_themes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveService.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ResQ Route',
      theme: AppThemes.defaultTheme,
      home: const WelcomePage(),
    );
  }
}
