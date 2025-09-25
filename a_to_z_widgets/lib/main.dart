import 'package:a_to_z_dto/AddressDTO/adress_dto.dart';
import 'package:a_to_z_dto/RequestDTO/request_dto.dart';
import 'package:a_to_z_widgets/AddressWidgets/add_address_widget.dart';
import 'package:a_to_z_widgets/AddressWidgets/show_address_widget.dart';
import 'package:a_to_z_widgets/AddressWidgets/update_address_widget.dart';
import 'package:a_to_z_widgets/RequestWidgets/new_request.dart';
import 'package:a_to_z_widgets/RequestWidgets/new_request_widget.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Create a sample request with various scenarios
    final sampleRequest = ClsNewRequest(
      storeName: "متجر الألكترونيات الحديث",
      requestDate: DateTime.now(),
      requestStatus: EnRequestStatus.ePending,
      totalPrice: 250.0,
      discounts: 25.0,
      customerbalancedUsed: 50.0,
    );

    final sampleRequest2 = ClsNewRequest(
      storeName: "متجر الملابس الأنيقة",
      requestDate: DateTime.now().subtract(const Duration(days: 2)),
      requestStatus: EnRequestStatus.eCompleted,
      totalPrice: 120.0,
      discounts: 50,
      customerbalancedUsed: 0.0,
    );

    final sampleRequest3 = ClsNewRequest(
      storeName: "متجر الأجهزة المنزلية",
      requestDate: DateTime.now().subtract(const Duration(days: 5)),
      requestStatus: EnRequestStatus.eRejected,
      totalPrice: 300.0,
      discounts: 30.0,
      customerbalancedUsed: 0.0,
    );

    final sampleRequest4 = ClsNewRequest(
      storeName: "متجر الكتب والمعرفة",
      requestDate: DateTime.now().subtract(const Duration(days: 1)),
      requestStatus: EnRequestStatus.eCancled,
      totalPrice: 75.0,
      discounts: 0.0,
      customerbalancedUsed: 20.0,
    );

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            'طلب جديد - عرض تجريبي',
            style: TextStyle(fontFamily: 'Tajawal'),
          ),
          backgroundColor: Colors.blue,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Text(
                'عروض تجريبية لبطاقات الطلبات',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Tajawal',
                ),
              ),
              const SizedBox(height: 20),

              // Card with discount and balance used
              Container(
                constraints: const BoxConstraints(maxWidth: 350),
                child: WDNewRequestCard(
                  newRequest: sampleRequest,
                  onCardClicked: (request) {
                    print('تم النقر على: ${request?.storeName}');
                  },
                ),
              ),
              const SizedBox(height: 16),

              // Card without any discounts
              Container(
                constraints: const BoxConstraints(maxWidth: 400),
                child: WDNewRequestCard(
                  newRequest: sampleRequest2,
                  onCardClicked: (request) {
                    print('تم النقر على: ${request?.storeName}');
                  },
                ),
              ),
              const SizedBox(height: 16),

              // Card with discount only
              Container(
                constraints: const BoxConstraints(maxWidth: 400),
                child: WDNewRequestCard(
                  newRequest: sampleRequest3,
                  onCardClicked: (request) {
                    print('تم النقر على: ${request?.storeName}');
                  },
                ),
              ),
              const SizedBox(height: 16),

              // Card with balance used only
              Container(
                constraints: const BoxConstraints(maxWidth: 400),
                child: WDNewRequestCard(
                  newRequest: sampleRequest4,
                  onCardClicked: (request) {
                    print('تم النقر على: ${request?.storeName}');
                  },
                ),
              ),
              WDAddressCard(
                address: ClsAddressDTO(
                  addressID: 1,
                  areaName: 'zamalkha',
                  city: 'damascus',
                  streetNameOrNumber: '22',
                  importantNotes: 'hello',
                  buildingName: 'yabor',
                ),
              ),

              WDUpdateAddress(
                address: ClsAddressDTO(
                  addressID: 1,
                  areaName: 'zamalkha',
                  city: 'damascus',
                  streetNameOrNumber: '22',
                  importantNotes: 'hello',
                  buildingName: 'yabor',
                ),
                onUpdateAddress: (c) {},
              ),
              WDAddAddress(onAddAddress: (c) {}),
            ],
          ),
        ),
      ),
    );
  }
}
