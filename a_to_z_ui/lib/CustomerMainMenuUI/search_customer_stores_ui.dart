import 'package:a_to_z_dto/FilterDTO/customer_favorite_store_filter_dto.dart';
import 'package:a_to_z_dto/FilterDTO/customer_searching_store_filter_dto.dart';
import 'package:a_to_z_dto/StoreDTO/customer_store_suggestion_dto.dart';
import 'package:a_to_z_providers/BasesProviders/base_current_login_info_provider.dart';

import 'package:a_to_z_providers/StoreProviders/customer_privious_requests_stores_provider.dart';
import 'package:a_to_z_providers/StoreProviders/customer_searching_stores_provider.dart';

import 'package:a_to_z_ui/Libraries/open_screens.dart';
import 'package:a_to_z_ui/TemplatesUI/cards_template.dart';
import 'package:a_to_z_widgets/StoreWidgets/customer_store_suggestion_widget.dart';
import 'package:flutter/material.dart';

import 'package:my_widgets/SearchWidgets/search_widget.dart';
import 'package:provider/provider.dart';

class PVSearch extends ChangeNotifier {
  String? _searchingText;

  String? get searchingText {
    return _searchingText;
  }

  set searchingText(String? value) {
    _searchingText = value;
    notifyListeners();
  }
}

class SearchCustomerStoresUi extends StatefulWidget {
  const SearchCustomerStoresUi({super.key});

  @override
  State<SearchCustomerStoresUi> createState() {
    return _SearchCustomerStoresUi();
  }
}

class _SearchCustomerStoresUi extends State<SearchCustomerStoresUi> {
  final ScrollController _priviousRequestsScrollController = ScrollController();
  final ScrollController _searchingScrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _priviousRequestsScrollController.addListener(() async {
        if (_priviousRequestsScrollController.position.pixels ==
            _priviousRequestsScrollController.position.maxScrollExtent) {
          await _loadStoresPriviousRequests();
        }
      });

      _searchingScrollController.addListener(() async {
        if (_searchingScrollController.position.pixels ==
            _searchingScrollController.position.maxScrollExtent) {
          await _loadStoresSearching();
        }
      });

      await _loadStoresPriviousRequests();
    });
  }

  Future<void> _loadStoresSearching() async {
    await context.read<PVCustomerSearchStores>().getCustomersSearchStores(
      ClsCustomerSearchingStoresFilterDTO(
        customerID:
            context
                .read<PVBaseCurrentLoginInfo>()
                .retrivingLoggedInDTO!
                .branchID,
        pageSize: 10,
        searchingText: context.read<PVSearch>().searchingText,
      ),
    );
  }

  Future<void> _loadStoresPriviousRequests() async {
    await context
        .read<PVCustomerPreviousRequestsStores>()
        .getCustomerPreviousRequestsStores(
          ClsCustomerFavoriteStoreFilterDTO(
            customerID:
                context
                    .read<PVBaseCurrentLoginInfo>()
                    .retrivingLoggedInDTO!
                    .branchID,
            pageSize: 6,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SearchHeader(
          onSearch: (text) async {
            PVSearch pvSearch = context.read<PVSearch>();
            context.read<PVCustomerSearchStores>().clearStores();
            if (text.isEmpty) {
              pvSearch.searchingText = null;
            } else {
              pvSearch.searchingText = text;
              await _loadStoresSearching();
            }
          },
        ),
        Expanded(
          child: Consumer<PVSearch>(
            builder: (cont, value, child) {
              if (value.searchingText == null) {
                return Consumer<PVCustomerPreviousRequestsStores>(
                  builder: (con, value, child) {
                    return CardsTemplate(
                      scrollController: _priviousRequestsScrollController,
                      isLoaded: value.isLoaded,
                      isFinished: value.isFinished,
                      values: value.customerStoresSuggestions,
                      lineLength: 2,
                      widgetGetter: GetCustomerStoreSuggestionWidget(),
                      onCardClick: (c) {
                        ClsCustomerStoreSuggestionDTO
                        customerStoreSuggestionDTO =
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
                );
              } else {
                return Consumer<PVCustomerSearchStores>(
                  builder: (con, value, child) {
                    return CardsTemplate(
                      scrollController: _searchingScrollController,
                      isLoaded: value.isLoaded,
                      isFinished: value.isFinished,
                      values: value.customerStoresSuggestions,
                      lineLength: 2,
                      widgetGetter: GetCustomerStoreSuggestionWidget(),
                      onCardClick: (c) {
                        ClsCustomerStoreSuggestionDTO
                        customerStoreSuggestionDTO =
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
                );
              }
            },
          ),
        ),
      ],
    );
  }
}
