import 'package:a_to_z_dto/ItemDTO/store_sub_category_item_item_dto.dart';
import 'package:a_to_z_dto/RequestDTO/request_dto.dart';
import 'package:a_to_z_providers/BasesProviders/base_current_login_info_provider.dart';
import 'package:a_to_z_providers/Global/errors.dart';
import 'package:a_to_z_providers/ItemProviders/store_sub_category_item_items_provider.dart';
import 'package:a_to_z_providers/RequestProviders/request_provider.dart';
import 'package:a_to_z_ui/CustomerBalanceUI/CustomerBalanceDialogs/customer_balance_dialog.dart';
import 'package:a_to_z_ui/TemplatesUI/cards_template.dart';
import 'package:flutter/material.dart';
import 'package:a_to_z_widgets/ItemWidgets/store_sub_category_item_item_show_widget.dart';
import 'package:a_to_z_widgets/RequestWidgets/new_request_widget.dart';
import 'package:a_to_z_widgets/RequestWidgets/new_request.dart';
import 'package:provider/provider.dart';
import 'package:a_to_z_providers/RequestProviders/show_request_provider.dart';

class RequestContentUi extends StatefulWidget {
  const RequestContentUi({super.key});
  @override
  State<RequestContentUi> createState() {
    return _RequestContentUi();
  }
}

class _RequestContentUi extends State<RequestContentUi> {
  final ScrollController _scrollController = ScrollController();

  void _onRemoveItem(Object? item) {
    if (item == null) return;

    ClsStoreSubCategoryItemItemDTO storeSubCategoryItemItemDTO =
        item as ClsStoreSubCategoryItemItemDTO;

    final pv = context.read<PVShowRequest>();
    pv.removeItem(storeSubCategoryItemItemDTO);

    context.read<PVStoreSubCategoryItemItems>().increaseCountOneItem(
      storeSubCategoryItemItemDTO,
    );

    if (pv.itemsCount == 0) {
      pv.clearRequest();
    }
  }

  // Function to show customer balance dialog
  Future<void> _showCustomerBalanceDialog() async {
    await showCustomerBalanceDialog(
      context: context,
      onBalanceSelected: (selectedBalance) {
        if (selectedBalance >
            (context.read<PVShowRequest>().totalDue -
                context.read<PVShowRequest>().discount)) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'المبلغ المحدد يتجاوز المبلغ المستحق. يرجى اختيار مبلغ أقل',
                textAlign: TextAlign.right,
                style: const TextStyle(fontFamily: 'Tajawal'),
              ),
              backgroundColor: Colors.red[700],
            ),
          );
          return;
        }

        context
            .read<PVRequest>()
            .completedRequestDto!
            .requestTotalPaymentDTO!
            .balanceValueUsed = selectedBalance;

        if (selectedBalance > 0) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'تم استخدام $selectedBalance من رصيد العميل',
                textAlign: TextAlign.right,
                style: const TextStyle(fontFamily: 'Tajawal'),
              ),
              backgroundColor: Colors.green[700],
            ),
          );
        }

        if (selectedBalance == 0) {
          if (context.read<PVShowRequest>().requestShow!.balanceUsedVaue !=
                  null &&
              context.read<PVShowRequest>().requestShow!.balanceUsedVaue! > 0) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text(
                  'تم إلغاء استخدام الرصيد',
                  textAlign: TextAlign.right,
                  style: TextStyle(fontFamily: 'Tajawal'),
                ),
                backgroundColor: Colors.brown,
              ),
            );
          }
        }
      },
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final provider = context.read<PVRequest>();

      final showRequestProvider = context.read<PVShowRequest>();

      provider.completedRequestDto!.requestDTO!.storeID =
          showRequestProvider.requestShow!.storeID;

      provider.completedRequestDto!.requestDTO!.requestCustomerID =
          context.read<PVBaseCurrentLoginInfo>().retrivingLoggedInDTO!.branchID;

      provider.completedRequestDto!.requestTotalPaymentDTO!.discount =
          showRequestProvider.discount;
      provider.completedRequestDto!.requestTotalPaymentDTO!.totalDue =
          showRequestProvider.totalDue;
    });
  }

  @override
  Widget build(BuildContext context) {
    PVShowRequest showRequest = context.read<PVShowRequest>();

    return SafeArea(
      // ← ADD THIS
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'تفاصيل الطلب',
            style: TextStyle(
              fontFamily: 'Tajawal',
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.blue[700],
          foregroundColor: Colors.white,
          elevation: 4,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
          ),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.account_balance_wallet,
                color: Colors.white,
              ),
              onPressed: _showCustomerBalanceDialog,
              tooltip: 'استخدام رصيد العميل',
            ),
          ],
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.blue[50]!, Colors.grey[100]!],
            ),
          ),
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Selector<PVRequest, int?>(
                    selector: (con, provider) => provider.requestID,
                    builder:
                        (context, value, child) => Consumer<PVShowRequest>(
                          builder:
                              (context, showpv, child) => WDNewRequestCard(
                                newRequest: ClsNewRequest(
                                  storeName: showpv.requestShow!.storeName,
                                  requestDate: DateTime.now(),
                                  requestStatus: EnRequestStatus.ePending,
                                  totalPrice: showpv.totalDue,
                                  discounts: showpv.discount,
                                  customerbalancedUsed:
                                      showpv.requestShow!.balanceUsedVaue,
                                  requestID: value,
                                ),
                                onCardClicked: null,
                              ),
                        ),
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),
                  child: ElevatedButton.icon(
                    onPressed: _showCustomerBalanceDialog,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[50],
                      foregroundColor: Colors.blue[800],
                      padding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 20,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(color: Colors.blue[300]!, width: 1),
                      ),
                      elevation: 2,
                    ),
                    icon: const Icon(Icons.account_balance_wallet, size: 24),
                    label: const Text(
                      'استخدام رصيد العميل',
                      style: TextStyle(
                        fontFamily: 'Tajawal',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withValues(alpha: 0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                    border: Border.all(color: Colors.blue[100]!, width: 1),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'المنتجات (${showRequest.itemsCount})',
                        style: const TextStyle(
                          fontFamily: 'Tajawal',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      Consumer<PVShowRequest>(
                        builder:
                            (context, value, child) => Text(
                              '${(showRequest.totalDue - showRequest.discount - showRequest.requestShow!.balanceUsedVaue!).toStringAsFixed(2)} ليرة سورية',
                              style: TextStyle(
                                fontFamily: 'Tajawal',
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.green[700],
                              ),
                            ),
                      ),
                    ],
                  ),
                ),
              ),

              // FIXED HEIGHT CALCULATION
              SliverToBoxAdapter(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: 200,
                    maxHeight: MediaQuery.of(context).size.height * 0.6,
                  ),
                  child: Consumer<PVRequest>(
                    builder:
                        (con, pvrequest, child) => CardsTemplate(
                          scrollController: ScrollController(),
                          isLoaded: true,
                          isFinished: true,
                          values:
                              showRequest
                                  .requestShow!
                                  .storeSubCategoryItemItems,
                          lineLength: 2,
                          widgetGetter: GetStoreSubCategoryItemItemShowWidget(),
                          onCardClick:
                              (pvrequest.isLoading ||
                                      pvrequest.requestID != null)
                                  ? null
                                  : _onRemoveItem,
                          showEndSection: false,
                        ),
                  ),
                ),
              ),

              const SliverToBoxAdapter(
                child: SizedBox(height: 20), // Reduced padding
              ),
            ],
          ),
        ),
        bottomNavigationBar: Container(
          height: 70, // Reduced height
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ), // Reduced padding
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Selector<PVRequest, bool>(
            selector: (context, provider) => provider.isLoading,
            builder: (context, isLoading, child) {
              final currentProvider = context.read<PVRequest>();

              if (isLoading) {
                return const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                      ),
                    ),
                    SizedBox(width: 12),
                    Text(
                      'جاري تأكيد الطلب...',
                      style: TextStyle(
                        fontFamily: 'Tajawal',
                        fontSize: 14, // Reduced font size
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                );
              }

              if (currentProvider.requestID != null) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: Colors.green[700],
                      size: 20, // Reduced icon size
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'تم تأكيد الطلب بنجاح',
                      style: TextStyle(
                        fontFamily: 'Tajawal',
                        fontSize: 14, // Reduced font size
                        fontWeight: FontWeight.bold,
                        color: Colors.green[700],
                      ),
                    ),
                  ],
                );
              }

              if (currentProvider.isLoaded &&
                  currentProvider.requestID == null) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error, color: Colors.red[700], size: 20),
                    const SizedBox(width: 8),
                    Text(
                      Errors.errorMessage!,
                      style: TextStyle(
                        fontFamily: 'Tajawal',
                        fontSize: 14, // Reduced font size
                        fontWeight: FontWeight.bold,
                        color: Colors.red[700],
                      ),
                    ),
                  ],
                );
              }

              return ElevatedButton(
                onPressed: () async {
                  currentProvider.putItems(
                    showRequest.requestShow!.storeSubCategoryItemItems!,
                  );
                  await currentProvider.request();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[700],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 24,
                  ), // Reduced padding
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.send, size: 18, color: Colors.white),
                    SizedBox(width: 6),
                    Text(
                      'تأكيد الطلب',
                      style: TextStyle(
                        fontFamily: 'Tajawal',
                        fontSize: 16, // Reduced font size
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
