import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:olly_chat/app.dart';
import 'package:olly_chat/firebase_options.dart';
import 'package:olly_chat/simple_bloc_observer.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:post_repository/post_repository.dart';
import 'package:user_repository/user_repository.dart';

var apiKey = dotenv.env['GEMINI-API-KEY'];

var eleApiKey = dotenv.env['EL_API_KEY'] as String;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  await FirebaseAppCheck.instance.activate(androidProvider: AndroidProvider.debug);
  OneSignal.initialize('ed03b794-a7a6-4e2c-893b-a859ce8da8fb');
  OneSignal.Notifications.requestPermission(true);
  Bloc.observer = SimpleBlocObserver();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(MyApp(FirebaseUserRepo(),FirebasePostRepository()));
}

