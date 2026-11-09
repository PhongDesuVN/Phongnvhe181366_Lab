import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    // Khởi tạo Firebase với cấu hình an toàn
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

  runApp(const FirebaseGoogleAuthApp());
}

class FirebaseGoogleAuthApp extends StatelessWidget {
  const FirebaseGoogleAuthApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lab 10.4 - Firebase Google Sign-In',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.redAccent),
        useMaterial3: true,
      ),
      home: const GoogleAuthWrapper(),
    );
  }
}

class GoogleAuthWrapper extends StatelessWidget {
  const GoogleAuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    // Lắng nghe trạng thái đăng nhập Firebase
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasData && snapshot.data != null) {
          return ProfileScreen(user: snapshot.data!);
        }
        return const GoogleSignInScreen();
      },
    );
  }
}

class GoogleSignInScreen extends StatefulWidget {
  const GoogleSignInScreen({super.key});

  @override
  State<GoogleSignInScreen> createState() => _GoogleSignInScreenState();
}

class _GoogleSignInScreenState extends State<GoogleSignInScreen> {
  bool _isLoading = false;
  String? _errorMessage;

  // Luồng đăng nhập Google Sign-In chuẩn bằng Firebase
  Future<void> _signInWithGoogle() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final GoogleSignIn googleSignIn = GoogleSignIn(
        serverClientId:
            '854802733120-pbkno674gofnvsoeov3h1uq6fojt6pt3.apps.googleusercontent.com',
      );
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        // Người dùng hủy đăng nhập
        if (!mounted) return;
        setState(() => _isLoading = false);
        return;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage =
            'Lỗi đăng nhập Google: $e\n(Nếu chạy trên emulator không có Google Play Services hoặc chưa thêm SHA-1 trên Firebase Console, bạn có thể nhấn "Thử nghiệm mẫu Profile" bên dưới để kiểm tra giao diện & flow).';
      });
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  // Chế độ mô phỏng hiển thị profile khi chưa gắn SHA-1 trên Google Cloud
  void _signInDemoMode() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const DemoProfileScreen(
          name: 'Nguyễn Văn A',
          email: 'nguyenvana@gmail.com',
          photoUrl: 'https://lh3.googleusercontent.com/a/default-user=s96-c',
          uid: 'demo_google_user_998877',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lab 10.4: Firebase Google Sign-In'),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Image.network(
                  'https://upload.wikimedia.org/wikipedia/commons/thumb/c/c1/Google_%22G%22_logo.svg/768px-Google_%22G%22_logo.svg.png',
                  height: 64,
                  errorBuilder: (ctx, err, stack) =>
                      const Icon(Icons.g_mobiledata, size: 72, color: Colors.red),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Firebase Authentication',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Đăng nhập tài khoản Google và quản lý thông tin hồ sơ người dùng',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey, fontSize: 13),
                ),
                const SizedBox(height: 32),
                if (_errorMessage != null)
                  Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: Colors.amber.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.amber.shade400),
                    ),
                    child: Text(
                      _errorMessage!,
                      style: TextStyle(color: Colors.amber.shade900, fontSize: 12),
                    ),
                  ),
                ElevatedButton.icon(
                  onPressed: _isLoading ? null : _signInWithGoogle,
                  icon: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.login),
                  label: const Text(
                    'Đăng nhập với Google',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black87,
                    side: const BorderSide(color: Colors.black26),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    elevation: 2,
                  ),
                ),
                const SizedBox(height: 16),
                OutlinedButton.icon(
                  onPressed: _signInDemoMode,
                  icon: const Icon(Icons.visibility),
                  label: const Text('Xem Demo màn hình Profile (Offline Mode)'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Màn hình Profile của User đăng nhập thành công qua Firebase Google
class ProfileScreen extends StatelessWidget {
  final User user;

  const ProfileScreen({super.key, required this.user});

  Future<void> _signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hồ sơ cá nhân (Lab 10.4)'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Đăng xuất',
            onPressed: () => _signOut(context),
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                      radius: 46,
                      backgroundImage: user.photoURL != null ? NetworkImage(user.photoURL!) : null,
                      child: user.photoURL == null
                          ? const Icon(Icons.person, size: 46)
                          : null,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      user.displayName ?? 'Người dùng Google',
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user.email ?? 'Không có email',
                      style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
                    ),
                    const Divider(height: 32),
                    ListTile(
                      leading: const Icon(Icons.fingerprint, color: Colors.redAccent),
                      title: const Text('Firebase UID:'),
                      subtitle: SelectableText(
                        user.uid,
                        style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
                      ),
                    ),
                    ListTile(
                      leading: const Icon(Icons.verified, color: Colors.blue),
                      title: const Text('Nhà cung cấp:'),
                      subtitle: Text(user.providerData.map((e) => e.providerId).join(', ')),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () => _signOut(context),
                      icon: const Icon(Icons.logout),
                      label: const Text('ĐĂNG XUẤT GOOGLE'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class DemoProfileScreen extends StatelessWidget {
  final String name;
  final String email;
  final String photoUrl;
  final String uid;

  const DemoProfileScreen({
    super.key,
    required this.name,
    required this.email,
    required this.photoUrl,
    required this.uid,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Demo Profile Google (Lab 10.4)'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    radius: 46,
                    backgroundImage: NetworkImage(photoUrl),
                  ),
                  const SizedBox(height: 16),
                  Text(name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(email, style: const TextStyle(color: Colors.grey, fontSize: 14)),
                  const Divider(height: 32),
                  ListTile(
                    leading: const Icon(Icons.fingerprint, color: Colors.redAccent),
                    title: const Text('Demo UID:'),
                    subtitle: SelectableText(uid, style: const TextStyle(fontFamily: 'monospace')),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Quay lại Sign-In'),
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
