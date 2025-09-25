import 'package:a_to_z_dto/LoginDTO/retriving_login_dto.dart';
import 'package:a_to_z_providers/AddressProviders/add_address_provider.dart';
import 'package:a_to_z_providers/AddressProviders/find_address_provider.dart';
import 'package:a_to_z_providers/AddressProviders/update_address_provider.dart';
import 'package:a_to_z_providers/AdminInfoProviders/admin_info_phone_number_provider.dart';
import 'package:a_to_z_providers/BasesProviders/base_current_login_info_provider.dart';
import 'package:a_to_z_providers/Global/errors.dart';
import 'package:a_to_z_providers/PersonProviders/get_person_info_provider.dart';
import 'package:a_to_z_providers/RandomCodeProviders/phone_number_random_code_provider.dart';
import 'package:a_to_z_ui/AddressUI/add_address_ui.dart';
import 'package:a_to_z_ui/AddressUI/update_address_ui.dart';
import 'package:a_to_z_ui/RandomCodeUI/RandomCodeDialog/phone_number_random_code_dialog.dart';
import 'package:a_to_z_widgets/ATOZAnimations/a_to_z_animation.dart';
import 'package:a_to_z_widgets/AddressWidgets/show_address_widget.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart' as material;
import 'package:provider/provider.dart';
import 'package:a_to_z_providers/ContactInformationsProviders/get_person_contact_information_provider.dart';
import 'package:a_to_z_widgets/PersonWidgets/show_person_widget.dart';
import 'package:a_to_z_widgets/ContactInformationWidgets/show_contact_information_widget.dart';

class ProfileUi extends StatefulWidget {
  const ProfileUi({super.key});

  @override
  State<ProfileUi> createState() {
    return _ProfileUI();
  }
}

class _ProfileUI extends State<ProfileUi> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await context.read<PVGetPersonInfo>().getPersonInfo(
        context.read<PVBaseCurrentLoginInfo>().retrivingLoggedInDTO!.personID!,
      );

      await context.read<PVGetPersonContactInfo>().getPersonContactInfo(
        context.read<PVBaseCurrentLoginInfo>().retrivingLoggedInDTO!.personID!,
      );

      await context.read<PVFindAddress>().findAddress(
        context.read<PVBaseCurrentLoginInfo>().retrivingLoggedInDTO!.personID!,
      );
    });
  }

  void _onBackPressed() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        decoration: const BoxDecoration(
          gradient: material.LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [material.Color(0xFF667eea), material.Color(0xFF764ba2)],
          ),
        ),
        child: material.Scaffold(
          backgroundColor: material.Colors.transparent,
          appBar: material.AppBar(
            backgroundColor: material.Colors.transparent,
            elevation: 0,
            leading: material.IconButton(
              icon: const material.Icon(
                material.Icons.arrow_back,
                color: material.Colors.white,
              ),
              onPressed: _onBackPressed,
            ),
            title: const material.Text(
              'الملف الشخصي',
              style: material.TextStyle(
                color: material.Colors.white,
                fontWeight: material.FontWeight.bold,
              ),
            ),
            centerTitle: true,
          ),
          body: material.SafeArea(
            child: material.SingleChildScrollView(
              padding: const material.EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Personal Information Section
                  Container(
                    width: double.infinity,
                    margin: const material.EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: material.Colors.white.withValues(alpha: 0.95),
                      borderRadius: material.BorderRadius.circular(20),
                      boxShadow: [
                        material.BoxShadow(
                          color: material.Colors.black.withValues(alpha: 0.1),
                          blurRadius: 10,
                          offset: const material.Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Consumer<PVGetPersonInfo>(
                      builder: (con, value, child) {
                        if (value.personInfo == null) {
                          if (value.isLoading) {
                            return Container(
                              padding: const material.EdgeInsets.all(40),
                              child: const Center(child: AtoZLoader()),
                            );
                          } else {
                            if (!value.isLoaded) return Container();
                            return Container(
                              padding: const material.EdgeInsets.all(20),
                              child: Text(
                                Errors.errorMessage!,
                                textAlign: TextAlign.center,
                                style: const material.TextStyle(
                                  color: material.Colors.red,
                                  fontSize: 16,
                                  fontWeight: material.FontWeight.w500,
                                ),
                              ),
                            );
                          }
                        }
                        return material.Padding(
                          padding: const material.EdgeInsets.all(16.0),
                          child: WDPersonInfoCard(
                            personInfo: value.personInfo!,
                          ),
                        );
                      },
                    ),
                  ),

                  // Contact Information Section
                  Container(
                    width: double.infinity,
                    margin: const material.EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: material.Colors.white.withValues(alpha: 0.95),
                      borderRadius: material.BorderRadius.circular(20),
                      boxShadow: [
                        material.BoxShadow(
                          color: material.Colors.black.withValues(alpha: 0.1),
                          blurRadius: 10,
                          offset: const material.Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Consumer<PVPhoneNumberRandomCode>(
                      builder: (con, bigvalue, child) {
                        return Consumer<PVGetPersonContactInfo>(
                          builder: (con, value, child) {
                            EnVerifyPhoneNumberMode verifyPhoneNumberMode =
                                context
                                    .read<PVBaseCurrentLoginInfo>()
                                    .retrivingLoggedInDTO!
                                    .verifyPhoneNumberMode!;

                            if (verifyPhoneNumberMode ==
                                EnVerifyPhoneNumberMode.eNotVerified) {
                              return material.Padding(
                                padding: const material.EdgeInsets.all(16.0),
                                child: Column(
                                  children: [
                                    Container(
                                      padding: const material.EdgeInsets.all(
                                        16,
                                      ),
                                      decoration: BoxDecoration(
                                        color: material.Colors.orange
                                            .withValues(alpha: 0.1),
                                        borderRadius: material
                                            .BorderRadius.circular(12),
                                        border: material.Border.all(
                                          color: material.Colors.orange
                                              .withValues(alpha: 0.3),
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          material.Icon(
                                            material
                                                .Icons
                                                .warning_amber_rounded,
                                            color: material.Colors.orange[700],
                                            size: 24,
                                          ),
                                          const material.SizedBox(width: 12),
                                          material.Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'تحقق من رقم الهاتف',
                                                  style: material.TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        material
                                                            .FontWeight
                                                            .bold,
                                                    color:
                                                        material
                                                            .Colors
                                                            .orange[800],
                                                  ),
                                                ),
                                                const material.SizedBox(
                                                  height: 4,
                                                ),
                                                Text(
                                                  'يجب التحقق من رقم هاتفك للمتابعة',
                                                  style: material.TextStyle(
                                                    fontSize: 14,
                                                    color:
                                                        material
                                                            .Colors
                                                            .orange[700],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                              gradient: material.LinearGradient(
                                                colors: [
                                                  material.Colors.orange[400]!,
                                                  material.Colors.orange[600]!,
                                                ],
                                              ),
                                              borderRadius: material
                                                  .BorderRadius.circular(8),
                                            ),
                                            child: material.TextButton(
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  material.MaterialPageRoute(
                                                    builder: (con) {
                                                      return MultiProvider(
                                                        providers: [
                                                          ChangeNotifierProvider.value(
                                                            value:
                                                                context
                                                                    .read<
                                                                      PVBaseCurrentLoginInfo
                                                                    >(),
                                                          ),
                                                          ChangeNotifierProvider.value(
                                                            value: bigvalue,
                                                          ),
                                                          ChangeNotifierProvider(
                                                            create:
                                                                (_) =>
                                                                    PVAdminInfoPhoneNumber(),
                                                          ),
                                                        ],
                                                        child:
                                                            const PhoneVerificationScreen(),
                                                      );
                                                    },
                                                  ),
                                                );
                                              },
                                              child: const Text(
                                                'تحقق الآن',
                                                style: material.TextStyle(
                                                  color: material.Colors.white,
                                                  fontWeight:
                                                      material.FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const material.SizedBox(height: 12),
                                    _buildContactInfo(value),
                                  ],
                                ),
                              );
                            }
                            if (verifyPhoneNumberMode ==
                                EnVerifyPhoneNumberMode.eVerifyProcess) {
                              return material.Padding(
                                padding: const material.EdgeInsets.all(16.0),
                                child: Column(
                                  children: [
                                    Container(
                                      padding: const material.EdgeInsets.all(
                                        16,
                                      ),
                                      decoration: BoxDecoration(
                                        color: material.Colors.blue.withValues(
                                          alpha: 0.1,
                                        ),
                                        borderRadius: material
                                            .BorderRadius.circular(12),
                                        border: material.Border.all(
                                          color: material.Colors.blue
                                              .withValues(alpha: 0.3),
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          material.Icon(
                                            material.Icons.access_time_rounded,
                                            color: material.Colors.blue[700],
                                            size: 24,
                                          ),
                                          const material.SizedBox(width: 12),
                                          material.Expanded(
                                            child: Text(
                                              'رقم هاتفك قيد التحقق حالياً',
                                              style: material.TextStyle(
                                                fontSize: 16,
                                                fontWeight:
                                                    material.FontWeight.bold,
                                                color:
                                                    material.Colors.blue[800],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const material.SizedBox(height: 12),
                                    _buildContactInfo(value),
                                  ],
                                ),
                              );
                            }
                            if (value.contactInfo == null) {
                              if (value.isLoading) {
                                return Container(
                                  padding: const material.EdgeInsets.all(40),
                                  child: const Center(child: AtoZLoader()),
                                );
                              } else {
                                return Container(
                                  padding: const material.EdgeInsets.all(20),
                                  child: Text(
                                    'لا توجد معلومات اتصال متاحة',
                                    textAlign: TextAlign.center,
                                    style: material.TextStyle(
                                      color: material.Colors.grey[600],
                                      fontSize: 16,
                                    ),
                                  ),
                                );
                              }
                            }
                            return material.Padding(
                              padding: const material.EdgeInsets.all(16.0),
                              child: WDContactInfoCard(
                                contactInfo: value.contactInfo!,
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),

                  // Address Section
                  Container(
                    width: double.infinity,
                    margin: const material.EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: material.Colors.white.withValues(alpha: 0.95),
                      borderRadius: material.BorderRadius.circular(20),
                      boxShadow: [
                        material.BoxShadow(
                          color: material.Colors.black.withValues(alpha: 0.1),
                          blurRadius: 10,
                          offset: const material.Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Consumer<PVAddAddress>(
                      builder: (con, bigvalue, child) {
                        return Consumer<PVFindAddress>(
                          builder: (c, value, child) {
                            if (!context
                                .read<PVBaseCurrentLoginInfo>()
                                .retrivingLoggedInDTO!
                                .isAddressInfoConifrmed!) {
                              return material.Padding(
                                padding: const material.EdgeInsets.all(16.0),
                                child: Column(
                                  children: [
                                    Container(
                                      padding: const material.EdgeInsets.all(
                                        16,
                                      ),
                                      decoration: BoxDecoration(
                                        color: material.Colors.red.withValues(
                                          alpha: 0.1,
                                        ),
                                        borderRadius: material
                                            .BorderRadius.circular(12),
                                        border: material.Border.all(
                                          color: material.Colors.red.withValues(
                                            alpha: 0.3,
                                          ),
                                        ),
                                      ),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              material.Icon(
                                                material
                                                    .Icons
                                                    .location_off_rounded,
                                                color: material.Colors.red[700],
                                                size: 24,
                                              ),
                                              const material.SizedBox(
                                                width: 12,
                                              ),
                                              material.Expanded(
                                                child: Text(
                                                  'تأكيد العنوان المطلوب',
                                                  style: material.TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        material
                                                            .FontWeight
                                                            .bold,
                                                    color:
                                                        material
                                                            .Colors
                                                            .red[800],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const material.SizedBox(height: 8),
                                          Text(
                                            'يجب إضافة عنوانك لتأكيد موقعك الجغرافي',
                                            style: material.TextStyle(
                                              fontSize: 14,
                                              color: material.Colors.red[700],
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                          const material.SizedBox(height: 12),
                                          Container(
                                            decoration: BoxDecoration(
                                              gradient: material.LinearGradient(
                                                colors: [
                                                  material.Colors.red[400]!,
                                                  material.Colors.red[600]!,
                                                ],
                                              ),
                                              borderRadius: material
                                                  .BorderRadius.circular(8),
                                            ),
                                            child: material.TextButton(
                                              onPressed: () {
                                                Navigator.push(
                                                  con,
                                                  material.MaterialPageRoute(
                                                    builder: (_) {
                                                      return MultiProvider(
                                                        providers: [
                                                          ChangeNotifierProvider.value(
                                                            value:
                                                                context
                                                                    .read<
                                                                      PVBaseCurrentLoginInfo
                                                                    >(),
                                                          ),
                                                          ChangeNotifierProvider(
                                                            create:
                                                                (_) => bigvalue,
                                                          ),
                                                        ],

                                                        child:
                                                            const AddAddressUi(),
                                                      );
                                                    },
                                                  ),
                                                );
                                              },
                                              child: const Text(
                                                'إضافة العنوان',
                                                style: material.TextStyle(
                                                  color: material.Colors.white,
                                                  fontWeight:
                                                      material.FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const material.SizedBox(height: 12),
                                  ],
                                ),
                              );
                            } else {
                              if (value.address == null) {
                                if (value.isLoading) {
                                  return Container(
                                    padding: const material.EdgeInsets.all(40),
                                    child: const Center(child: AtoZLoader()),
                                  );
                                } else {
                                  if (bigvalue.addressID != null) {
                                    value.findAddress(
                                      context
                                          .read<PVBaseCurrentLoginInfo>()
                                          .retrivingLoggedInDTO!
                                          .personID!,
                                    );
                                  }

                                  if (!value.isLoaded) return Container();
                                  return Container(
                                    padding: const material.EdgeInsets.all(20),
                                    child: Text(
                                      'لا توجد معلومات عنوان متاحة',
                                      textAlign: TextAlign.center,
                                      style: material.TextStyle(
                                        color: material.Colors.grey[600],
                                        fontSize: 16,
                                      ),
                                    ),
                                  );
                                }
                              }
                              return material.Padding(
                                padding: const material.EdgeInsets.all(16.0),
                                child: Column(
                                  children: [
                                    WDAddressCard(address: value.address!),
                                    const material.SizedBox(height: 12),
                                    Container(
                                      decoration: BoxDecoration(
                                        gradient: material.LinearGradient(
                                          colors: [
                                            material.Colors.green[400]!,
                                            material.Colors.green[600]!,
                                          ],
                                        ),
                                        borderRadius: material
                                            .BorderRadius.circular(8),
                                      ),
                                      child: material.TextButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            material.MaterialPageRoute(
                                              builder:
                                                  (con) => MultiProvider(
                                                    providers: [
                                                      ChangeNotifierProvider(
                                                        create:
                                                            (_) =>
                                                                PVFindAddress(),
                                                      ),
                                                      ChangeNotifierProvider(
                                                        create:
                                                            (_) =>
                                                                PVUpdateAddress(),
                                                      ),
                                                    ],
                                                    child: UpdateAddressScreen(
                                                      addressID:
                                                          value
                                                              .address!
                                                              .addressID!,
                                                    ),
                                                  ),
                                            ),
                                          ).then((v) {
                                            value.findAddress(
                                              value.address!.addressID!,
                                            );
                                          });
                                        },
                                        child: const Text(
                                          'تحديث العنوان',
                                          style: material.TextStyle(
                                            color: material.Colors.white,
                                            fontWeight:
                                                material.FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }
                          },
                        );
                      },
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

  Widget _buildContactInfo(PVGetPersonContactInfo value) {
    if (value.contactInfo == null) {
      if (value.isLoading) {
        return Container(
          padding: const material.EdgeInsets.all(40),
          child: const Center(child: AtoZLoader()),
        );
      } else {
        if (!value.isLoaded) {
          return Container();
        }
        return Container(
          padding: const material.EdgeInsets.all(20),
          child: Text(
            Errors.errorMessage == null ? '' : Errors.errorMessage!,
            textAlign: TextAlign.center,
            style: const material.TextStyle(
              color: material.Colors.red,
              fontSize: 16,
              fontWeight: material.FontWeight.w500,
            ),
          ),
        );
      }
    }
    return WDContactInfoCard(contactInfo: value.contactInfo!);
  }
}
