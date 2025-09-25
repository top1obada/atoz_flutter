import 'package:a_to_z_dto/FilterDTO/customer_store_filter_dto.dart';
import 'package:a_to_z_dto/StoreDTO/customer_store_suggestion_dto.dart';
import 'package:a_to_z_providers/BasesProviders/base_current_login_info_provider.dart';
import 'package:a_to_z_widgets/StoreTypeWidgets/stores_types_line_with_colors.dart';
import 'package:a_to_z_providers/StoreProviders/customer_stores_suggestions_provider.dart';
import 'package:a_to_z_providers/StoreTypeProviders/stores_types_with_colors_provider.dart';
import 'package:a_to_z_ui/Libraries/open_screens.dart';
import 'package:a_to_z_ui/TemplatesUI/cards_template.dart';
import 'package:a_to_z_widgets/StoreWidgets/customer_store_suggestion_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PVKm extends ChangeNotifier {
  int _distanceInKm = 5;

  int get distanceInKm {
    return _distanceInKm;
  }

  set distanceInKm(int value) {
    _distanceInKm = value;
    notifyListeners();
  }
}

class CustomerStoresSuggestionsUi extends StatefulWidget {
  const CustomerStoresSuggestionsUi({super.key});

  @override
  State<CustomerStoresSuggestionsUi> createState() {
    return _CustomerStoresSuggestionsUi();
  }
}

class _CustomerStoresSuggestionsUi extends State<CustomerStoresSuggestionsUi> {
  final ScrollController _scrollController = ScrollController();
  final List<int> _distanceOptions = [5, 10, 15, 20, 25, 30, 35, 40, 45, 50];

  String? _selectedStoreType;

  PVKm? kmProvider;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // Load store types with colors
      await context.read<PVStoreTypesWithColors>().getStoreTypesWithColors();

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
    await context
        .read<PVCustomerStoresSuggestions>()
        .getCustomerStoreSuggestion(
          ClsCustomerStoresFilterDTO(
            customerID:
                context
                    .read<PVBaseCurrentLoginInfo>()
                    .retrivingLoggedInDTO!
                    .branchID,
            pageSize: 6,
            distanceInMeters: kmProvider!.distanceInKm * 1000,
            storeTypeName: _selectedStoreType,
          ),
        );
  }

  Future<void> _onDistanceChanged(int? number) async {
    if (number == null) return;

    kmProvider!.distanceInKm = number;
    // مسح المتاجر الحالية وإعادة التحميل بالمسافة الجديدة
    context.read<PVCustomerStoresSuggestions>().clearStores();
    await _loadStores();
  }

  Future<void> _onStoreTypeSelected(String storeType) async {
    _selectedStoreType = storeType == 'الكل' ? null : storeType;

    // مسح المتاجر الحالية وإعادة التحميل بنوع المتجر المحدد
    context.read<PVCustomerStoresSuggestions>().clearStores();
    await _loadStores();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Header with distance selector and store types in one container
        Container(
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: const Color.fromRGBO(158, 158, 158, 0.3),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(16),
              bottomRight: Radius.circular(16),
            ),
          ),
          child: Column(
            children: [
              // Single row with both distance filter and store types
              Consumer<PVStoreTypesWithColors>(
                builder: (context, storeTypesProvider, child) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Store types line - takes most of the space
                      Expanded(
                        child:
                            storeTypesProvider.isLoading
                                ? const Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.blue,
                                    strokeWidth: 2,
                                  ),
                                )
                                : storeTypesProvider.storeTypesWithColors ==
                                    null
                                ? const Text(
                                  'حدث خطأ في تحميل أنواع المتاجر',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.red,
                                    fontFamily: 'Tajawal',
                                  ),
                                  textAlign: TextAlign.center,
                                )
                                : storeTypesProvider
                                    .storeTypesWithColors!
                                    .isEmpty
                                ? const Text(
                                  'لا توجد أنواع متاجر متاحة',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                    fontFamily: 'Tajawal',
                                  ),
                                  textAlign: TextAlign.center,
                                )
                                : StoresTypesLineWithColors(
                                  storesTypesWithColors:
                                      storeTypesProvider.storeTypesWithColors,
                                  onItemClick: _onStoreTypeSelected,
                                ),
                      ),

                      const SizedBox(width: 12),

                      // Distance selector on the right side
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
                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    'نطاق البحث',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Tajawal',
                                      color: Colors.blue.shade800,
                                    ),
                                    textDirection: TextDirection.rtl,
                                  ),
                                  DropdownButton<int>(
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
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),

        // قائمة المتاجر
        Expanded(
          child: Consumer<PVCustomerStoresSuggestions>(
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
