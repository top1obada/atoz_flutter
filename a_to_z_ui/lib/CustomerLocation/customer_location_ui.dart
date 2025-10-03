import 'package:a_to_z_providers/BasesProviders/base_current_login_info_provider.dart';
import 'package:a_to_z_providers/CustomerLocation/get_customer_location_provider.dart';
import 'package:a_to_z_widgets/ATOZAnimations/a_to_z_animation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_widgets/LocationWidgets/location_show_widget.dart';
import 'package:a_to_z_providers/CustomerLocation/update_customer_location_provider.dart';

class CustomerLocationUi extends StatefulWidget {
  const CustomerLocationUi({super.key});

  @override
  State<CustomerLocationUi> createState() {
    return _CustomerLocationUi();
  }
}

class _CustomerLocationUi extends State<CustomerLocationUi> {
  final TextEditingController _addressController = TextEditingController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final locationProvider = context.read<PvGetCustomerLocation>();

      await locationProvider.getCustomerLocation(
        context.read<PVBaseCurrentLoginInfo>().retrivingLoggedInDTO!.branchID!,
      );

      if (locationProvider.customerLocation != null) {
        _addressController.text =
            locationProvider.customerLocation!.address ?? '';
      }
    });
  }

  Future<void> _updateLocation() async {
    final locationProvider = context.read<PvGetCustomerLocation>();
    final updateProvider = context.read<PvUpdateCustomerLocation>();

    // تحديث البيانات المحلية قبل الإرسال
    locationProvider.customerLocation!.updatedDate = DateTime.now();
    locationProvider.customerLocation!.address = _addressController.text.trim();

    // استخدام الـ update provider للتحديث
    await updateProvider.updateCustomerLocation(
      locationProvider.customerLocation!,
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'غير محدد';
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'الموقع',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          backgroundColor: Colors.blue,
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: Consumer<PvGetCustomerLocation>(
          builder: (context, value, child) {
            if (value.isLoading) {
              return const Center(child: AtoZLoader());
            }

            if (value.customerLocation == null) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.location_off,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        "الخريطة غير موجودة",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // الخريطة - أكبر حجماً
                  Container(
                    height: screenHeight * 0.6, // 60% من ارتفاع الشاشة
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.15),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: LocationShow(
                        initialLatitude: value.customerLocation!.latitude!,
                        initialLongitude: value.customerLocation!.longitude!,
                        allowUpdate: true,
                        markerTitle: 'الموقع',
                        onLocationChanged: (L) {
                          value.customerLocation!.latitude = L.latitude;
                          value.customerLocation!.longitude = L.longitude;
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // حقل العنوان
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.home, size: 20, color: Colors.orange),
                              SizedBox(width: 8),
                              Text(
                                'العنوان التفصيلي',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          TextField(
                            controller: _addressController,
                            maxLines: 2,
                            decoration: InputDecoration(
                              hintText: 'أدخل العنوان التفصيلي هنا...',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  color: Colors.grey,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  color: Colors.blue,
                                ),
                              ),
                              contentPadding: const EdgeInsets.all(12),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // آخر تحديث
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.update, size: 16, color: Colors.grey),
                        const SizedBox(width: 8),
                        const Text(
                          'آخر تحديث:',
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          _formatDate(value.customerLocation!.updatedDate),
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // مساحة إضافية في الأسفل لتجنب التداخل مع الزر
                  SizedBox(height: mediaQuery.viewPadding.bottom + 20),
                ],
              ),
            );
          },
        ),
        bottomNavigationBar: Consumer<PvUpdateCustomerLocation>(
          builder: (context, updateProvider, child) {
            return Container(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 12,
                bottom: 12 + mediaQuery.viewPadding.bottom,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: SizedBox(
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: updateProvider.isLoading ? null : _updateLocation,
                  icon:
                      updateProvider.isLoading
                          ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation(Colors.white),
                            ),
                          )
                          : const Icon(Icons.save, size: 20),
                  label:
                      updateProvider.isLoading
                          ? const Text(
                            'جاري الحفظ...',
                            style: TextStyle(fontSize: 16),
                          )
                          : const Text(
                            'حفظ التغييرات',
                            style: TextStyle(fontSize: 16),
                          ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }
}
