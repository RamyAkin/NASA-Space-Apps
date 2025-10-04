import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
<<<<<<< HEAD
import 'pages/home_page.dart';
=======
import 'package:provider/provider.dart';
import 'providers/exoplanet_provider.dart';
import 'home_page.dart';
>>>>>>> 95b5ea0c5dcbc00bb5ecc185504528a6123eff0c

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
          home: const HomePage(),
          // optional named routes
          routes: {
            // add named routes here if desired later
          },
        );
      }),
    );
  }
}