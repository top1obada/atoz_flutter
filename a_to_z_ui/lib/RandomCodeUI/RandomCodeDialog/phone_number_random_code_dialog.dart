import 'package:a_to_z_providers/BasesProviders/base_current_login_info_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:a_to_z_providers/Global/errors.dart';
import 'package:a_to_z_providers/RandomCodeProviders/phone_number_random_code_provider.dart';
import 'package:a_to_z_providers/AdminInfoProviders/admin_info_phone_number_provider.dart';
import 'package:flutter/services.dart'; // Added for Clipboard

class PhoneVerificationScreen extends StatefulWidget {
  final Function(String)? onVerificationInitiated;

  const PhoneVerificationScreen({super.key, this.onVerificationInitiated});

  @override
  State<PhoneVerificationScreen> createState() =>
      _PhoneVerificationScreenState();
}

class _PhoneVerificationScreenState extends State<PhoneVerificationScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // Set initial prefix
    _phoneController.text = '+9639';
    _phoneController.selection = TextSelection.collapsed(
      offset: '+9639'.length,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await context.read<PVAdminInfoPhoneNumber>().getAdminInfoPhoneNumber(1);
    });
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  String? _validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty || value == '+9639') {
      return 'يرجى إدخال رقم الهاتف';
    }

    // Validate format: +9639 followed by exactly 8 digits
    final phoneRegex = RegExp(r'^\+9639[0-9]{8}$');
    if (!phoneRegex.hasMatch(value)) {
      return 'يجب أن يبدأ الرقم بـ +9639 ويتبعه 8 أرقام';
    }

    return null;
  }

  void _onPhoneNumberChanged(String value) {
    // Prevent deletion of the prefix
    if (!value.startsWith('+9639')) {
      _phoneController.text = '+9639';
      _phoneController.selection = TextSelection.collapsed(
        offset: '+9639'.length,
      );
      return;
    }

    // Limit to 13 characters total (+9639 + 8 digits = 13)
    if (value.length > 13) {
      _phoneController.text = value.substring(0, 13);
      _phoneController.selection = TextSelection.collapsed(offset: 13);
    }

    // Allow only digits after the prefix
    if (value.length > '+9639'.length) {
      final suffix = value.substring('+9639'.length);
      if (!RegExp(r'^[0-9]*$').hasMatch(suffix)) {
        _phoneController.text =
            '+9639' + suffix.replaceAll(RegExp(r'[^0-9]'), '');
        _phoneController.selection = TextSelection.collapsed(
          offset: _phoneController.text.length,
        );
      }
    }
  }

  void _onAddNumberPressed() {
    if (_formKey.currentState?.validate() ?? false) {
      final phoneNumber = _phoneController.text;
      context.read<PVPhoneNumberRandomCode>().getPhoneNumberRandomCode(
        phoneNumber,
        context,
      );
      widget.onVerificationInitiated?.call(phoneNumber);
    }
  }

  void _onCancelPressed() {
    Navigator.of(context).pop();
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('تم نسخ الرمز إلى الحافظة'),
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.green[700],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PVPhoneNumberRandomCode>(
      builder: (context, provider, child) {
        final hasCode = provider.randomCode != null;

        return Scaffold(
          appBar: AppBar(
            title: const Text('تحقق من رقم الهاتف'),
            centerTitle: true,
            backgroundColor: Colors.blue[800],
            foregroundColor: Colors.white,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: _onCancelPressed,
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Consumer<PVAdminInfoPhoneNumber>(
                  builder: (context, provider, child) {
                    String explanationText;

                    if (provider.isLoading) {
                      explanationText = 'جاري جلب رقم المسؤول...';
                    } else if (provider.phoneNumber != null) {
                      explanationText =
                          'اكتب رقم هاتفك هنا، بعد ذلك سوف تستلم رمز تحقق. عندما تستلم الرمز، أرسله إلى الرقم ${provider.phoneNumber} على الواتساب باستخدام نفس الرقم الذي كتبته. سيتم التحقق من رقمك من قبل المسؤول خلال وقت قصير.';
                    } else if (Errors.errorMessage != null) {
                      explanationText =
                          'حدث خطأ في جلب رقم المسؤول. يرجى المحاولة مرة أخرى لاحقاً.';
                    } else {
                      explanationText =
                          'اكتب رقم هاتفك هنا، بعد ذلك سوف تستلم رمز تحقق. عندما تستلم الرمز، أرسله إلى رقم المسؤول على الواتساب باستخدام نفس الرقم الذي كتبته. سيتم التحقق من رقمك من قبل المسؤول خلال وقت قصير.';
                    }

                    return Text(
                      explanationText,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[700],
                        height: 1.5,
                      ),
                      textAlign: TextAlign.right,
                    );
                  },
                ),

                const SizedBox(height: 32),

                // Phone Number Input Field (hidden when code is generated)
                if (!hasCode) ...[
                  Form(
                    key: _formKey,
                    child: TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      textAlign: TextAlign.right,
                      enabled:
                          !provider.isLoading && provider.randomCode == null,
                      onChanged: _onPhoneNumberChanged,
                      decoration: InputDecoration(
                        labelText: 'رقم الهاتف',
                        labelStyle: TextStyle(color: Colors.blue[700]),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.blue[300]!),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.blue[500]!),
                        ),
                        filled: true,
                        fillColor: Colors.grey[50],
                        prefixIcon: Icon(Icons.phone, color: Colors.blue[700]),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        prefix: const Text(
                          '+9639',
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      validator: _validatePhoneNumber,
                      maxLength: 13,
                    ),
                  ),
                  const SizedBox(height: 24),
                ],

                // Result Area (Loading or Random Code)
                if (provider.isLoading)
                  Center(
                    child: Column(
                      children: [
                        CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.blue[700]!,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'جاري إنشاء رمز التحقق...',
                          style: TextStyle(
                            color: Colors.blue[700],
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  )
                else if (hasCode)
                  GestureDetector(
                    onTap: () => _copyToClipboard(provider.randomCode!),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.green[50],
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.green[300]!),
                      ),
                      child: Column(
                        children: [
                          Text(
                            'رمز التحقق:',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.green[800],
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                provider.randomCode!,
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green[700],
                                  letterSpacing: 2,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Icon(
                                Icons.content_copy,
                                color: Colors.green[600],
                                size: 20,
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'انقر فوق الرمز لنسخه\nثم أرسله على الواتساب للتحقق',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.green[600],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  )
                else if (Errors.errorMessage != null)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.red[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.red[300]!),
                    ),
                    child: Text(
                      Errors.errorMessage!,
                      style: TextStyle(color: Colors.red[700], fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ),

                const SizedBox(height: 32),

                // Buttons Row (only visible when no code is generated)
                if (!hasCode && !provider.isLoading)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Cancel Button
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _onCancelPressed,
                          style: OutlinedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.red[700],
                            side: BorderSide(color: Colors.red[300]!),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: const Text(
                            'إلغاء',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 16),

                      // Add Number Button
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _onAddNumberPressed,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue[700],
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            elevation: 2,
                          ),
                          child: const Text(
                            'إضافة الرقم',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// Usage function to show the full-screen dialog
Future<void> showPhoneVerificationScreen({
  required BuildContext context,
  Function(String)? onVerificationInitiated,
}) {
  return Navigator.of(context).push(
    MaterialPageRoute(
      builder:
          (con) => MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (_) => PVPhoneNumberRandomCode()),
              ChangeNotifierProvider(create: (_) => PVAdminInfoPhoneNumber()),
              ChangeNotifierProvider.value(
                value: context.read<PVBaseCurrentLoginInfo>(),
              ),
            ],
            child: PhoneVerificationScreen(
              onVerificationInitiated: onVerificationInitiated,
            ),
          ),
      fullscreenDialog: true,
    ),
  );
}
