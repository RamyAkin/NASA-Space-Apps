import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'providers/exoplanet_provider.dart';
import 'screens/home_page.dart';  
import 'screens/add_or_test.dart';
import 'screens/confirmed_screen.dart';
import 'screens/candidates_screen.dart';
import 'screens/false_positives_screen.dart';
import 'screens/placeholder_screen.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final base = ThemeData.dark();
    return ChangeNotifierProvider(
      create: (_) => ExoplanetProvider(),
      child: Builder(builder: (context) {
        // Kick off initial load after first frame
        WidgetsBinding.instance.addPostFrameCallback((_) {
          final provider = Provider.of<ExoplanetProvider>(context, listen: false);
          provider.loadAll();
        });

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'A World Away',
          theme: base.copyWith(
            textTheme: GoogleFonts.poppinsTextTheme(base.textTheme),
            scaffoldBackgroundColor: Colors.transparent,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          initialRoute: '/',
          routes: {
            '/': (context) => const HomePage(),
            '/add-test': (context) => const AddOrTestPage(),
            '/confirmed': (context) => const ConfirmedScreen(),
            '/candidates': (context) => const CandidatesScreen(),
            '/false-positives': (context) => const FalsePositivesScreen(),
            '/statistics': (context) => const PlaceholderScreen(title: 'Model Statistics'),
            '/settings': (context) => const PlaceholderScreen(title: 'Model Settings'),
          },
        );
      }),
    );
  }
}