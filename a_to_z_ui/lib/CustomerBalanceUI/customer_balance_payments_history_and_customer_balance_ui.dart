import 'package:a_to_z_dto/FilterDTO/customer_balance_payments_history_filter_dto.dart';
import 'package:a_to_z_providers/BasesProviders/base_current_login_info_provider.dart';
import 'package:a_to_z_providers/CustomerBalanceProviders/customer_balance_payments_history_and_customer_balance_provider.dart';
import 'package:a_to_z_ui/TemplatesUI/cards_template.dart';
import 'package:a_to_z_widgets/CustomerBalanceWidgets/customer_balance_payment_history_widget.dart';
import 'package:a_to_z_widgets/CustomerBalanceWidgets/customer_balance_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomerBalanceScreen extends StatefulWidget {
  const CustomerBalanceScreen({super.key});

  @override
  State<CustomerBalanceScreen> createState() => _CustomerBalanceScreenState();
}

class _CustomerBalanceScreenState extends State<CustomerBalanceScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _scrollController.addListener(() async {
        if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent) {
          await _loadBalanceData();
        }
      });
      await _loadBalanceData();
    });
  }

  Future<void> _loadBalanceData() async {
    await context
        .read<PVCustomerBalancePaymentsHistoryAndCustomerBalance>()
        .getCustomerBalancePaymentsHistory(
          ClsCustomerBalancePaymentsHistoryFilterDTO(
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
        title: const Text(
          'رصيد العميل',
          style: TextStyle(fontFamily: 'Tajawal', fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Customer Balance Header with Top Up Widget
          Consumer<PVCustomerBalancePaymentsHistoryAndCustomerBalance>(
            builder: (context, provider, child) {
              return WDCustomerBalanceTopUp(
                customerBalance: provider.customerBalance,
                onTap: () {
                  // Navigate to top-up screen
                  // OpenScreens.onTopUpPressed(context, widget.customerID);
                },
              );
            },
          ),
          const SizedBox(height: 8),

          // Payment History List
          Expanded(
            child: Consumer<PVCustomerBalancePaymentsHistoryAndCustomerBalance>(
              builder: (context, provider, child) {
                return CardsTemplate(
                  scrollController: _scrollController,
                  isLoaded: provider.isLoaded,
                  isFinished: provider.isFinished,
                  values: provider.paymentHistory,
                  lineLength: 1, // Single column for payment history
                  widgetGetter: GetCustomerBalancePaymentHistoryWidget(),
                  onCardClick: (paymentHistory) {
                    // Handle payment history item click if needed
                    // OpenScreens.onPaymentHistoryDetailsPressed(context, history.requestID);
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
