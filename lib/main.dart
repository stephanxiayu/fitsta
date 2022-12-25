import 'package:fitsta/providers/user_provider.dart';
import 'package:fitsta/responsiv/mobile_screen_layout.dart';
import 'package:fitsta/responsiv/responsiv_layout_screen.dart';
import 'package:fitsta/responsiv/webscreenlayout.dart';
import 'package:fitsta/screen/login_screen.dart';
import 'package:fitsta/utilities/colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyBNWbZ4SXwgjlW0J_yWtY0lUO2T-isC37M",
          authDomain: "fitsta-6931b.firebaseapp.com",
          projectId: "fitsta-6931b",
          storageBucket: "fitsta-6931b.appspot.com",
          messagingSenderId: "677448919598",
          appId: "1:677448919598:web:1ce12dd24d0e5e0b71cdbf"),
    );
  } else {
    await Firebase.initializeApp();
  }
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return Scaffold(
      backgroundColor: mobileBackgroundColor,
      body: Container(
          alignment: Alignment.center,
          child: Column(
            children: [
              Lottie.asset("assets/error.json"),
              Text(
                'Error!\n${details.exception} \n\n\n bitte den App-Entwickler kontaktieren ',
                style: const TextStyle(color: Colors.yellow),
                textAlign: TextAlign.center,
                textDirection: TextDirection.ltr,
              ),
            ],
          )),
    );
  };

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Insta-Clone',
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: mobileBackgroundColor,
        ),
        home: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                if (snapshot.hasData) {
                  return const ResponsiveLayout(
                    mobileScreenLayout: MobileScreenLayout(),
                    webScreenLayout: WebScreenLayout(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('${snapshot.error}'),
                  );
                }
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: primaryColor,
                  ),
                );
              }
              return const LoginScreen();
            }),
      ),
    );
  }
}
