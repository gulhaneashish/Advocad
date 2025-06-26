import 'package:flutter/material.dart';
import 'package:legalapp/auth/initial_screen.dart';
import 'package:legalapp/screens/main_screen.dart';
import 'package:legalapp/session_manager/session.dart';
import 'package:legalapp/theme/my_theme.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SessionManager.init();
  await Supabase.initialize(
    url: 'https://owvasffthnkzjcpebhls.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im93dmFzZmZ0aG5rempjcGViaGxzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDE3NzgzODUsImV4cCI6MjA1NzM1NDM4NX0.DWYYQ1Nla83mvdbrpqyiTiPQ2MaZU0ISpspX66Fa1tk',
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LegalQuest',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system, // Automatically switches between Light & Dark Mode
      home: MainPage(),
    );
  }
}
