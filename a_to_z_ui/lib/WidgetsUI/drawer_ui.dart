import 'package:a_to_z_providers/AddressProviders/find_address_provider.dart';
import 'package:a_to_z_providers/BasesProviders/base_current_login_info_provider.dart';
import 'package:a_to_z_providers/ContactInformationsProviders/get_person_contact_information_provider.dart';
import 'package:a_to_z_providers/CustomerBalanceProviders/customer_balance_payments_history_and_customer_balance_provider.dart';
import 'package:a_to_z_providers/LoginProviders/customer_login_by_username_provider.dart';
import 'package:a_to_z_providers/PersonProviders/get_person_info_provider.dart';
import 'package:a_to_z_providers/RandomCodeProviders/phone_number_random_code_provider.dart';
import 'package:a_to_z_providers/RequestProviders/customer_requests_provider.dart';
import 'package:a_to_z_ui/CustomerLoginUI/customer_login_ui.dart';
import 'package:a_to_z_ui/MusicUI/music_ui.dart';
import 'package:a_to_z_ui/ProfileUI/profile_ui.dart';
import 'package:a_to_z_ui/RandomCodeUI/RandomCodeDialog/phone_number_random_code_dialog.dart';
import 'package:a_to_z_ui/RequestUI/customer_requests_ui.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:a_to_z_ui/CustomerBalanceUI/customer_balance_payments_history_and_customer_balance_ui.dart';
import 'package:a_to_z_providers/AddressProviders/add_address_provider.dart';

class BaseDrawer extends StatelessWidget {
  const BaseDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: ListView(
            children: [
              Container(
                width: double.infinity,
                height: 140,
                decoration: BoxDecoration(
                  color: Colors.blue.shade100,
                  borderRadius: BorderRadius.circular(70),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.shade200.withAlpha(
                        (0.5 * 255).round(),
                      ),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Align(
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.store,
                    size: 80,
                    color: Colors.blue.shade700,
                  ),
                ),
              ),

              const Divider(),

              // Profile
              ListTile(
                leading: const Icon(Icons.account_circle, color: Colors.blue),
                title: const Text(
                  'ملفي الشخصي',
                  textDirection: TextDirection.rtl,
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (con) => MultiProvider(
                            providers: [
                              ChangeNotifierProvider(
                                create: (_) => PVAddAddress(),
                              ),
                              ChangeNotifierProvider(
                                create: (_) => PVFindAddress(),
                              ),
                              ChangeNotifierProvider(
                                create: (_) => PVGetPersonInfo(),
                              ),
                              ChangeNotifierProvider(
                                create: (_) => PVGetPersonContactInfo(),
                              ),
                              ChangeNotifierProvider(
                                create: (_) => PVPhoneNumberRandomCode(),
                              ),
                              ChangeNotifierProvider.value(
                                value: context.read<PVBaseCurrentLoginInfo>(),
                              ),
                            ],
                            child: const ProfileUi(),
                          ),
                    ),
                  );
                },
              ),

              // Requests
              ListTile(
                leading: const Icon(Icons.assignment, color: Colors.orange),
                title: const Text('طلباتي', textDirection: TextDirection.rtl),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (con) => MultiProvider(
                            providers: [
                              ChangeNotifierProvider.value(
                                value: context.read<PVBaseCurrentLoginInfo>(),
                              ),
                              ChangeNotifierProvider(
                                create: (_) => PVCustomerRequests(),
                              ),
                            ],
                            child: const CustomerRequestsScreen(),
                          ),
                    ),
                  );
                },
              ),

              // Licenses

              // Book Test
              ListTile(
                leading: const Icon(
                  Icons.account_balance_wallet,
                  color: Colors.teal,
                ),
                title: const Text('رصيدي', textDirection: TextDirection.rtl),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (con) => MultiProvider(
                            providers: [
                              ChangeNotifierProvider.value(
                                value: context.read<PVBaseCurrentLoginInfo>(),
                              ),
                              ChangeNotifierProvider(
                                create:
                                    (_) =>
                                        PVCustomerBalancePaymentsHistoryAndCustomerBalance(),
                              ),
                            ],
                            child: const CustomerBalanceScreen(),
                          ),
                    ),
                  );
                },
              ),

              // Appointments
              ListTile(
                leading: const Icon(Icons.phone, color: Colors.teal),
                title: const Text(
                  'مصادقة رقم الهاتف',
                  textDirection: TextDirection.rtl,
                ),
                onTap: () {
                  showPhoneVerificationScreen(context: context);
                },
              ),

              // Payments
              const Divider(),

              // Settings
              ListTile(
                leading: const Icon(Icons.music_note, color: Colors.grey),
                title: const Text('الموسيقى', textDirection: TextDirection.rtl),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (_) => ChangeNotifierProvider.value(
                            value: context.read<PVSong>(),
                            child: const MusicRadioPage(),
                          ),
                    ),
                  );
                },
              ),

              // Help
              ListTile(
                leading: const Icon(Icons.help_outline, color: Colors.blueGrey),
                title: const Text(
                  'المساعدة والأسئلة الشائعة',
                  textDirection: TextDirection.rtl,
                ),
                onTap: () {},
              ),

              // Logout
              ListTile(
                leading: const Icon(Icons.exit_to_app, color: Colors.red),
                title: const Text(
                  'تسجيل الخروج',
                  textDirection: TextDirection.rtl,
                ),
                onTap: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder:
                          (con) => ChangeNotifierProvider.value(
                            value: context.read<PVCustomerLoginByUsername>(),
                            child: const CustomerLoginScreenUI(),
                          ),
                    ),
                    (Route<dynamic> route) => false,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
