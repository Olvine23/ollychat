import 'package:audio_service/audio_service.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:olly_chat/app.dart';
import 'package:olly_chat/firebase_options.dart';
import 'package:olly_chat/screens/notifications/audio_handler.dart';
import 'package:olly_chat/services/push_notification_service.dart';
import 'package:olly_chat/simple_bloc_observer.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:post_repository/post_repository.dart';
import 'package:user_repository/user_repository.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tzData;

var apiKey = dotenv.env['GEMINI-API-KEY'];
late final MyAudioHandler audioHandler;
var eleApiKey = dotenv.env['EL_API_KEY'] as String;
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
void main() async {
   
  WidgetsFlutterBinding.ensureInitialized();
  tzData.initializeTimeZones(); // only once in the app
   const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  
   audioHandler = await AudioService.init(
    builder: () => MyAudioHandler(),
    config: const AudioServiceConfig(
      androidNotificationChannelId: 'com.ollychat.channel.audio',
      androidNotificationChannelName: 'Audio playback',
      androidNotificationOngoing: true,
    ),
  );
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  await FirebaseAppCheck.instance.activate(androidProvider: AndroidProvider.debug);
  OneSignal.initialize('ed03b794-a7a6-4e2c-893b-a859ce8da8fb');
  OneSignal.Notifications.requestPermission(true);
  PushNotificationService.initialize();
  Bloc.observer = SimpleBlocObserver();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(MyApp(FirebaseUserRepo(),FirebasePostRepository()));
}

