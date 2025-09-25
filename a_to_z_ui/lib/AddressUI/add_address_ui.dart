import 'package:a_to_z_providers/AddressProviders/add_address_provider.dart';
import 'package:a_to_z_providers/BasesProviders/base_current_login_info_provider.dart';
import 'package:flutter/material.dart';
import 'package:a_to_z_dto/AddressDTO/adress_dto.dart';
import 'package:a_to_z_providers/Global/errors.dart';
import 'package:a_to_z_widgets/AddressWidgets/add_address_widget.dart';
import 'package:provider/provider.dart';

class AddAddressUi extends StatefulWidget {
  const AddAddressUi({super.key});

  @override
  State<AddAddressUi> createState() {
    return _AddAddressUI();
  }
}

class _AddAddressUI extends State<AddAddressUi> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _handleAddAddress(ClsAddressDTO addressDTO) async {
    addressDTO.personID =
        context.read<PVBaseCurrentLoginInfo>().retrivingLoggedInDTO!.personID;
    var _addressProvider = context.read<PVAddAddress>();
    _addressProvider.addAddress(addressDTO).then((_) {
      if (_addressProvider.addressID != null) {
        // Success - show success message and optionally navigate back
        _showSuccessMessage();
      } else if (Errors.errorMessage != null) {
        // Error - show error message
        _showErrorMessage(Errors.errorMessage!);
      }
    });

    await Future.delayed(Duration(seconds: 3));

    Navigator.pop(context);
  }

  void _showSuccessMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'تم إضافة العنوان بنجاح (ID: ${context.read<PVAddAddress>().addressID})',
          textAlign: TextAlign.right,
          style: const TextStyle(fontFamily: 'Tajawal'),
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );

    context
        .read<PVBaseCurrentLoginInfo>()
        .retrivingLoggedInDTO!
        .isAddressInfoConifrmed = true;

    context.read<PVAddAddress>().notify();

    // Optional: Clear the form or navigate back after success
    // You might want to pass a callback to reset the form
  }

  void _showErrorMessage(String error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'خطأ: $error',
          textAlign: TextAlign.right,
          style: const TextStyle(fontFamily: 'Tajawal'),
        ),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 4),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'إضافة عنوان جديد',
          style: TextStyle(fontFamily: 'Tajawal', fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          // Add Address Form
          SingleChildScrollView(
            child: WDAddAddress(onAddAddress: _handleAddAddress),
          ),

          // Loading Overlay
          if (context.read<PVAddAddress>().isLoading)
            Container(
              color: Colors.black54,
              child: const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
