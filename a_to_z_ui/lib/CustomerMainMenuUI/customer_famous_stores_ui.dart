import 'package:a_to_z_dto/FilterDTO/customer_store_filter_dto.dart';
import 'package:a_to_z_dto/StoreDTO/customer_store_suggestion_dto.dart';
import 'package:a_to_z_providers/BasesProviders/base_current_login_info_provider.dart';

import 'package:a_to_z_providers/StoreProviders/customer_famous_stores_provider.dart';

import 'package:a_to_z_ui/CustomerMainMenuUI/customer_stores_suggestions_ui.dart';
import 'package:a_to_z_ui/Libraries/open_screens.dart';
import 'package:a_to_z_ui/TemplatesUI/cards_template.dart';
import 'package:a_to_z_widgets/StoreWidgets/customer_store_suggestion_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomerFamousStoresUi extends StatefulWidget {
  const CustomerFamousStoresUi({super.key});

  @override
  State<CustomerFamousStoresUi> createState() {
    return _CustomerFamousStoresUi();
  }
}

class _CustomerFamousStoresUi extends State<CustomerFamousStoresUi> {
  final ScrollController _scrollController = ScrollController();
  final List<int> _distanceOptions = [5, 10, 15, 20, 25, 30, 35, 40, 45, 50];

  PVKm? kmProvider;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _scrollController.addListener(() async {
        if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent) {
          await _loadStores();
        }
      });

      await _loadStores();
    });
  }

  Future<void> _loadStores() async {
    await context.read<PVCustomerFamousStores>().getCustomerFamousStores(
      ClsCustomerStoresFilterDTO(
        customerID:
            context
                .read<PVBaseCurrentLoginInfo>()
                .retrivingLoggedInDTO!
                .branchID,
        pageSize: 6,
        distanceInMeters:
            kmProvider!.distanceInKm * 1000, // تحويل الكيلومتر إلى متر
      ),
    );
  }

  Future<void> _onDistanceChanged(int? number) async {
    if (number == null) return;

    kmProvider!.distanceInKm = number;
    // مسح المتاجر الحالية وإعادة التحميل بالمسافة الجديدة
    context.read<PVCustomerFamousStores>().clearStores();
    await _loadStores();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Color.fromRGBO(
                  158,
                  158,
                  158,
                  0.3,
                ), // Colors.grey with 0.3 opacity
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(16),
              bottomRight: Radius.circular(16),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.blue.shade100,
                        width: 1.5,
                      ),
                    ),
                    child: ChangeNotifierProvider(
                      create: (con) {
                        PVKm km = PVKm();
                        kmProvider = km;
                        return km;
                      },
                      child: Consumer<PVKm>(
                        builder: (context, value, child) {
                          return DropdownButton<int>(
                            value: value.distanceInKm,
                            onChanged: _onDistanceChanged,
                            items:
                                _distanceOptions.map((int distance) {
                                  return DropdownMenuItem<int>(
                                    value: distance,
                                    child: Text(
                                      '$distance كم',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontFamily: 'Tajawal',
                                        fontWeight: FontWeight.w600,
                                        color: Colors.blueGrey,
                                      ),
                                      textDirection: TextDirection.rtl,
                                    ),
                                  );
                                }).toList(),
                            underline: const SizedBox(),
                            icon: const Icon(
                              Icons.arrow_drop_down,
                              color: Colors.blue,
                              size: 24,
                            ),
                            borderRadius: BorderRadius.circular(12),
                            isExpanded: false,
                            alignment: Alignment.centerRight,
                            dropdownColor: Colors.grey[50],
                            elevation: 2,
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'نطاق البحث:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Tajawal',
                      color: Colors.blue.shade800,
                    ),
                    textDirection: TextDirection.rtl,
                  ),
                ],
              ),

              Text(
                'A TO Z',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Tajawal',
                  color: Colors.blue.shade700,
                  shadows: [
                    Shadow(
                      blurRadius: 2.0,
                      color: Colors.blue.shade100,
                      offset: const Offset(1, 1),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // وصف التطبيق
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          color: Colors.blue.shade50,
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.info_outline, size: 16, color: Colors.blue),
              SizedBox(width: 8),
              Text(
                'اكتشف أفضل المتاجر القريبة منك في نطاق المسافة المحددة',
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'Tajawal',
                  color: Colors.blueGrey,
                  fontWeight: FontWeight.w500,
                ),
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),

        // قائمة المتاجر
        Expanded(
          child: Consumer<PVCustomerFamousStores>(
            builder: (con, value, child) {
              return CardsTemplate(
                scrollController: _scrollController,
                isLoaded: value.isLoaded,
                isFinished: value.isFinished,
                values: value.customerStoresSuggestions,
                lineLength: 2,
                widgetGetter: GetCustomerStoreSuggestionWidget(),
                onCardClick: (c) {
                  ClsCustomerStoreSuggestionDTO customerStoreSuggestionDTO =
                      c as ClsCustomerStoreSuggestionDTO;

                  if (customerStoreSuggestionDTO.storeID == null) {
                    return;
                  }

                  OpenScreens.openStoreCategoriesScreen(
                    context,
                    customerStoreSuggestionDTO,
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
