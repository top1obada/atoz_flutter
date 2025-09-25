import 'package:a_to_z_widgets/ATOZImages/get_image_by_link.dart';
import 'package:a_to_z_widgets/Interfaces/widget_getter.dart';
import 'package:flutter/material.dart';
import 'package:a_to_z_dto/SubCategoryDTO/sub_category_dto.dart';

class WDStoreSubCategoryCard extends StatefulWidget {
  const WDStoreSubCategoryCard({
    super.key,
    required this.storeSubCategoryDTO,
    this.onCardClicked,
  });

  final ClsSubCategoryDTO storeSubCategoryDTO;
  final Function(ClsSubCategoryDTO?)? onCardClicked;

  @override
  State<WDStoreSubCategoryCard> createState() => _WDStoreSubCategoryCardState();
}

class _WDStoreSubCategoryCardState extends State<WDStoreSubCategoryCard> {
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
          widget.onCardClicked?.call(widget.storeSubCategoryDTO);
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
                // SubCategory Image - Fills entire width
                _buildSubCategoryImage(isSmallDevice, isLargeDevice),

                const SizedBox(height: 6),

                // SubCategory Name - Centered
                Text(
                  widget.storeSubCategoryDTO.subCategoryName ??
                      'فئة فرعية غير معروفة',
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

  Widget _buildSubCategoryImage(bool isSmallDevice, bool isLargeDevice) {
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
            widget.storeSubCategoryDTO.subCategoryImage != null &&
                    widget.storeSubCategoryDTO.subCategoryImage!.isNotEmpty
                ? CloudinaryImage(
                  imageUrl: widget.storeSubCategoryDTO.subCategoryImage!,
                  imageHeight: imageHeight,
                )
                : _buildPlaceholderIcon(imageHeight),
      ),
    );
  }

  Widget _buildPlaceholderIcon(double height) {
    return Center(
      child: Icon(Icons.category, color: Colors.grey[400], size: height * 0.5),
    );
  }
}

class GetStoreSubCategoryWidget implements WidgetGetter {
  @override
  Widget getWidget(Object value, Function(Object?)? onClick) {
    return WDStoreSubCategoryCard(
      storeSubCategoryDTO: value as ClsSubCategoryDTO,
      onCardClicked: onClick,
    );
  }
}
