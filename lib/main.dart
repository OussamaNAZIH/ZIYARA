import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_pfe/Screens/TapScreen.dart';
import 'package:flutter_pfe/firebase_options.dart';
import 'package:flutter_pfe/generated/l10n.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   Platform.isAndroid
//       ? await Firebase.initializeApp(
//           options: const FirebaseOptions(
//             apiKey: "AIzaSyD3tu0XD_dluSukTRV2m45amDaQiCGHn5o",
//             appId: "1:303176017843:android:5a32151136ae15387b8dc6",
//             messagingSenderId: "303176017843",
//             projectId: "mypfe-24427",
//           ),
//         )
//       : await Firebase.initializeApp();
//   runApp(const MyApp());
// }
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        // debugShowCheckedModeBanner: false,
        // localizationsDelegates: const [
        //   S.delegate,
        //   GlobalMaterialLocalizations.delegate,
        //   GlobalWidgetsLocalizations.delegate,
        //   GlobalCupertinoLocalizations.delegate,
        //],
        supportedLocales: S.delegate.supportedLocales,
        theme: ThemeData(
          bottomSheetTheme: const BottomSheetThemeData(
            backgroundColor:
                Color.fromARGB(255, 255, 255, 255), // Changez la couleur ici
          ),
        ),
        home: const TabScreen());
  }
}
