import 'package:todo/presentation/utils/local_notification_service.dart';

class LocalNotificationRepository {
  LocalNotificationService localNotificationService = LocalNotificationService();

  void listenToNotification() => localNotificationService.onNotificationClick.stream.listen(onNotificationListener);

  String? onNotificationListener(String? payload) {
    if (payload != null && payload.isNotEmpty) {
      // Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //       builder: (context) => ScreenToView(payload),
      //     ));
      return payload;
    }
    return null;
  }
}
