import 'package:a_to_z_dto/LocationDTO/user_point_dto.dart';
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
    final screenWidth = mediaQuery.size.width;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'موقع العميل',
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

            return LayoutBuilder(
              builder: (context, constraints) {
                // حساب الارتفاع المناسب للخريطة بناءً على حجم الشاشة
                final mapHeight =
                    constraints.maxHeight * 0.4; // 40% من الارتفاع المتاح

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      // الخريطة
                      Container(
                        height: mapHeight.clamp(
                          200,
                          400,
                        ), // حد أدنى وأقصى للارتفاع
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: LocationShow(
                            initialLatitude: value.customerLocation!.latitude!,
                            initialLongitude:
                                value.customerLocation!.longitude!,
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

                      // معلومات الإحداثيات
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.blue),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.location_pin,
                              color: Colors.blue,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'الإحداثيات الحالية:',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue,
                                      fontSize: 12,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '${value.customerLocation!.latitude?.toStringAsFixed(6) ?? '--'}, ${value.customerLocation!.longitude?.toStringAsFixed(6) ?? '--'}',
                                    style: const TextStyle(fontSize: 10),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 12),

                      // حقل العنوان
                      Card(
                        elevation: 1,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Row(
                                children: [
                                  Icon(
                                    Icons.home,
                                    size: 18,
                                    color: Colors.orange,
                                  ),
                                  SizedBox(width: 6),
                                  Text(
                                    'العنوان التفصيلي',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.orange,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              TextField(
                                controller: _addressController,
                                maxLines: 2,
                                decoration: InputDecoration(
                                  hintText: 'أدخل العنوان التفصيلي هنا...',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(6),
                                    borderSide: const BorderSide(
                                      color: Colors.grey,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(6),
                                    borderSide: const BorderSide(
                                      color: Colors.blue,
                                    ),
                                  ),
                                  contentPadding: const EdgeInsets.all(10),
                                  isDense: true,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      // آخر تحديث
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.update,
                              size: 14,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 6),
                            const Text(
                              'آخر تحديث:',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 11,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              _formatDate(value.customerLocation!.updatedDate),
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // مساحة إضافية في الأسفل لتجنب التداخل مع الزر
                      SizedBox(height: mediaQuery.viewPadding.bottom + 80),
                    ],
                  ),
                );
              },
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
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: SizedBox(
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: updateProvider.isLoading ? null : _updateLocation,
                  icon:
                      updateProvider.isLoading
                          ? SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation(Colors.white),
                            ),
                          )
                          : const Icon(Icons.save, size: 18),
                  label:
                      updateProvider.isLoading
                          ? const Text(
                            'جاري الحفظ...',
                            style: TextStyle(fontSize: 14),
                          )
                          : const Text(
                            'حفظ التغييرات',
                            style: TextStyle(fontSize: 14),
                          ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
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
