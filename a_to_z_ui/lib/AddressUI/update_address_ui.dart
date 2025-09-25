import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:a_to_z_providers/Global/errors.dart';
import 'package:a_to_z_providers/AddressProviders/find_address_provider.dart';
import 'package:a_to_z_providers/AddressProviders/update_address_provider.dart';
import 'package:a_to_z_dto/AddressDTO/adress_dto.dart';
import 'package:a_to_z_widgets/AddressWidgets/update_address_widget.dart';

class UpdateAddressScreen extends StatefulWidget {
  final int addressID;

  const UpdateAddressScreen({super.key, required this.addressID});

  @override
  State<UpdateAddressScreen> createState() => _UpdateAddressScreenState();
}

class _UpdateAddressScreenState extends State<UpdateAddressScreen> {
  @override
  void initState() {
    super.initState();
    // Automatically load the address when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PVFindAddress>().findAddress(widget.addressID);
    });
  }

  void _onCancelPressed() {
    Navigator.of(context).pop();
  }

  void _onUpdateAddress(ClsAddressDTO updatedAddress) {
    // Call update provider
    context.read<PVUpdateAddress>().updateAddress(updatedAddress);
  }

  void _handleUpdateResult() {
    final updateProvider = context.read<PVUpdateAddress>();

    if (updateProvider.isUpdated) {
      // Show success message and pop
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('تم تحديث العنوان بنجاح'),
          backgroundColor: Colors.green[700],
          duration: const Duration(seconds: 2),
        ),
      );
      Navigator.of(context).pop();
    } else if (Errors.errorMessage != null) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('خطأ في التحديث: ${Errors.errorMessage}'),
          backgroundColor: Colors.red[700],
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تحديث العنوان'),
        centerTitle: true,
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _onCancelPressed,
        ),
      ),
      body: Consumer2<PVFindAddress, PVUpdateAddress>(
        builder: (context, findProvider, updateProvider, child) {
          // Handle update result
          if (updateProvider.isUpdated) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _handleUpdateResult();
            });
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Explanation Text
                Text(
                  'تحديث عنوان العميل. قم بتعديل المعلومات المطلوبة ثم انقر على تحديث.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[700],
                    height: 1.5,
                  ),
                  textAlign: TextAlign.right,
                ),

                const SizedBox(height: 32),

                // Loading or Update Form
                if (findProvider.isLoading)
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
                else if (findProvider.address != null)
                  Column(
                    children: [
                      // Update Address Form
                      WDUpdateAddress(
                        address: findProvider.address!,
                        onUpdateAddress: _onUpdateAddress,
                      ),

                      const SizedBox(height: 16),

                      // Update Button State
                      if (updateProvider.isLoading)
                        Center(
                          child: Column(
                            children: [
                              CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.green[700]!,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'جاري تحديث العنوان...',
                                style: TextStyle(
                                  color: Colors.green[700],
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        )
                      else if (Errors.errorMessage != null &&
                          updateProvider.isLoading == false)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.red[50],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.red[300]!),
                          ),
                          child: Text(
                            Errors.errorMessage!,
                            style: TextStyle(
                              color: Colors.red[700],
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                    ],
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
                      'العنوان غير موجود',
                      style: TextStyle(color: Colors.orange[700], fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// Usage function to show the update screen
Future<void> showUpdateAddressScreen({
  required BuildContext context,
  required int addressID,
}) {
  return Navigator.of(context).push(
    MaterialPageRoute(
      builder: (con) => UpdateAddressScreen(addressID: addressID),
      fullscreenDialog: true,
    ),
  );
}
