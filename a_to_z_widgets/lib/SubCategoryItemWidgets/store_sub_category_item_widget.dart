import 'package:a_to_z_widgets/ATOZImages/get_image_by_link.dart';
import 'package:a_to_z_widgets/Interfaces/widget_getter.dart';
import 'package:flutter/material.dart';
import 'package:a_to_z_dto/SubCategoryItemDTO/sub_category_item_dto.dart';

class WDStoreSubCategoryItemCard extends StatefulWidget {
  const WDStoreSubCategoryItemCard({
    super.key,
    required this.storeSubCategoryItemDTO,
    this.onCardClicked,
  });

  final ClsSubCategoryItem storeSubCategoryItemDTO;
  final Function(ClsSubCategoryItem?)? onCardClicked;

  @override
  State<WDStoreSubCategoryItemCard> createState() =>
      _WDStoreSubCategoryItemCardState();
}

class _WDStoreSubCategoryItemCardState
    extends State<WDStoreSubCategoryItemCard> {
  bool _isPressed = false;
  final Color _normalColor = Colors.white;
  final Color _pressedColor = Colors.blue[50]!;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallDevice = screenWidth < 360;
    final isLargeDevice = screenWidth > 600;

    return Padding(
      padding: EdgeInsets.all(4),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        onTap: () {
          widget.onCardClicked?.call(widget.storeSubCategoryItemDTO);
          setState(() => _isPressed = false);
        },
        child: Card(
          color: _isPressed ? _pressedColor : _normalColor,
          elevation: _isPressed ? 3 : 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: _isPressed ? Colors.blue[300]! : Colors.grey[300]!,
              width: _isPressed ? 1.5 : 1,
            ),
          ),
          margin: const EdgeInsets.all(6),
          child: Container(
            width: isSmallDevice ? 150 : (isLargeDevice ? 180 : 160),
            height: isSmallDevice ? 150 : (isLargeDevice ? 180 : 160),
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // SubCategoryItem Image - Fills entire width
                _buildSubCategoryItemImage(isSmallDevice, isLargeDevice),

                const SizedBox(height: 6),

                // SubCategoryItem Name - Centered
                Text(
                  widget.storeSubCategoryItemDTO.subCategoryItemTypeName ??
                      'عنصر غير معروف',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: isSmallDevice ? 19 : 24,
                    color: _isPressed ? Colors.blue[800]! : Colors.black87,
                    overflow: TextOverflow.ellipsis,
                    fontFamily: 'Tajawal',
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSubCategoryItemImage(bool isSmallDevice, bool isLargeDevice) {
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
            widget.storeSubCategoryItemDTO.subCategoryItemImage != null &&
                    widget
                        .storeSubCategoryItemDTO
                        .subCategoryItemImage!
                        .isNotEmpty
                ? CloudinaryImage(
                  imageUrl:
                      widget.storeSubCategoryItemDTO.subCategoryItemImage!,
                  imageHeight: imageHeight,
                )
                : _buildPlaceholderIcon(imageHeight),
      ),
    );
  }

  Widget _buildPlaceholderIcon(double height) {
    return Center(
      child: Icon(
        Icons.inventory_2,
        color: Colors.grey[400],
        size: height * 0.5,
      ),
    );
  }
}

class GetStoreSubCategoryItemWidget implements WidgetGetter {
  @override
  Widget getWidget(Object value, Function(Object?)? onClick) {
    return WDStoreSubCategoryItemCard(
      storeSubCategoryItemDTO: value as ClsSubCategoryItem,
      onCardClicked: onClick,
    );
  }
}
