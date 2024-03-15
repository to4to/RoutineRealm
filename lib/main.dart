
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:routine_realm/pages/home_page.dart';
import 'package:routine_realm/theme/light_mode.dart';
import 'package:routine_realm/theme/theme_provider.dart';

void main() {
  ChangeNotifierProvider(create: (context)=>ThemeProvider(),
  child: const MyApp(),);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
      theme: Provider.of<ThemeProvider>(context).themeData,

    );
  }
}

