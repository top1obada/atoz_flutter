import 'package:a_to_z_dto/ItemDTO/store_sub_category_item_item_dto.dart';
import 'package:a_to_z_widgets/ATOZImages/get_image_by_link.dart';
import 'package:a_to_z_widgets/Interfaces/widget_getter.dart';
import 'package:flutter/material.dart';

class WDStoreSubCategoryItemItemCardShow extends StatefulWidget {
  const WDStoreSubCategoryItemItemCardShow({
    super.key,
    required this.storeItemDTO,
    this.onRemove,
    this.showRemoveButton = false,
  });

  final ClsStoreSubCategoryItemItemDTO storeItemDTO;
  final Function(ClsStoreSubCategoryItemItemDTO)? onRemove;

  final bool showRemoveButton;

  @override
  State<WDStoreSubCategoryItemItemCardShow> createState() =>
      _WDStoreSubCategoryItemItemCardShowState();
}

class _WDStoreSubCategoryItemItemCardShowState
    extends State<WDStoreSubCategoryItemItemCardShow> {
  bool _isRemoving = false;
  bool _isRemoved = false;

  // Helper method to check if discount is valid
  bool get _hasValidDiscount {
    return widget.storeItemDTO.priceAfterDiscount != null &&
        widget.storeItemDTO.priceAfterDiscount! < widget.storeItemDTO.price!;
  }

  // Get current price per unit (discounted or regular)
  double get _currentUnitPrice {
    return _hasValidDiscount
        ? widget.storeItemDTO.priceAfterDiscount!
        : widget.storeItemDTO.price ?? 0;
  }

  // Get total price for all units
  double get _totalPrice {
    return _currentUnitPrice * (widget.storeItemDTO.count ?? 0);
  }

  // Get original total price without discount
  double get _originalTotalPrice {
    return (widget.storeItemDTO.price ?? 0) * (widget.storeItemDTO.count ?? 0);
  }

  void _handleRemove() {
    if (_isRemoved || _isRemoving) return;

    setState(() {
      _isRemoving = true;
    });

    // Call the remove callback after a short delay to show the visual feedback
    Future.delayed(const Duration(milliseconds: 300), () {
      if (widget.onRemove != null) {
        widget.onRemove!(widget.storeItemDTO);
      }

      setState(() {
        _isRemoving = false;
        _isRemoved = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallDevice = screenWidth < 360;
    final isLargeDevice = screenWidth > 600;

    return Padding(
      padding: const EdgeInsets.all(4),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Colors.grey[300]!, width: 1),
        ),
        child: Container(
          width: isSmallDevice ? 150 : (isLargeDevice ? 180 : 160),
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Item Image - Same size as interactive version
              _buildItemImage(isSmallDevice, isLargeDevice),

              const SizedBox(height: 6),

              // Item Name
              Text(
                widget.storeItemDTO.description ?? 'منتج غير معروف',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: isSmallDevice ? 19 : 24,
                  color: Colors.black87,
                  overflow: TextOverflow.ellipsis,
                  fontFamily: 'Tajawal',
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
              ),

              const SizedBox(height: 4),

              // Price information
              _buildPriceSection(),

              const SizedBox(height: 6),

              // Count display
              _buildCountDisplay(),

              const SizedBox(height: 6),

              if (widget.showRemoveButton) _buildRemoveButton(),
            ],
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
        color: Colors.grey[200],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child:
            widget.storeItemDTO.itemImage != null &&
                    widget.storeItemDTO.itemImage!.isNotEmpty
                ? CloudinaryImage(
                  imageUrl: widget.storeItemDTO.itemImage!,
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
                  fontSize: 10,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Tajawal',
                  decoration: TextDecoration.lineThrough,
                ),
              ),
              Text(
                _originalTotalPrice.toStringAsFixed(0),
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Tajawal',
                  decoration: TextDecoration.lineThrough,
                ),
              ),
            ],
          ),

        // Current price
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'ليرة سورية ',
              style: TextStyle(
                fontSize: 12,
                color: _hasValidDiscount ? Colors.red[700] : Colors.green[700],
                fontWeight: FontWeight.w600,
                fontFamily: 'Tajawal',
              ),
            ),
            Text(
              _totalPrice.toStringAsFixed(0),
              style: TextStyle(
                fontSize: 12,
                color: _hasValidDiscount ? Colors.red[700] : Colors.green[700],
                fontWeight: FontWeight.w600,
                fontFamily: 'Tajawal',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCountDisplay() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue[200]!),
      ),
      child: Text(
        'الكمية: ${widget.storeItemDTO.count ?? 0}',
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Colors.blue,
          fontFamily: 'Tajawal',
        ),
      ),
    );
  }

  Widget _buildRemoveButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isRemoved ? null : _handleRemove,
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
            if (states.contains(WidgetState.disabled)) {
              return Colors.grey[300]!;
            }
            if (states.contains(WidgetState.pressed) || _isRemoving) {
              return Colors.red;
            }
            return Colors.pink;
          }),
          foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
          padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
            const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
          ),
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          elevation: WidgetStateProperty.all<double>(2),
          textStyle: WidgetStateProperty.resolveWith<TextStyle>((states) {
            if (states.contains(WidgetState.disabled)) {
              return const TextStyle(
                fontFamily: 'Tajawal',
                fontWeight: FontWeight.bold,
                fontSize: 12,
              );
            }
            return const TextStyle(
              fontFamily: 'Tajawal',
              fontWeight: FontWeight.normal,
              fontSize: 12,
            );
          }),
        ),
        child:
            _isRemoving
                ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
                : Text(
                  _isRemoved ? 'تم الحذف' : 'إزالة',
                  style: TextStyle(
                    fontFamily: 'Tajawal',
                    fontWeight:
                        _isRemoved ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
      ),
    );
  }
}

class GetStoreSubCategoryItemItemShowWidget implements WidgetGetter {
  final Function(ClsStoreSubCategoryItemItemDTO)? onRemove;

  GetStoreSubCategoryItemItemShowWidget({this.onRemove});

  @override
  Widget getWidget(Object value, Function(Object?)? onRemove) {
    bool showRemoveButtonC = onRemove != null;

    return WDStoreSubCategoryItemItemCardShow(
      storeItemDTO: value as ClsStoreSubCategoryItemItemDTO,
      onRemove: onRemove,
      showRemoveButton: showRemoveButtonC,
    );
  }
}
