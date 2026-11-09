import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

// Plugin thông báo cục bộ (Lab 10.5 & LO7)
final FlutterLocalNotificationsPlugin notificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Khởi tạo Firebase (Lab 10.4)
  try {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: 'AIzaSyDaZh44nqLz7yTBUpjgS44uXKKQJL18XFw',
        appId: '1:854802733120:android:b66ae112b94aa290b727a5',
        messagingSenderId: '854802733120',
        projectId: 'nihon-ddea7',
      ),
    );
  } catch (e) {
    debugPrint('Firebase init notice: $e');
  }

  // 2. Khởi tạo Local Notifications (Lab 10.5)
  const AndroidInitializationSettings androidSettings =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  const DarwinInitializationSettings iosSettings = DarwinInitializationSettings();
  const InitializationSettings initSettings = InitializationSettings(
    android: androidSettings,
    iOS: iosSettings,
  );

  await notificationsPlugin.initialize(initSettings);

  // 3. Xin quyền thông báo trên Android 13+ (POST_NOTIFICATIONS)
  final AndroidFlutterLocalNotificationsPlugin? androidPlatform =
      notificationsPlugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
  await androidPlatform?.requestNotificationsPermission();

  runApp(const Lab10FullApp());
}

// Hàm tiện ích phát thông báo (dùng sau khi đăng nhập thành công & demo thủ công)
Future<void> triggerAppNotification(String title, String body) async {
  const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
    'lab10_full_channel',
    'Lab 10 Notifications',
    channelDescription: 'Thông báo sự kiện đăng nhập và hệ thống',
    importance: Importance.max,
    priority: Priority.high,
  );

  const NotificationDetails details = NotificationDetails(
    android: androidDetails,
    iOS: DarwinNotificationDetails(),
  );

  await notificationsPlugin.show(
    DateTime.now().millisecond,
    title,
    body,
    details,
  );
}

class Lab10FullApp extends StatelessWidget {
  const Lab10FullApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lab 10 Full - Integrated Project',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}

// -------------------------------------------------------------
// 1. Màn hình Splash: Kiểm tra Session / Auto Login (Lab 10.3)
// -------------------------------------------------------------
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAutoLogin();
  }

  Future<void> _checkAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final username = prefs.getString('username') ?? 'User';
    final fullName = prefs.getString('fullName') ?? username;
    final loginMethod = prefs.getString('loginMethod') ?? 'API';
    final photoUrl = prefs.getString('photoUrl') ?? '';

    // Delay 1.5 giây tạo trải nghiệm Splash
    await Future.delayed(const Duration(milliseconds: 1500));

    if (!mounted) return;

    if (token != null && token.isNotEmpty) {
      // Đã có phiên đăng nhập -> Vào thẳng Home
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(
            username: username,
            fullName: fullName,
            token: token,
            loginMethod: loginMethod,
            photoUrl: photoUrl,
          ),
        ),
      );
    } else {
      // Chưa đăng nhập -> Chuyển sang màn hình Đăng nhập
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent.shade700,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.shield_outlined, size: 64, color: Colors.blueAccent),
            ),
            const SizedBox(height: 24),
            const Text(
              'Lab 10 – Full Integrated App',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Xác thực • Quản lý phiên • Thông báo',
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
            const SizedBox(height: 32),
            const CircularProgressIndicator(color: Colors.white),
          ],
        ),
      ),
    );
  }
}

// -------------------------------------------------------------
// 2. Màn hình Đăng nhập: Real API (Lab 10.2) & Google Sign-In (Lab 10.4)
// -------------------------------------------------------------
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController =
      TextEditingController(text: 'emilys');
  final TextEditingController _passwordController =
      TextEditingController(text: 'emilyspass');

  bool _isLoadingApi = false;
  bool _isLoadingGoogle = false;
  bool _obscurePassword = true;
  String? _errorMessage;

  // 2.1 Đăng nhập qua Real REST API DummyJSON (Lab 10.2)
  Future<void> _loginWithApi() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoadingApi = true;
      _errorMessage = null;
    });

    try {
      final url = Uri.parse('https://dummyjson.com/auth/login');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': _usernameController.text.trim(),
          'password': _passwordController.text,
          'expiresInMins': 60,
        }),
      );

      final Map<String, dynamic> data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final token = (data['accessToken'] ?? data['token'] ?? '').toString();
        final username = (data['username'] ?? '').toString();
        final firstName = (data['firstName'] ?? '').toString();
        final lastName = (data['lastName'] ?? '').toString();
        final fullName = '$firstName $lastName'.trim();
        final imageUrl = (data['image'] ?? '').toString();

        // Lưu phiên đăng nhập (Lab 10.3)
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);
        await prefs.setString('username', username);
        await prefs.setString('fullName', fullName);
        await prefs.setString('loginMethod', 'DummyJSON API');
        await prefs.setString('photoUrl', imageUrl);

        // KÍCH HOẠT LOCAL NOTIFICATION KHI ĐĂNG NHẬP THÀNH CÔNG (Lab 10.5 & LO7)
        await triggerAppNotification(
          'Đăng nhập thành công',
          'Chào mừng $fullName ($username) đã đăng nhập vào hệ thống!',
        );

        if (!mounted) return;
        setState(() => _isLoadingApi = false);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(
              username: username,
              fullName: fullName,
              token: token,
              loginMethod: 'DummyJSON API',
              photoUrl: imageUrl,
            ),
          ),
        );
      } else {
        final msg = data['message'] ?? 'Tài khoản hoặc mật khẩu không chính xác!';
        if (!mounted) return;
        setState(() {
          _isLoadingApi = false;
          _errorMessage = msg.toString();
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoadingApi = false;
        _errorMessage = 'Lỗi kết nối mạng: $e';
      });
    }
  }

  // 2.2 Đăng nhập bằng Google thông qua Firebase (Lab 10.4)
  Future<void> _loginWithGoogle() async {
    setState(() {
      _isLoadingGoogle = true;
      _errorMessage = null;
    });

    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        if (!mounted) return;
        setState(() => _isLoadingGoogle = false);
        return;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        final token = await user.getIdToken() ?? user.uid;
        final username = user.email ?? 'GoogleUser';
        final fullName = user.displayName ?? username;
        final photoUrl = user.photoURL ?? '';

        // Lưu phiên làm việc (Lab 10.3)
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);
        await prefs.setString('username', username);
        await prefs.setString('fullName', fullName);
        await prefs.setString('loginMethod', 'Firebase Google');
        await prefs.setString('photoUrl', photoUrl);

        // KÍCH HOẠT LOCAL NOTIFICATION KHI GOOGLE LOGIN THÀNH CÔNG (Lab 10.5 & LO7)
        await triggerAppNotification(
          'Đăng nhập Google thành công',
          'Chào mừng $fullName đã đăng nhập qua tài khoản Google!',
        );

        if (!mounted) return;
        setState(() => _isLoadingGoogle = false);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(
              username: username,
              fullName: fullName,
              token: token,
              loginMethod: 'Firebase Google',
              photoUrl: photoUrl,
            ),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoadingGoogle = false;
        _errorMessage =
            'Lỗi Google Sign-In: $e\n(Nếu máy ảo chưa có Google Play Services / SHA-1, bạn có thể nhấn nút "Thử nghiệm mẫu Profile Google" bên dưới để kiểm tra).';
      });
    }
  }

  // 2.3 Chế độ demo Google Sign-In dự phòng cho máy ảo không có Google Play Services
  Future<void> _loginWithGoogleDemo() async {
    const demoToken = 'demo_google_token_xyz987654321';
    const demoUser = 'student.google@fpt.edu.vn';
    const demoName = 'Nguyễn Văn A';
    const demoPhoto = 'https://lh3.googleusercontent.com/a/default-user=s96-c';

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', demoToken);
    await prefs.setString('username', demoUser);
    await prefs.setString('fullName', demoName);
    await prefs.setString('loginMethod', 'Firebase Google (Demo)');
    await prefs.setString('photoUrl', demoPhoto);

    await triggerAppNotification(
      'Đăng nhập Google thành công',
      'Chào mừng $demoName đã đăng nhập!',
    );

    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const HomeScreen(
          username: demoUser,
          fullName: demoName,
          token: demoToken,
          loginMethod: 'Firebase Google (Demo)',
          photoUrl: demoPhoto,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Đăng nhập (Lab 10 Full)'),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 440),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(Icons.lock_outline, size: 64, color: Colors.blueAccent),
                  const SizedBox(height: 12),
                  const Text(
                    'Đăng nhập tài khoản',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Hỗ trợ DummyJSON API & Google Firebase',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: _usernameController,
                    decoration: const InputDecoration(
                      labelText: 'Tên đăng nhập (Username / Email)',
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? 'Vui lòng nhập tên đăng nhập' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      labelText: 'Mật khẩu',
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                        onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                      ),
                      border: const OutlineInputBorder(),
                    ),
                    validator: (v) =>
                        (v == null || v.isEmpty) ? 'Vui lòng nhập mật khẩu' : null,
                  ),
                  const SizedBox(height: 16),
                  if (_errorMessage != null)
                    Container(
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.red.shade300),
                      ),
                      child: Text(
                        _errorMessage!,
                        style: const TextStyle(color: Colors.red, fontSize: 13),
                      ),
                    ),
                  ElevatedButton(
                    onPressed: (_isLoadingApi || _isLoadingGoogle) ? null : _loginWithApi,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: _isLoadingApi
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                          )
                        : const Text('ĐĂNG NHẬP (DUMMYJSON API)',
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 20),
                  const Row(
                    children: [
                      Expanded(child: Divider()),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Text('HOẶC', style: TextStyle(color: Colors.grey, fontSize: 12)),
                      ),
                      Expanded(child: Divider()),
                    ],
                  ),
                  const SizedBox(height: 20),
                  OutlinedButton.icon(
                    onPressed:
                        (_isLoadingApi || _isLoadingGoogle) ? null : _loginWithGoogle,
                    icon: _isLoadingGoogle
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.g_mobiledata, size: 28, color: Colors.red),
                    label: const Text('Đăng nhập với Google (Firebase)'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 13),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: _loginWithGoogleDemo,
                    child: const Text(
                      'Thử nghiệm mẫu Profile Google (Dành cho máy ảo chưa có Google Play)',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// -------------------------------------------------------------
// 3. Màn hình Home: Quản lý phiên, Thông tin người dùng, Test Notification & Logout
// -------------------------------------------------------------
class HomeScreen extends StatelessWidget {
  final String username;
  final String fullName;
  final String token;
  final String loginMethod;
  final String photoUrl;

  const HomeScreen({
    super.key,
    required this.username,
    required this.fullName,
    required this.token,
    required this.loginMethod,
    required this.photoUrl,
  });

  Future<void> _logout(BuildContext context) async {
    // 1. Xóa SharedPreferences (Lab 10.3)
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    // 2. Đăng xuất khỏi Firebase & Google (Lab 10.4)
    try {
      await FirebaseAuth.instance.signOut();
      await GoogleSignIn().signOut();
    } catch (_) {}

    if (!context.mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trang chủ (Lab 10 Full)'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Đăng xuất',
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Column(
              children: [
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 46,
                          backgroundColor: Colors.blueAccent.shade100,
                          backgroundImage:
                              photoUrl.isNotEmpty ? NetworkImage(photoUrl) : null,
                          child: photoUrl.isEmpty
                              ? const Icon(Icons.person, size: 46, color: Colors.blueAccent)
                              : null,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          fullName.isNotEmpty ? fullName : username,
                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text('@$username', style: TextStyle(color: Colors.grey.shade600)),
                        const SizedBox(height: 12),
                        Chip(
                          avatar: const Icon(Icons.verified, size: 18, color: Colors.green),
                          label: Text('Phương thức: $loginMethod'),
                          backgroundColor: Colors.green.shade50,
                          side: BorderSide(color: Colors.green.shade200),
                        ),
                        const Divider(height: 32),
                        ListTile(
                          dense: true,
                          leading: const Icon(Icons.vpn_key_outlined, color: Colors.blueAccent),
                          title: const Text('Access Token / Session UID:'),
                          subtitle: SelectableText(
                            token,
                            style: const TextStyle(fontFamily: 'monospace', fontSize: 11),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Card(
                  color: Colors.orange.shade50,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.notifications_active, color: Colors.orange),
                            SizedBox(width: 8),
                            Text(
                              'Kiểm tra Local Notification (LO7)',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Bấm nút bên dưới để phát thông báo thủ công lên hệ thống để kiểm tra tính năng thông báo cục bộ.',
                          style: TextStyle(fontSize: 13, color: Colors.black87),
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton.icon(
                          onPressed: () async {
                            await triggerAppNotification(
                              'Test Notification',
                              'Thông báo thử nghiệm từ màn hình Trang chủ!',
                            );
                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Đã gửi thông báo lên hệ thống!'),
                                backgroundColor: Colors.green,
                              ),
                            );
                          },
                          icon: const Icon(Icons.send),
                          label: const Text('Phát thông báo thử nghiệm'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () => _logout(context),
                  icon: const Icon(Icons.logout),
                  label: const Text('ĐĂNG XUẤT (XÓA PHIÊN & SIGN OUT)'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
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
