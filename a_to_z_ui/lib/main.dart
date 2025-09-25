import 'package:a_to_z_ui/SplashScreen/second_splash_screen_ui.dart';
import 'package:audio_session/audio_session.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:a_to_z_ui/CustomerLoginUI/customer_login_ui.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final session = await AudioSession.instance;

  await session.configure(const AudioSessionConfiguration.music());

  runApp(MaterialApp(home: const SplashScreen()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => const MaterialApp(
    debugShowCheckedModeBanner: false,
    title: "A To Z",
    home: CustomerLoginScreenUI(),
  );
}

class GoogleLoginPage extends StatefulWidget {
  const GoogleLoginPage({super.key});

  @override
  State<GoogleLoginPage> createState() => _GoogleLoginPageState();
}

class _GoogleLoginPageState extends State<GoogleLoginPage> {
  final List<String> scopes = [
    'email',
    'https://www.googleapis.com/auth/userinfo.profile',
    'https://www.googleapis.com/auth/user.birthday.read',
    'https://www.googleapis.com/auth/user.gender.read',
  ];

  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  GoogleSignInAccount? _user;
  String? _accessToken;
  String? _gender;
  String? _birthday;

  Future<void> _handleSignIn() async {
    try {
      final account = await _googleSignIn.authenticate();
      if (account == null) return; // المستخدم لغى تسجيل الدخول
      _user = account;

      // جلب الـ accessToken
      final auth = await account.authorizationClient.authorizationForScopes(
        scopes,
      );
      _accessToken = auth?.accessToken;

      if (_accessToken != null) {
        await _fetchExtraInfo(_accessToken!);
      }

      setState(() {});
    } catch (e) {
      debugPrint('Error during sign-in: $e');
    }
  }

  Future<void> _fetchExtraInfo(String token) async {
    final response = await http.get(
      Uri.parse(
        'https://people.googleapis.com/v1/people/me?personFields=genders,birthdays',
      ),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final genders = data['genders'] as List<dynamic>?;
      final birthdays = data['birthdays'] as List<dynamic>?;

      _gender = genders?.isNotEmpty == true ? genders![0]['value'] : 'غير محدد';
      _birthday =
          birthdays?.isNotEmpty == true
              ? birthdays![0]['date'].toString()
              : 'غير محدد';

      setState(() {});
    } else {
      debugPrint('Failed fetching extra data: ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text("Google Sign-In v7")),
    body: Center(
      child:
          _user == null
              ? ElevatedButton(
                onPressed: _handleSignIn,
                child: const Text("تسجيل الدخول عبر غوغل"),
              )
              : SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("مرحباً ${_user!.displayName}"),
                    const SizedBox(height: 10),
                    Text("Email: ${_user!.email}"),
                    const SizedBox(height: 10),
                    Text("Access Token: $_accessToken"),
                    const SizedBox(height: 10),
                    Text("Gender: $_gender"),
                    const SizedBox(height: 10),
                    Text("Birthday: $_birthday"),
                  ],
                ),
              ),
    ),
  );
}
