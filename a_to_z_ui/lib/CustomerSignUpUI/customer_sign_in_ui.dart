import 'package:a_to_z_dto/CustomerDTO/customer_sign_up_by_username_dto.dart';
import 'package:a_to_z_dto/LoginDTO/native_login_info_dto.dart';
import 'package:a_to_z_dto/PersonDTO/person_dto.dart';
import 'package:a_to_z_providers/BasesProviders/base_current_login_info_provider.dart';
import 'package:a_to_z_providers/SignUpProviders/customer_sign_uo_by_username_provider.dart';
import 'package:a_to_z_ui/CustomerMainMenuUI/customer_main_menu_ui.dart';
import 'package:a_to_z_ui/MusicUI/music_ui.dart';
import 'package:flutter/material.dart';
import 'package:my_widgets/CountriesWidgets/countries_drop_down_list_widget.dart';
import 'package:my_widgets/DateTimeWidgets/wd_date_time.dart';
import 'package:my_widgets/TextFormsFiledsWidgets/PasswordTextFormFileds/native_password_text_form_filed.dart';
import 'package:my_widgets/TextsFiledsFunctions/TextFileds.dart';
import 'package:my_widgets/Validators/vd_not_empty.dart';
import 'package:my_widgets/GenderWidgets/gender_selector_widget.dart';
import 'package:provider/provider.dart';

class UICustomerSignUp extends StatefulWidget {
  const UICustomerSignUp({super.key});

  @override
  State<UICustomerSignUp> createState() => _UICustomerSignUp();
}

class _UICustomerSignUp extends State<UICustomerSignUp> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for required fields only
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController birthdayController = TextEditingController();
  String? nationality;
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String gender = ''; // selected gender

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    birthdayController.dispose();
    userNameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _signUp() async {
    if (!_formKey.currentState!.validate()) return;

    // Get the provider instance
    final signUpProvider = context.read<PVCustomerSignUoByUsername>();

    ClsSignUpCustomerByUserNameDTO signUpCustomerByUserNameDTO =
        ClsSignUpCustomerByUserNameDTO(
          person: ClsPersonDTO(
            firstName: firstNameController.text.trim(),
            lastName: lastNameController.text.trim(),
            nationality: nationality,
            gender: gender.trim(),
            birthDate: DateTime.tryParse(birthdayController.text.trim()),
          ),
          nativeLoginInfoDTO: ClsNativeLoginInfoDTO(
            userName: userNameController.text.trim(),
            password: passwordController.text.trim(),
          ),
        );

    final result = await signUpProvider.signUp(signUpCustomerByUserNameDTO);

    if (!mounted) return;

    if (!result) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('فشل في إنشاء الحساب'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    PVBaseCurrentLoginInfo pvbaseCurrentLoginInfo = signUpProvider;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder:
            (innerContext) => MultiProvider(
              providers: [
                ChangeNotifierProvider(create: (_) => PVSong()),
                ChangeNotifierProvider.value(value: pvbaseCurrentLoginInfo),
                ChangeNotifierProvider(
                  create: (_) => PVMainMenuUiPagesProvider(),
                ),
              ],
              child: const CustomerMainMenuUi(),
            ),
      ),
      (Route<dynamic> rr) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 20),
                  Center(
                    child: Text(
                      'إنشاء حساب جديد',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[900],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Personal Information Section
                  Text(
                    'المعلومات الشخصية',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // First Name
                  TextFields.buildInputField(
                    'الاسم الأول',
                    firstNameController,
                    validator:
                        (val) =>
                            EmptyValidator.validateNotEmpty(val, 'الاسم الأول'),
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.right,
                  ),
                  const SizedBox(height: 12),

                  // Last Name
                  TextFields.buildInputField(
                    'الاسم الأخير',
                    lastNameController,
                    validator:
                        (val) => EmptyValidator.validateNotEmpty(
                          val,
                          'الاسم الأخير',
                        ),
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.right,
                  ),
                  const SizedBox(height: 12),

                  // Birth Date
                  WDBirthDatePicker(
                    controller: birthdayController,
                    validator:
                        (val) => EmptyValidator.validateNotEmpty(
                          val,
                          'تاريخ الميلاد',
                        ),
                  ),
                  const SizedBox(height: 12),

                  // Gender
                  WDGenderSelector(
                    onChanged: (val) => gender = val,
                    textDirection: TextDirection.rtl,
                  ),
                  const SizedBox(height: 12),

                  // Nationality
                  WDCountriesDropdown(
                    text: 'الجنسية',
                    onChanged: (val) => nationality = val,
                  ),
                  const SizedBox(height: 20),

                  const Divider(),

                  // Account Credentials Section
                  Text(
                    'بيانات الحساب',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Username
                  TextFields.buildInputField(
                    'اسم المستخدم',
                    userNameController,
                    validator:
                        (val) => EmptyValidator.validateNotEmpty(
                          val,
                          'اسم المستخدم',
                        ),
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.right,
                  ),
                  const SizedBox(height: 12),

                  // Password
                  WDNativePasswordTextFormField(
                    controller: passwordController,
                    hintText: 'كلمة المرور',
                    textDirection: TextDirection.rtl,
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Directionality(
        textDirection: TextDirection.rtl,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Consumer<PVCustomerSignUoByUsername>(
              builder: (context, signUpProvider, child) {
                return SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: signUpProvider.isLoading ? null : _signUp,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          signUpProvider.isLoading
                              ? Colors.grey[400]
                              : Colors.blue[700],
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child:
                        signUpProvider.isLoading
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
                                  'جاري إنشاء الحساب...',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            )
                            : const Text(
                              'تسجيل',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
