import 'package:a_to_z_dto/SubCategoryItemDTO/sub_category_item_dto.dart';
import 'package:a_to_z_providers/BasesProviders/base_current_login_info_provider.dart';
import 'package:a_to_z_providers/ItemProviders/store_sub_category_item_items_provider.dart';
import 'package:a_to_z_providers/SubCategoryItemProviders/store_sub_category_sub_category_item_provider.dart';
import 'package:a_to_z_ui/ItemUI/store_sub_category_item_items_ui.dart';
import 'package:a_to_z_ui/TemplatesUI/cards_template.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_widgets/StoreWidgets/store_header_with_badge_widget.dart';
import 'package:a_to_z_widgets/SubCategoryItemWidgets/store_sub_category_item_widget.dart';
import 'package:a_to_z_providers/RequestProviders/show_request_provider.dart';
import 'package:a_to_z_ui/Libraries/open_screens.dart';
import 'package:a_to_z_dto/FilterDTO/store_sub_category_sub_category_items_dto.dart';

class StoreSubCategoryItemsScreen extends StatefulWidget {
  final int storeID;
  final String storeName;
  final int categoryID;
  final String categoryName;
  final int subCategoryID;
  final String subCategoryName;

  const StoreSubCategoryItemsScreen({
    super.key,
    required this.storeID,
    required this.storeName,
    required this.categoryID,
    required this.categoryName,
    required this.subCategoryID,
    required this.subCategoryName,
  });

  @override
  State<StoreSubCategoryItemsScreen> createState() =>
      _StoreSubCategoryItemsScreenState();
}

class _StoreSubCategoryItemsScreenState
    extends State<StoreSubCategoryItemsScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _scrollController.addListener(() async {
        if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent) {
          await _loadSubCategoryItems();
        }
      });
      await _loadSubCategoryItems();
    });
  }

  Future<void> _loadSubCategoryItems() async {
    await context
        .read<PVStoreSubCategorySubCategoryItems>()
        .getStoreSubCategorySubCategoryItems(
          ClsStoreSubCategorySubCategoryItemsFilterDTO(
            storeID: widget.storeID,
            pageSize: 10,
            subCategoryID: widget.subCategoryID,
          ),
        );
  }

  void _onSubCategoryItemClick(Object? object) {
    ClsSubCategoryItem subCategoryItem = object as ClsSubCategoryItem;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (con) => MultiProvider(
              providers: [
                ChangeNotifierProvider.value(
                  value: context.read<PVStoreSubCategoryItemItems>(),
                ),
                ChangeNotifierProvider.value(
                  value: context.read<PVShowRequest>(),
                ),
                ChangeNotifierProvider.value(
                  value: context.read<PVBaseCurrentLoginInfo>(),
                ),
              ],
              child: StoreSubCategoryItemItemsScreen(
                storeID: widget.storeID,
                subCategoryItemID: subCategoryItem.subCategoryItemID!,
                storeName: widget.storeName,
                subCategoryItemName: subCategoryItem.subCategoryItemTypeName!,
              ),
            ),
      ),
    ).then((c) => context.read<PVStoreSubCategoryItemItems>().initToLoad());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Selector<PVShowRequest, int>(
              selector: (context, provider) => provider.itemsCount,
              builder:
                  (context, value, child) =>
                  // Header with badge
                  StoreHeaderWithBadge(
                    title: '${widget.subCategoryName} - ${widget.storeName}',
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
              child: Consumer<PVStoreSubCategorySubCategoryItems>(
                builder: (con, provider, child) {
                  return CardsTemplate(
                    scrollController: _scrollController,
                    isLoaded: provider.isLoaded,
                    isFinished: provider.isFinished,
                    values:
                        provider.storeSubCategoryItems == null
                            ? null
                            : provider.storeSubCategoryItems!
                                .where(
                                  (c) =>
                                      c.subCategoryID == widget.subCategoryID,
                                )
                                .toList(),
                    lineLength: 2,
                    widgetGetter: GetStoreSubCategoryItemWidget(),
                    onCardClick: _onSubCategoryItemClick,
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
