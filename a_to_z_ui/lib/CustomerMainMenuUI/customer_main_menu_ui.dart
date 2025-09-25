import 'package:a_to_z_providers/BasesProviders/base_current_login_info_provider.dart';
import 'package:a_to_z_providers/StoreProviders/customer_famous_stores_provider.dart';
import 'package:a_to_z_providers/StoreProviders/customer_favorite_stores_provider.dart';
import 'package:a_to_z_providers/StoreProviders/customer_privious_requests_stores_provider.dart';
import 'package:a_to_z_providers/StoreProviders/customer_stores_suggestions_provider.dart';
import 'package:a_to_z_providers/StoreTypeProviders/stores_types_with_colors_provider.dart';
import 'package:a_to_z_ui/CustomerMainMenuUI/bottom_line_main_menu.dart';
import 'package:a_to_z_ui/CustomerMainMenuUI/customer_favorite_stores_ui.dart';
import 'package:a_to_z_ui/CustomerMainMenuUI/search_customer_stores_ui.dart';
import 'package:flutter/material.dart';

import 'package:a_to_z_ui/WidgetsUI/base_Scaffold.dart';

import 'package:a_to_z_ui/CustomerMainMenuUI/customer_stores_suggestions_ui.dart';
import 'package:provider/provider.dart';
import 'package:a_to_z_ui/CustomerMainMenuUI/customer_famous_stores_ui.dart';
import 'package:a_to_z_providers/StoreProviders/customer_searching_stores_provider.dart';

enum EnMainMenuPages {
  eCustomerStoresSuggestions(1),
  eSearchCustomerStores(2),
  eCustomerFavoriteStores(3),
  eCustomerFamousStores(4);

  final int value;

  const EnMainMenuPages(this.value);

  @override
  String toString() {
    return name.substring(1, name.length);
  }

  static EnMainMenuPages? fromValue(int? value) {
    if (value == null) return null;
    return EnMainMenuPages.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw Exception('Unknown EnMainMenuPages value: $value'),
    );
  }
}

class PVMainMenuUiPagesProvider extends ChangeNotifier {
  EnMainMenuPages page = EnMainMenuPages.eCustomerStoresSuggestions;

  void changePage(EnMainMenuPages page) {
    this.page = page;
    notifyListeners();
  }
}

class CustomerMainMenuUi extends StatefulWidget {
  const CustomerMainMenuUi({super.key});

  @override
  State<CustomerMainMenuUi> createState() {
    return _CustomerMinMenuUi();
  }
}

class _CustomerMinMenuUi extends State<CustomerMainMenuUi> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      title: 'A TO Z',
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Consumer<PVMainMenuUiPagesProvider>(
            builder: (context, value, child) {
              if (value.page == EnMainMenuPages.eSearchCustomerStores) {
                return Expanded(
                  child: MultiProvider(
                    providers: [
                      ChangeNotifierProvider(
                        create: (_) => PVCustomerSearchStores(),
                      ),
                      ChangeNotifierProvider(
                        create: (_) => PVCustomerPreviousRequestsStores(),
                      ),
                      ChangeNotifierProvider.value(
                        value: context.read<PVBaseCurrentLoginInfo>(),
                      ),
                      ChangeNotifierProvider(create: (_) => PVSearch()),
                    ],
                    child: const SearchCustomerStoresUi(),
                  ),
                );
              }
              if (value.page == EnMainMenuPages.eCustomerFavoriteStores) {
                return Expanded(
                  child: MultiProvider(
                    providers: [
                      ChangeNotifierProvider(
                        create: (_) => PVCustomerFavoriteStores(),
                      ),
                      ChangeNotifierProvider.value(
                        value: context.read<PVBaseCurrentLoginInfo>(),
                      ),
                    ],
                    child: const CustomerFavoriteStoresUi(),
                  ),
                );
              }

              if (value.page == EnMainMenuPages.eCustomerFamousStores) {
                return Expanded(
                  child: MultiProvider(
                    providers: [
                      ChangeNotifierProvider(
                        create: (_) => PVCustomerFamousStores(),
                      ),
                      ChangeNotifierProvider.value(
                        value: context.read<PVBaseCurrentLoginInfo>(),
                      ),
                    ],
                    child: const CustomerFamousStoresUi(),
                  ),
                );
              }
              return Expanded(
                child: MultiProvider(
                  providers: [
                    ChangeNotifierProvider(
                      create: (_) => PVCustomerStoresSuggestions(),
                    ),
                    ChangeNotifierProvider.value(
                      value: context.read<PVBaseCurrentLoginInfo>(),
                    ),
                    ChangeNotifierProvider(
                      create: (_) => PVStoreTypesWithColors(),
                    ),
                  ],
                  child: const CustomerStoresSuggestionsUi(),
                ),
              );
            },
          ),

          const BottomLineMainMenu(),
        ],
      ),
    );
  }
}
