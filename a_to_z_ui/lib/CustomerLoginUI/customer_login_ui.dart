import 'package:a_to_z_dto/LoginDTO/native_login_info_dto.dart';
import 'package:a_to_z_providers/BasesProviders/base_current_login_info_provider.dart';
import 'package:a_to_z_providers/LoginProviders/customer_login_by_username_provider.dart';
import 'package:a_to_z_ui/CustomerMainMenuUI/customer_main_menu_ui.dart';
import 'package:a_to_z_ui/CustomerSignUpUI/customer_sign_in_ui.dart';
import 'package:a_to_z_ui/MusicUI/music_ui.dart';
import 'package:flutter/material.dart';
import 'package:my_widgets/TextFormsFiledsWidgets/PasswordTextFormFileds/native_password_text_form_filed.dart';
import 'package:my_widgets/TextsFiledsFunctions/TextFileds.dart';
import 'package:my_widgets/Validators/vd_not_empty.dart';
import 'package:provider/provider.dart';
import 'package:a_to_z_providers/SignUpProviders/customer_sign_uo_by_username_provider.dart';

class CustomerLoginScreenUI extends StatefulWidget {
  const CustomerLoginScreenUI({super.key});

  @override
  State<CustomerLoginScreenUI> createState() => _CustomerLoginScreenUIState();
}

class _CustomerLoginScreenUIState extends State<CustomerLoginScreenUI> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  // Track the current color index
  int _colorIndex = 0;

  // List of colors to cycle through
  final List<Color> _colorCycle = [
    Colors.blue[900]!, // Blue (initial)
    Colors.red, // Red
    Colors.orange, // Orange
    Colors.green, // Green
  ];

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // Function to handle circle tap and change color
  void _changeCircleColor() {
    setState(() {
      _colorIndex = (_colorIndex + 1) % _colorCycle.length;
    });
  }

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      // Get the provider instance
      final loginProvider = context.read<PVCustomerLoginByUsername>();

      var result = await loginProvider.login(
        ClsNativeLoginInfoDTO(
          userName: usernameController.text,
          password: passwordController.text,
        ),
      );

      if (!mounted) return;

      if (result) {
        PVBaseCurrentLoginInfo currentLogin = loginProvider;
        PVBaseCurrentLoginInfo pvbaseCurrentLoginInfo = currentLogin;

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder:
                (innerContext) => MultiProvider(
                  providers: [
                    ChangeNotifierProvider(
                      create: (_) {
                        var pv = PVSong();
                        pv.start();
                        return pv;
                      },
                    ),
                    ChangeNotifierProvider.value(value: pvbaseCurrentLoginInfo),
                    ChangeNotifierProvider(
                      create: (c) => PVMainMenuUiPagesProvider(),
                    ),
                  ],
                  child: const CustomerMainMenuUi(),
                ),
          ),
          (Route<dynamic> rr) => false,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('اسم المستخدم أو كلمة المرور غير صحيحة'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                // Header Section
                SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                _buildLogoSection(),
                const SizedBox(height: 40),

                // Login Form
                _buildLoginForm(),

                // Social Login Section - Only Google
                const SizedBox(height: 30),
                _buildGoogleLoginSection(),

                // Footer
                const SizedBox(height: 20),
                _buildFooter(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogoSection() {
    final currentColor = _colorCycle[_colorIndex];
    final currentColorWithOpacity = Color.fromRGBO(
      currentColor.r.toInt(), // Convert to int
      currentColor.g.toInt(), // Convert to int
      currentColor.b.toInt(), // Convert to int
      0.3,
    );

    return Column(
      children: [
        // Clickable circle
        GestureDetector(
          onTap: _changeCircleColor,
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: currentColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: currentColorWithOpacity,
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: const Center(
              child: Text(
                'A To Z',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'مرحباً بعودتك!',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.blue[900],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'سجل الدخول إلى حسابك للمتابعة',
          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
        ),
      ],
    );
  }

  Widget _buildLoginForm() {
    final blackWithOpacity = Color.fromRGBO(0, 0, 0, 0.1);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: blackWithOpacity, blurRadius: 15, spreadRadius: 2),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            // Username Field
            TextFields.buildInputField(
              'اسم المستخدم',
              usernameController,
              validator:
                  (value) =>
                      EmptyValidator.validateNotEmpty(value, "اسم المستخدم"),
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.right,
            ),
            const SizedBox(height: 20),

            // Password Field
            WDNativePasswordTextFormField(
              controller: passwordController,
              hintText: 'كلمة المرور',
              textDirection: TextDirection.rtl,
            ),
            const SizedBox(height: 16),

            // Forgot Password
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                onPressed: () {},
                child: Text(
                  'نسيت كلمة المرور؟',
                  style: TextStyle(color: Colors.blue[700], fontSize: 14),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Login Button with Loading State
            Consumer<PVCustomerLoginByUsername>(
              builder: (context, loginProvider, child) {
                return SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: loginProvider.isLoading ? null : _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          loginProvider.isLoading
                              ? Colors.grey[400]
                              : Colors.blue[900],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 3,
                    ),
                    child:
                        loginProvider.isLoading
                            ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                const Text(
                                  'جاري التسجيل...',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            )
                            : const Text(
                              'تسجيل الدخول',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGoogleLoginSection() {
    final blackWithOpacity = Color.fromRGBO(0, 0, 0, 0.1);

    return Column(
      children: [
        Text(
          'أو سجل الدخول باستخدام',
          style: TextStyle(color: Colors.grey[600], fontSize: 14),
        ),
        const SizedBox(height: 16),
        _buildGoogleButton(blackWithOpacity),
      ],
    );
  }

  Widget _buildGoogleButton(Color shadowColor) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(color: shadowColor, blurRadius: 8, spreadRadius: 1),
        ],
      ),
      child: IconButton(
        icon: const Icon(Icons.g_mobiledata, color: Colors.red, size: 24),
        onPressed: () {},
      ),
    );
  }

  Widget _buildFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('ليس لديك حساب؟', style: TextStyle(color: Colors.grey[600])),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (conext) => MultiProvider(
                      providers: [
                        ChangeNotifierProvider(
                          create: (c) => PVCustomerSignUoByUsername(),
                        ),
                      ],
                      child: const UICustomerSignUp(),
                    ),
              ),
            );
          },
          child: Text(
            'سجل الآن',
            style: TextStyle(
              color: Colors.blue[900],
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
