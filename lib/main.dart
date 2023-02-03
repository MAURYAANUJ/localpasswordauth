import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyApp(),
  ));
}

///<uses-permission android:name="android.permission.USE_FINGERPRINT"/>
///
///@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
///MainActivity.kt

/// import io.flutter.embedding.android.FlutterFragmentActivity
/// import io.flutter.embedding.engine.FlutterEngine
/// import io.flutter.plugins.GeneratedPluginRegistrant

/// class MainActivity: FlutterFragmentActivity() {
///     override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
///         GeneratedPluginRegistrant.registerWith(flutterEngine)
///     }
/// }
///@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final LocalAuthentication auth = LocalAuthentication();

  String msg = "You are not authorized.";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Fingerprint/Face Scan/Pin/Pattern Authenciation"),
          backgroundColor: Colors.purple,
        ),
        body: Container(
          margin: const EdgeInsets.only(top: 50),
          alignment: Alignment.center,
          child: Column(
            children: [
              Center(
                child: Text(msg),
              ),
              const Divider(),
              ElevatedButton(
                  onPressed: () async {
                    try {
                      bool hasbiometrics = await auth.canCheckBiometrics;
                      if (hasbiometrics) {
                        List<BiometricType> availableBiometrics =
                            await auth.getAvailableBiometrics();
                        if (Platform.isIOS) {
                          if (availableBiometrics
                              .contains(BiometricType.face)) {
                            bool pass = await auth.authenticate(
                              localizedReason: 'Authenticate with fingerprint',
                            );
                            if (pass) {
                              msg = "You are Autenciated.";
                              setState(() {});
                            }
                          }
                        } else {
                          if (availableBiometrics
                              .contains(BiometricType.fingerprint)) {
                            bool pass = await auth.authenticate(
                              localizedReason:
                                  'Authenticate with fingerprint/face',
                            );
                            if (pass) {
                              msg = "You are Authenicated.";
                              setState(() {});
                            }
                          }
                        }
                      } else {
                        setState(() {
                          msg = "You are not alowed to access biometrics.";
                        });
                      }
                    } on PlatformException {
                      msg = "Error while opening fingerprint/face scanner";
                    }
                  },
                  child: const Text("Authenticate with Fingerprint/Face Scan")),
              ElevatedButton(
                  onPressed: () async {
                    try {
                      bool pass = await auth.authenticate(
                        localizedReason:
                            'Authenticate with pattern/pin/passcode',
                      );
                      if (pass) {
                        msg = "You are Authenticated.";
                        setState(() {
                          msg = "Authenticate with Pin Authenticated.";
                        });
                      }
                    } on PlatformException {
                      msg = "Error while opening fingerprint/face scanner";
                    }
                  },
                  child: const Text(
                      "Authenticate with Pin/Passcode/Pattern Scan")),
            ],
          ),
        ));
  }
}
