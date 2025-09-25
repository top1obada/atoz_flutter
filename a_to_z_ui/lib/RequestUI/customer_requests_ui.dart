import 'package:a_to_z_dto/RequestDTO/customer_request_dto.dart';
import 'package:a_to_z_providers/BasesProviders/base_current_login_info_provider.dart';
import 'package:a_to_z_providers/RequestProviders/customer_requests_provider.dart';
import 'package:a_to_z_ui/TemplatesUI/cards_template.dart';
import 'package:a_to_z_widgets/RequestWidgets/customer_request_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:a_to_z_dto/FilterDTO/customer_requests_filter_dto.dart';

class CustomerRequestsScreen extends StatefulWidget {
  const CustomerRequestsScreen({super.key});

  @override
  State<CustomerRequestsScreen> createState() => _CustomerRequestsScreenState();
}

class _CustomerRequestsScreenState extends State<CustomerRequestsScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _scrollController.addListener(() async {
        if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent) {
          await _loadRequests();
        }
      });

      await _loadRequests();
    });
  }

  Future<void> _loadRequests() async {
    await context.read<PVCustomerRequests>().getCustomerRequests(
      ClsCustomerRequestsFilterDTO(
        customerID:
            context
                .read<PVBaseCurrentLoginInfo>()
                .retrivingLoggedInDTO!
                .branchID,
        pageSize: 10,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true, // This adds the back button
        title: Align(
          alignment: Alignment.centerRight,
          child: Text(
            'طلبات',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              fontFamily: 'Tajawal',
            ),
          ),
        ),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 8),
          Expanded(
            child: Consumer<PVCustomerRequests>(
              builder: (con, provider, child) {
                return CardsTemplate(
                  scrollController: _scrollController,
                  isLoaded: provider.isLoaded,
                  isFinished: provider.isFinished,
                  values: provider.customerRequests,
                  lineLength: 1, // Single column layout
                  widgetGetter: GetCustomerRequestWidget(),
                  onCardClick: (request) {
                    ClsCustomerRequestDto customerRequest =
                        request as ClsCustomerRequestDto;

                    // Handle request card click
                    if (customerRequest.requestID != null) {
                      // Navigate to request details screen if needed
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
