import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:provider/provider.dart';
import 'config/theme.dart';
import 'widgets/auth_check.dart';
import 'providers/theme_provider.dart';
import 'providers/favorites_provider.dart';
import 'services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Supabase.initialize(
    url: 'https://pxtydnqkpjjlzzqnqjff.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InB4dHlkbnFrcGpqbHp6cW5xamZmIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzM2NzU4MDUsImV4cCI6MjA4OTI1MTgwNX0.pX6v-BVAlQnyah5N5bpmFb2sQmZq--cYbs-EKWu0uF0',
  );
  
  // Initialize notifications
  await NotificationService().initialize();
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => FavoritesProvider()),
      ],
      child: const BusTrackerApp(),
    ),
  );
}

class BusTrackerApp extends StatelessWidget {
  const BusTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aagman',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      home: const AuthCheck(), // Auth check with splash screen
    );
  }
}
