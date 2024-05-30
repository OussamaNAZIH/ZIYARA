import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_pfe/Screens/TapScreen.dart';
import 'package:flutter_pfe/controllers/providers/provider.dart';
import 'package:flutter_pfe/firebase_options.dart';
import 'package:flutter_pfe/generated/l10n.dart';
import 'package:provider/provider.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => SelectedProvider(),
        )
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  void initState() {
    super.initState();
    initialize();
  }

  void initialize() async {
    super.initState();
    await Future.delayed(Duration(seconds: 2));
    FlutterNativeSplash.remove();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      
        debugShowCheckedModeBanner: false,
        supportedLocales: S.delegate.supportedLocales,
        theme: ThemeData(
                primaryColor: Color(0xFF06B3C4), // Utilisation de la couleur demandée pour le thème général
          bottomSheetTheme: const BottomSheetThemeData(
            backgroundColor:
                Color.fromARGB(255, 255, 255, 255), // Changez la couleur ici
          ),
        ),
        home:  TabScreen());
  }
}
