import 'dart:async';

import 'package:a_to_z_dto/ItemDTO/store_sub_category_item_item_dto.dart';
import 'package:a_to_z_widgets/ATOZImages/get_image_by_link.dart';
import 'package:a_to_z_widgets/Interfaces/widget_getter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PVOnTap extends ChangeNotifier {
  bool isPressed = false;

  void changePressed(bool value) {
    isPressed = value;
    notifyListeners();
  }
}

class PVOCount extends ChangeNotifier {
  int? maxCount;
  int? currentCount;

  void changeCurrentCount(int value) {
    currentCount = value;
    notifyListeners();
  }
}

class WDStoreSubCategoryItemItemCard extends StatefulWidget {
  const WDStoreSubCategoryItemItemCard({
    super.key,
    required this.storeItemDTO,
    this.onAddClick,
  });

  final ClsStoreSubCategoryItemItemDTO storeItemDTO;
  final Function(ClsStoreSubCategoryItemItemDTO)? onAddClick;

  @override
  State<WDStoreSubCategoryItemItemCard> createState() =>
      _WDStoreSubCategoryItemItemCardState();
}

class _WDStoreSubCategoryItemItemCardState
    extends State<WDStoreSubCategoryItemItemCard> {
  final Color _normalColor = Colors.white;
  final Color _pressedColor = Colors.blue[50]!;

  final PVOnTap onTapProvider = PVOnTap();

  final PVOCount onCountProvider = PVOCount();

  Timer? _debounceTimer;

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _updateCount(int newCount) {
    _debounceTimer?.cancel();

    onCountProvider.changeCurrentCount(
      newCount.clamp(0, onCountProvider.maxCount ?? 0),
    );
  }

  void _incrementCount() {
    final newCount = onCountProvider.currentCount! + 1;
    if (newCount <= (onCountProvider.maxCount ?? 0)) {
      _updateCount(newCount);
    }
  }

  void _decrementCount() {
    final newCount = onCountProvider.currentCount! - 1;
    if (newCount >= 0) {
      _updateCount(newCount);
    }
  }

  // Helper method to check if discount is valid
  bool get _hasValidDiscount {
    return widget.storeItemDTO.priceAfterDiscount != null &&
        widget.storeItemDTO.priceAfterDiscount! < widget.storeItemDTO.price! &&
        (widget.storeItemDTO.discountEndDate == null ||
            widget.storeItemDTO.discountEndDate!.isAfter(DateTime.now()));
  }

  // Get current price (discounted or regular)
  double get _currentPrice {
    return _hasValidDiscount
        ? widget.storeItemDTO.priceAfterDiscount!
        : widget.storeItemDTO.price ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallDevice = screenWidth < 360;
    final isLargeDevice = screenWidth > 600;
    onCountProvider.maxCount = widget.storeItemDTO.count;
    onCountProvider.currentCount = 0;

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => onTapProvider),
        ChangeNotifierProvider(create: (_) => onCountProvider),
      ],
      child: Consumer<PVOnTap>(
        builder:
            (context, value, child) => Padding(
              padding: const EdgeInsets.all(4),
              child: GestureDetector(
                onTapDown: (_) => onTapProvider.changePressed(true),
                onTapUp: (_) => onTapProvider.changePressed(false),
                onTapCancel: () => onTapProvider.changePressed(false),
                child: Card(
                  color: onTapProvider.isPressed ? _pressedColor : _normalColor,
                  elevation: onTapProvider.isPressed ? 3 : 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(
                      color:
                          onTapProvider.isPressed
                              ? Colors.blue[300]!
                              : Colors.grey[300]!,
                      width: onTapProvider.isPressed ? 1.5 : 1,
                    ),
                  ),
                  margin: const EdgeInsets.all(6),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Item Image
                        _buildItemImage(isSmallDevice, isLargeDevice),

                        const SizedBox(height: 6),

                        // Item Name
                        Text(
                          widget.storeItemDTO.notes ?? 'منتج غير معروف',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: isSmallDevice ? 19 : 24,
                            color:
                                onTapProvider.isPressed
                                    ? Colors.blue[800]!
                                    : Colors.black87,
                            overflow: TextOverflow.ellipsis,
                            fontFamily: 'Tajawal',
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                        ),

                        const SizedBox(height: 4),

                        // Price with discount information
                        _buildPriceSection(),

                        const SizedBox(height: 6),

                        Consumer<PVOCount>(
                          builder:
                              (context, value, child) => _buildCountControls(),
                        ),

                        const SizedBox(height: 4),

                        Consumer<PVOCount>(
                          builder:
                              (context, value, child) =>
                                  // Add Button
                                  _buildAddButton(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
      ),
    );
  }

  Widget _buildItemImage(bool isSmallDevice, bool isLargeDevice) {
    final imageHeight = isSmallDevice ? 70.0 : (isLargeDevice ? 90.0 : 80.0);

    return Container(
      height: imageHeight,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey[100],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child:
            widget.storeItemDTO.imagepath != null &&
                    widget.storeItemDTO.imagepath!.isNotEmpty
                ? CloudinaryImage(
                  imageUrl: widget.storeItemDTO.imagepath!,
                  imageHeight: imageHeight,
                )
                : _buildPlaceholderIcon(imageHeight),
      ),
    );
  }

  Widget _buildPlaceholderIcon(double height) {
    return Center(
      child: Icon(
        Icons.shopping_bag,
        color: Colors.grey[400],
        size: height * 0.5,
      ),
    );
  }

  Widget _buildPriceSection() {
    return Column(
      children: [
        // Original price with strikethrough if discounted
        if (_hasValidDiscount)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'ليرة سورية ',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Tajawal',
                  decoration: TextDecoration.lineThrough,
                ),
              ),
              Text(
                widget.storeItemDTO.price?.toStringAsFixed(2) ?? '0.00',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Tajawal',
                  decoration: TextDecoration.lineThrough,
                ),
              ),
            ],
          ),

        // Current price (discounted or regular)
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'ليرة سورية ',
              style: TextStyle(
                fontSize: 14,
                color: _hasValidDiscount ? Colors.red[700] : Colors.green[700],
                fontWeight: FontWeight.bold,
                fontFamily: 'Tajawal',
              ),
            ),
            Text(
              _currentPrice.toStringAsFixed(2),
              style: TextStyle(
                fontSize: 14,
                color: _hasValidDiscount ? Colors.red[700] : Colors.green[700],
                fontWeight: FontWeight.bold,
                fontFamily: 'Tajawal',
              ),
            ),
          ],
        ),

        // Discount end date if applicable
        if (_hasValidDiscount && widget.storeItemDTO.discountEndDate != null)
          Text(
            'ينتهي العرض: ${_formatDate(widget.storeItemDTO.discountEndDate!)}',
            style: TextStyle(
              fontSize: 12,
              color: Colors.orange[700],
              fontWeight: FontWeight.bold,
              fontFamily: 'Tajawal',
            ),
          ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  Widget _buildCountControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Minus Button
        IconButton(
          icon: const Icon(Icons.remove, size: 18),
          onPressed: onCountProvider.currentCount! > 0 ? _decrementCount : null,
          style: IconButton.styleFrom(
            backgroundColor:
                onCountProvider.currentCount! > 0
                    ? Colors.red[100]
                    : Colors.grey[200],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),

        // Count Display
        Container(
          width: 40,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Text(
            onCountProvider.currentCount.toString(),
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              fontFamily: 'Tajawal',
            ),
          ),
        ),

        // Plus Button
        IconButton(
          icon: const Icon(Icons.add, size: 18),
          onPressed:
              onCountProvider.currentCount! < (onCountProvider.maxCount ?? 0)
                  ? _incrementCount
                  : null,
          style: IconButton.styleFrom(
            backgroundColor:
                onCountProvider.currentCount! < (onCountProvider.maxCount ?? 0)
                    ? Colors.green[100]
                    : Colors.grey[200],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAddButton() {
    return ElevatedButton(
      onPressed:
          onCountProvider.currentCount! > 0
              ? () {
                // Create a copy with the current count
                final itemToAdd = ClsStoreSubCategoryItemItemDTO(
                  storeItemID: widget.storeItemDTO.storeItemID,

                  price: widget.storeItemDTO.price,
                  count: onCountProvider.currentCount,
                  notes: widget.storeItemDTO.notes,
                  imagepath: widget.storeItemDTO.imagepath,
                  subCategoryItemTypeName:
                      widget.storeItemDTO.subCategoryItemTypeName,
                  priceAfterDiscount: widget.storeItemDTO.priceAfterDiscount,
                  discountEndDate: widget.storeItemDTO.discountEndDate,
                );
                widget.onAddClick?.call(itemToAdd);
              }
              : null,
      style: ElevatedButton.styleFrom(
        backgroundColor:
            onCountProvider.currentCount! > 0
                ? Colors.blue[600]
                : Colors.grey[400],
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.bold,
          fontFamily: 'Tajawal',
        ),
      ),
      child: const Text('إضافة إلى السلة'),
    );
  }
}

class GetStoreSubCategoryItemItemWidget implements WidgetGetter {
  @override
  Widget getWidget(Object value, Function(Object?)? onClick) {
    return WDStoreSubCategoryItemItemCard(
      storeItemDTO: value as ClsStoreSubCategoryItemItemDTO,
      onAddClick: onClick,
    );
  }
}
