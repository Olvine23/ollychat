import 'package:awesome_notifications/awesome_notifications.dart';
import 'dart:math';

class QuoteNotificationService {
  static final List<String> _quotes = [
    "Write something today, even if it’s one line.",
    "Your words matter—share them.",
    "Reading feeds your mind. Don’t starve it.",
    "One step forward is still progress.",
    "Your story is worth telling. Start now.",
  ];

  static Future<void> scheduleDailyQuote({int hour = 8, int minute = 0}) async {
    final random = Random();
    final randomQuote = _quotes[random.nextInt(_quotes.length)];

    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 10,
        channelKey: 'daily_reminder',
        title: 'Your Daily Boost',
        body: randomQuote,
        notificationLayout: NotificationLayout.Default,
      ),
      schedule: NotificationCalendar(
        hour: hour,
        minute: minute,
        second: 0,
        millisecond: 0,
        repeats: true,
        timeZone: await AwesomeNotifications().getLocalTimeZoneIdentifier(),
      ),
    );
  }

  static Future<void> cancelAllScheduled() async {
    await AwesomeNotifications().cancelAllSchedules();
  }
}
