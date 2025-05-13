import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:olly_chat/blocs/myuserbloc/myuser_bloc.dart';
import 'package:olly_chat/blocs/sign_in/sign_in_bloc.dart';
import 'package:olly_chat/main.dart';
import 'package:olly_chat/screens/profile/widgets/bottom_sheet_modal.dart';
import 'package:user_repository/user_repository.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tzData;

class SettingsScreen extends StatefulWidget {
  final Function(ThemeMode) toggleTheme;

  const SettingsScreen({super.key, required this.toggleTheme});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool notificationsEnabled = true; // You can load this from storage later

  @override
  void initState() {
    super.initState();
    // _initNotifications();
  }

  // Future<void> _initNotifications() async {
  //   const AndroidInitializationSettings initializationSettingsAndroid =
  //       AndroidInitializationSettings('@mipmap/ic_launcher');

  //   const InitializationSettings initializationSettings =
  //       InitializationSettings(android: initializationSettingsAndroid);

  //   await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  // }

  Future<void> scheduleDailyReminder() async {
    tzData.initializeTimeZones(); // make sure to call this once in main()

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'daily_reminder_channel_id',
      'Daily Reminders',
      channelDescription: 'Daily reminder to write',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    final now = tz.TZDateTime.now(tz.local);
    final scheduledTime = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      22, // 9 PM
      10, // 40 minutes
    );

    final notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        'daily_notification_channel_id',
        'Daily Notifications',
        channelDescription: 'Notification to remind users to write daily',
        importance: Importance.max,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(),
    );

    final nextScheduledTime = scheduledTime.isBefore(now)
        ? scheduledTime.add(Duration(days: 1))
        : scheduledTime;

    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'Time to write!',
      'Tap to open Voicehub and jot something down.',
      nextScheduledTime,
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          BlocBuilder<MyUserBloc, MyUserState>(
            builder: (context, state) {
              if (state.status == MyUserStatus.failure) {
                return Container();
              } else {
                return _buildListTile(
                  context,
                  icon: Icons.person,
                  title: 'Personal Info',
                  onTap: () {
                    print(state.user!.name);
                  },
                );
              }
            },
          ),
          _buildListTile(
            context,
            icon: Icons.notifications,
            title: 'Notification',
            onTap: () {
              Navigator.pushNamed(context, '/notification');
            },
          ),
          _buildListTile(
            context,
            icon: Icons.lock,
            title: 'Security',
            onTap: () {
              Navigator.pushNamed(context, '/security');
            },
          ),
          _buildListTile(
            context,
            icon: Icons.info,
            title: 'About',
            onTap: () {
              Navigator.pushNamed(context, '/about');
            },
          ),
          SwitchListTile(
            title: Text('Daily Writing Reminder'),
            secondary: Icon(Icons.notifications_active),
            value: notificationsEnabled,
            onChanged: (value) async {
              setState(() {
                notificationsEnabled = value;
              });
              if (value) {
                try {
                  await scheduleDailyReminder();
                  print("Notification scheduled");
                } catch (e) {
                  print("Failed to schedule notification: $e");
                }
              } else {
                await flutterLocalNotificationsPlugin.cancel(0);
              }
            },
          ),
          ListTile(
            leading: Icon(Icons.remove_red_eye),
            trailing: Switch(
              value: isDarkMode,
              onChanged: (bool value) {
                value
                    ? widget.toggleTheme(ThemeMode.dark)
                    : widget.toggleTheme(ThemeMode.light);
              },
            ),
            title: Text("Dark Mode"),
          ),
          _buildListTile(
            context,
            icon: Icons.logout,
            title: 'Logout',
            onTap: () {
              _handleLogout(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildListTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      trailing: Icon(Icons.chevron_right),
      leading: Icon(icon, color: Theme.of(context).iconTheme.color),
      title: Text(title),
      onTap: onTap, 
    );
  }

  void _handleLogout(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return BlocProvider(
          create: (context) => SignInBloc(userRepository: FirebaseUserRepo()),
          child: LogoutBottomSheet(),
        );
      },
    );
  }
}
