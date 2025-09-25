import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:a_to_z_providers/Global/errors.dart';
import 'package:a_to_z_providers/AddressProviders/find_address_provider.dart';
import 'package:a_to_z_dto/AddressDTO/adress_dto.dart';
import 'package:flutter/services.dart';
import 'package:a_to_z_widgets/AddressWidgets/show_address_widget.dart';

class CustomerAddressScreen extends StatefulWidget {
  final int customerAddressID;
  final Function(ClsAddressDTO)? onAddressSelected;

  const CustomerAddressScreen({
    super.key,
    required this.customerAddressID,
    this.onAddressSelected,
  });

  @override
  State<CustomerAddressScreen> createState() => _CustomerAddressScreenState();
}

class _CustomerAddressScreenState extends State<CustomerAddressScreen> {
  @override
  void initState() {
    super.initState();
    // Automatically load the address when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PVFindAddress>().findAddress(widget.customerAddressID);
    });
  }

  void _onCancelPressed() {
    Navigator.of(context).pop();
  }

  void _onAddressSelected(ClsAddressDTO address) {
    widget.onAddressSelected?.call(address);
    Navigator.of(context).pop();
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('تم نسخ معلومات العنوان'),
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.green[700],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PVFindAddress>(
      builder: (context, provider, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('عنواني'),
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
                // Explanation Text
                Text(
                  'العنوان المسجل في حسابك. يمكنك نسخ معلومات العنوان أو تحديده للاستخدام.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[700],
                    height: 1.5,
                  ),
                  textAlign: TextAlign.right,
                ),

                const SizedBox(height: 32),

                // Loading or Address Card
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
                          'جاري تحميل العنوان...',
                          style: TextStyle(
                            color: Colors.blue[700],
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  )
                else if (provider.address != null)
                  GestureDetector(
                    onTap:
                        () => _copyToClipboard(
                          _formatAddressText(provider.address!),
                        ),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.green[50],
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.green[300]!),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'عنواني:',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green[800],
                                ),
                              ),
                              Icon(
                                Icons.content_copy,
                                color: Colors.green[600],
                                size: 20,
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          // Address Card
                          WDAddressCard(address: provider.address!),

                          const SizedBox(height: 12),
                          Text(
                            'انقر فوق البطاقة لتحديد العنوان أو انقر في أي مكان لنسخ المعلومات',
                            style: TextStyle(
                              fontSize: 12,
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
                    child: Column(
                      children: [
                        Text(
                          'خطأ في تحميل العنوان',
                          style: TextStyle(
                            color: Colors.red[800],
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          Errors.errorMessage!,
                          style: TextStyle(
                            color: Colors.red[700],
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  )
                else
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.orange[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.orange[300]!),
                    ),
                    child: Text(
                      'لا يوجد عنوان مسجل في حسابك',
                      style: TextStyle(color: Colors.orange[700], fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ),

                const SizedBox(height: 32),

                // Select Button (only visible when address is found)
                if (provider.address != null && !provider.isLoading)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => _onAddressSelected(provider.address!),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[700],
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        elevation: 2,
                      ),
                      child: const Text(
                        'تحديد هذا العنوان',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _formatAddressText(ClsAddressDTO address) {
    return 'العنوان #${address.addressID}\n'
        'المدينة: ${address.city ?? "غير محدد"}\n'
        'المنطقة: ${address.areaName ?? "غير محدد"}\n'
        'الشارع: ${address.streetNameOrNumber ?? "غير محدد"}\n'
        'المبنى: ${address.buildingName ?? "غير محدد"}\n'
        'ملاحظات: ${address.importantNotes ?? "لا توجد"}';
  }
}

// Usage function to show the screen
Future<void> showCustomerAddressScreen({
  required BuildContext context,
  required int customerAddressID,
  Function(ClsAddressDTO)? onAddressSelected,
}) {
  return Navigator.of(context).push(
    MaterialPageRoute(
      builder:
          (con) => ChangeNotifierProvider(
            create: (_) => PVFindAddress(),
            child: CustomerAddressScreen(
              customerAddressID: customerAddressID,
              onAddressSelected: onAddressSelected,
            ),
          ),
      fullscreenDialog: true,
    ),
  );
}
