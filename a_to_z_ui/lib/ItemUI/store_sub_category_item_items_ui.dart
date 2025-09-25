import 'package:a_to_z_dto/FilterDTO/store_sub_category_item_items_filter_dto.dart';
import 'package:a_to_z_dto/ItemDTO/store_sub_category_item_item_dto.dart';
import 'package:a_to_z_providers/ItemProviders/store_sub_category_item_items_provider.dart';
import 'package:a_to_z_ui/TemplatesUI/cards_template.dart';
import 'package:a_to_z_widgets/ItemWidgets/store_sub_category_item_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_widgets/StoreWidgets/store_header_with_badge_widget.dart';
import 'package:a_to_z_providers/RequestProviders/show_request_provider.dart';
import 'package:a_to_z_ui/Libraries/open_screens.dart';

class StoreSubCategoryItemItemsScreen extends StatefulWidget {
  final int storeID;
  final int subCategoryItemID;
  final String storeName;
  final String subCategoryItemName;

  const StoreSubCategoryItemItemsScreen({
    super.key,
    required this.storeID,
    required this.subCategoryItemID,
    required this.storeName,
    required this.subCategoryItemName,
  });

  @override
  State<StoreSubCategoryItemItemsScreen> createState() =>
      _StoreSubCategoryItemItemsScreenState();
}

class _StoreSubCategoryItemItemsScreenState
    extends State<StoreSubCategoryItemItemsScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _scrollController.addListener(() async {
        if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent) {
          await _loadSubCategoryItemItems();
        }
      });

      await _loadSubCategoryItemItems();
    });
  }

  Future<void> _loadSubCategoryItemItems() async {
    await context
        .read<PVStoreSubCategoryItemItems>()
        .getStoreSubCategoryItemItems(
          ClsStoreSubCategoryItemItemsFilterDTO(
            storeID: widget.storeID,
            subCategoryItemID: widget.subCategoryItemID,
            pageSize: 10,
          ),
        );
  }

  void _onAddItemClick(Object? item) {
    // Handle item count changes - add to cart or update request
    ClsStoreSubCategoryItemItemDTO storeSubCategoryItemItemDTO =
        item as ClsStoreSubCategoryItemItemDTO;

    // Get the current count before adding
    int currentCount = storeSubCategoryItemItemDTO.count ?? 0;

    // Add the item
    context.read<PVShowRequest>().addItem(storeSubCategoryItemItemDTO);

    context.read<PVStoreSubCategoryItemItems>().decreaseCountOneItem(
      storeSubCategoryItemItemDTO,
    );

    // Show success message based on the count
    _showSuccessMessage(currentCount);
  }

  void _showSuccessMessage(int previousCount) {
    final newCount = previousCount;
    String message;

    if (newCount == 1) {
      message = 'تم إضافة المنتج بنجاح';
    } else {
      message = 'تم إضافة $newCount منتجات بنجاح';
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(
            fontFamily: 'Tajawal',
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
            Selector<PVShowRequest, int>(
              selector: (con, provider) => provider.itemsCount,
              builder:
                  (cpn, value, child) => StoreHeaderWithBadge(
                    title:
                        '${widget.subCategoryItemName} - ${widget.storeName}',
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
              child: Consumer<PVStoreSubCategoryItemItems>(
                builder: (context, provider, child) {
                  return CardsTemplate(
                    scrollController: _scrollController,
                    isLoaded: provider.isLoaded,
                    isFinished: provider.isFinished,
                    values:
                        provider.storeSubCategoryItemItems == null
                            ? null
                            : provider.storeSubCategoryItemItems!
                                .where(
                                  (c) =>
                                      c.subCategoryItemID ==
                                      widget.subCategoryItemID,
                                )
                                .toList(),
                    lineLength: 2,
                    widgetGetter: GetStoreSubCategoryItemItemWidget(),
                    onCardClick: _onAddItemClick,
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
