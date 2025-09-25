import 'package:a_to_z_dto/CategoryDTO/category_dto.dart';
import 'package:a_to_z_providers/BasesProviders/base_current_login_info_provider.dart';
import 'package:a_to_z_providers/CategoryProviders/store_categories_provider.dart';
import 'package:a_to_z_providers/ItemProviders/store_sub_category_item_items_provider.dart';
import 'package:a_to_z_providers/SubCategoryItemProviders/store_sub_category_sub_category_item_provider.dart';
import 'package:a_to_z_ui/SubCategoryUI/store_sub_categories_ui.dart';
import 'package:a_to_z_ui/TemplatesUI/cards_template.dart';
import 'package:a_to_z_widgets/CategoryWidgets/store_category_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:a_to_z_providers/RequestProviders/show_request_provider.dart';

import 'package:my_widgets/StoreWidgets/store_header_with_badge_widget.dart';
import 'package:a_to_z_dto/FilterDTO/store_categories_filter_dto.dart';
import 'package:a_to_z_providers/SubCategoryProviders/store_category_sub_category_provider.dart';
import 'package:a_to_z_ui/Libraries/open_screens.dart';

class StoreCategoriesScreen extends StatefulWidget {
  final int storeID;
  final String storeName;

  const StoreCategoriesScreen({
    super.key,
    required this.storeID,
    required this.storeName,
  });

  @override
  State<StoreCategoriesScreen> createState() => _StoreCategoriesScreenState();
}

class _StoreCategoriesScreenState extends State<StoreCategoriesScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _scrollController.addListener(() async {
        if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent) {
          await _loadCategories();
        }
      });
      context.read<PVShowRequest>().requestShow!.storeName = widget.storeName;
      context.read<PVShowRequest>().requestShow!.storeID = widget.storeID;

      await _loadCategories();
    });
  }

  Future<void> _loadCategories() async {
    await context.read<PVStoreCategories>().getStoreCategories(
      ClsStoreCategoriesFilterDTO(storeID: widget.storeID, pageSize: 10),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Selector<PVShowRequest, int>(
              selector: (con, provider) => provider.itemsCount,
              builder:
                  (con, value, child) =>
                  // Header with badge
                  StoreHeaderWithBadge(
                    title: 'فئات ${widget.storeName}',
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
              child: Consumer<PVStoreCategories>(
                builder: (con, provider, child) {
                  return CardsTemplate(
                    scrollController: _scrollController,
                    isLoaded: provider.isLoaded,
                    isFinished: provider.isFinished,
                    values: provider.storeCategories,
                    lineLength: 2,
                    widgetGetter: GetStoreCategoryWidget(),
                    onCardClick: (c) {
                      ClsCategoryDto storeCategoryDto = c as ClsCategoryDto;

                      if (storeCategoryDto.categoryID == null) {
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
                                              PVStoreCategorySubCategories
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
                                        context
                                            .read<
                                              PVStoreSubCategorySubCategoryItems
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
                                child: StoreCategorySubCategoriesScreen(
                                  storeID: widget.storeID,
                                  categoryID: storeCategoryDto.categoryID!,
                                  storeName: widget.storeName,
                                  categoryName: storeCategoryDto.categoryName!,
                                ),
                              ),
                        ),
                      ).then(
                        (c) =>
                            context
                                .read<PVStoreCategorySubCategories>()
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
