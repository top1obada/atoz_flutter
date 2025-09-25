import 'package:a_to_z_dto/StoreDTO/customer_store_suggestion_dto.dart';
import 'package:a_to_z_providers/BasesProviders/base_current_login_info_provider.dart';
import 'package:a_to_z_providers/CategoryProviders/store_categories_provider.dart';
import 'package:a_to_z_providers/ItemProviders/store_sub_category_item_items_provider.dart';
import 'package:a_to_z_providers/RequestProviders/request_provider.dart';
import 'package:a_to_z_providers/RequestProviders/show_request_provider.dart';
import 'package:a_to_z_providers/SubCategoryItemProviders/store_sub_category_sub_category_item_provider.dart';
import 'package:a_to_z_providers/SubCategoryProviders/store_category_sub_category_provider.dart';
import 'package:a_to_z_ui/CategoryUI/store_categories_ui.dart';
import 'package:a_to_z_ui/RequestUI/request_content_ui.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OpenScreens {
  OpenScreens._();
  static void onCartIconPressed(
    BuildContext context,
    String? storeName,
    int? storeID,
  ) {
    final provider = context.read<PVShowRequest>();

    provider.requestShow!.storeName = storeName;

    provider.requestShow!.storeID = storeID;

    PVRequest requestProvider = PVRequest();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (con) {
          return MultiProvider(
            providers: [
              ChangeNotifierProvider.value(value: provider),
              ChangeNotifierProvider.value(
                value: context.read<PVBaseCurrentLoginInfo>(),
              ),
              ChangeNotifierProvider(create: (_) => requestProvider),
              ChangeNotifierProvider.value(
                value: context.read<PVStoreSubCategoryItemItems>(),
              ),
            ],
            child: const RequestContentUi(),
          );
        },
      ),
    ).then((value) {
      if (requestProvider.isLoaded) {
        provider.clearRequest();
      }
    });
  }

  static void openStoreCategoriesScreen(
    BuildContext context,
    ClsCustomerStoreSuggestionDTO customerStoreSuggestionDTO,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (con) => MultiProvider(
              providers: [
                ChangeNotifierProvider(create: (_) => PVStoreCategories()),
                ChangeNotifierProvider.value(
                  value: context.read<PVBaseCurrentLoginInfo>(),
                ),
                ChangeNotifierProvider(create: (_) => PVShowRequest()),
                ChangeNotifierProvider(
                  create: (_) => PVStoreSubCategoryItemItems(),
                ),
                ChangeNotifierProvider(
                  create: (_) => PVStoreCategorySubCategories(),
                ),
                ChangeNotifierProvider(
                  create: (_) => PVStoreSubCategorySubCategoryItems(),
                ),
              ],
              child: StoreCategoriesScreen(
                storeID: customerStoreSuggestionDTO.storeID!,
                storeName: customerStoreSuggestionDTO.storeName!,
              ),
            ),
      ),
    );
  }
}
