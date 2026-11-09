import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Khởi tạo cài đặt thông báo cho Android và iOS
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const DarwinInitializationSettings initializationSettingsDarwin =
      DarwinInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestSoundPermission: true,
  );

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsDarwin,
  );

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: (NotificationResponse response) {
      debugPrint('Notification clicked: ${response.payload}');
    },
  );

  runApp(const NotificationApp());
}

class NotificationApp extends StatelessWidget {
  const NotificationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lab 10.5 - Local Notification',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
        useMaterial3: true,
      ),
      home: const NotificationScreen(),
    );
  }
}

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final TextEditingController _titleController =
      TextEditingController(text: 'Lab 10.5 Notification');
  final TextEditingController _bodyController =
      TextEditingController(text: 'Thông báo cục bộ đã kích hoạt thành công!');

  bool? _permissionGranted;

  @override
  void initState() {
    super.initState();
    _requestPermission();
  }

  // Yêu cầu cấp quyền POST_NOTIFICATIONS cho Android 13+ (API 33+)
  Future<void> _requestPermission() async {
    final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
        flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    if (androidImplementation != null) {
      final bool? granted =
          await androidImplementation.requestNotificationsPermission();
      setState(() {
        _permissionGranted = granted ?? false;
      });
    }
  }

  // Phát thông báo cục bộ theo yêu cầu (Manual Trigger)
  Future<void> _showNotification() async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'lab10_channel_id',
      'Lab 10 Notifications',
      channelDescription: 'Kênh thông báo cho Lab 10 PRM392',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
    );

    const NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
      iOS: DarwinNotificationDetails(),
    );

    await flutterLocalNotificationsPlugin.show(
      DateTime.now().millisecond,
      _titleController.text.trim().isEmpty ? 'Thông báo' : _titleController.text.trim(),
      _bodyController.text.trim().isEmpty ? 'Nội dung thông báo' : _bodyController.text.trim(),
      platformDetails,
      payload: 'lab10_notification_payload',
    );

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Đã phát thông báo lên hệ thống! Hãy kéo thanh trạng thái xuống xem.'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lab 10.5: Local Notification (LO7)'),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(Icons.notifications_active, size: 72, color: Colors.orange),
                const SizedBox(height: 12),
                const Text(
                  'Tích hợp Local Notification',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Kích hoạt thông báo trực tiếp trên thiết bị (Hỗ trợ Android 13+)',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey, fontSize: 13),
                ),
                const SizedBox(height: 20),
                Card(
                  color: (_permissionGranted ?? true)
                      ? Colors.green.shade50
                      : Colors.orange.shade50,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      children: [
                        Icon(
                          (_permissionGranted ?? true)
                              ? Icons.check_circle
                              : Icons.warning_amber_rounded,
                          color: (_permissionGranted ?? true)
                              ? Colors.green
                              : Colors.orange,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            (_permissionGranted ?? true)
                                ? 'Quyền thông báo (POST_NOTIFICATIONS) đã sẵn sàng.'
                                : 'Chưa cấp quyền thông báo. Bấm bên cạnh để xin quyền.',
                            style: TextStyle(
                              color: (_permissionGranted ?? true)
                                  ? Colors.green.shade900
                                  : Colors.orange.shade900,
                              fontSize: 13,
                            ),
                          ),
                        ),
                        if (_permissionGranted == false)
                          TextButton(
                            onPressed: _requestPermission,
                            child: const Text('Xin quyền'),
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Tiêu đề thông báo',
                    prefixIcon: Icon(Icons.title),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _bodyController,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    labelText: 'Nội dung thông báo',
                    prefixIcon: Icon(Icons.message_outlined),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: _showNotification,
                  icon: const Icon(Icons.notifications),
                  label: const Text(
                    'KÍCH HOẠT THÔNG BÁO (MANUAL TRIGGER)',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
