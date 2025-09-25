import 'package:a_to_z_dto/FilterDTO/store_category_sub_categories_dto.dart';

import 'package:a_to_z_dto/SubCategoryDTO/sub_category_dto.dart';
import 'package:a_to_z_providers/BasesProviders/base_current_login_info_provider.dart';
import 'package:a_to_z_providers/ItemProviders/store_sub_category_item_items_provider.dart';

import 'package:a_to_z_providers/SubCategoryProviders/store_category_sub_category_provider.dart';

import 'package:a_to_z_ui/SubCategoryItemUI/store_sub_category_item_ui.dart';
import 'package:a_to_z_ui/TemplatesUI/cards_template.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_widgets/StoreWidgets/store_header_with_badge_widget.dart';
import 'package:a_to_z_widgets/SubCategoryWidgets/store_sub_category_widget.dart';
import 'package:a_to_z_providers/RequestProviders/show_request_provider.dart';
import 'package:a_to_z_ui/Libraries/open_screens.dart';
import 'package:a_to_z_providers/SubCategoryItemProviders/store_sub_category_sub_category_item_provider.dart';

class StoreCategorySubCategoriesScreen extends StatefulWidget {
  final int storeID;
  final String storeName;
  final int categoryID;
  final String categoryName;

  const StoreCategorySubCategoriesScreen({
    super.key,
    required this.storeID,
    required this.storeName,
    required this.categoryID,
    required this.categoryName,
  });

  @override
  State<StoreCategorySubCategoriesScreen> createState() =>
      _StoreCategorySubCategoriesScreenState();
}

class _StoreCategorySubCategoriesScreenState
    extends State<StoreCategorySubCategoriesScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _scrollController.addListener(() async {
        if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent) {
          await _loadSubCategories();
        }
      });
      await _loadSubCategories();
    });
  }

  Future<void> _loadSubCategories() async {
    await context
        .read<PVStoreCategorySubCategories>()
        .getStoreCategorySubCategories(
          ClsStoreCategorySubCategoriesFilterDTO(
            storeID: widget.storeID,
            pageSize: 10,
            categoryID: widget.categoryID,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header with badge
            Selector<PVShowRequest, int>(
              selector: (context, provider) => provider.itemsCount,
              builder:
                  (context, value, child) => StoreHeaderWithBadge(
                    title: '${widget.categoryName} - ${widget.storeName}',
                    itemCount: value,
                    icon: Icons.shopping_cart,
                    onIconPressed:
                        value > 0
                            ? () => OpenScreens.onCartIconPressed(
                              context,
                              widget.storeName,
                              widget.storeID,
                            )
                            : null,
                  ),
            ),
            const SizedBox(height: 8),

            Expanded(
              child: Consumer<PVStoreCategorySubCategories>(
                builder: (con, provider, child) {
                  return CardsTemplate(
                    scrollController: _scrollController,
                    isLoaded: provider.isLoaded,
                    isFinished: provider.isFinished,
                    values:
                        provider.storeSubCategories == null
                            ? null
                            : provider.storeSubCategories!
                                .where((c) => c.categoryID == widget.categoryID)
                                .toList(),
                    lineLength: 2,
                    widgetGetter: GetStoreSubCategoryWidget(),
                    onCardClick: (c) {
                      ClsSubCategoryDTO storeSubCategoryDto =
                          c as ClsSubCategoryDTO;

                      if (storeSubCategoryDto.subCategoryID == null) {
                        return;
                      }

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (con) => MultiProvider(
                                providers: [
                                  ChangeNotifierProvider.value(
                                    value:
                                        context
                                            .read<
                                              PVStoreSubCategorySubCategoryItems
                                            >(),
                                  ),
                                  ChangeNotifierProvider.value(
                                    value:
                                        context
                                            .read<
                                              PVStoreSubCategoryItemItems
                                            >(),
                                  ),
                                  ChangeNotifierProvider.value(
                                    value:
                                        context.read<PVBaseCurrentLoginInfo>(),
                                  ),
                                  ChangeNotifierProvider.value(
                                    value: context.read<PVShowRequest>(),
                                  ),
                                ],

                                child: StoreSubCategoryItemsScreen(
                                  storeID: widget.storeID,
                                  categoryID: widget.categoryID,
                                  storeName: widget.storeName,
                                  categoryName: widget.categoryName,
                                  subCategoryID:
                                      storeSubCategoryDto.subCategoryID!,
                                  subCategoryName:
                                      storeSubCategoryDto.subCategoryName!,
                                ),
                              ),
                        ),
                      ).then(
                        (c) =>
                            context
                                .read<PVStoreSubCategorySubCategoryItems>()
                                .initToLoad(),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
