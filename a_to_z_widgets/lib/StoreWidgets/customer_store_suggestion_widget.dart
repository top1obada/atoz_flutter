import 'package:a_to_z_widgets/ATOZImages/get_image_by_link.dart';
import 'package:a_to_z_widgets/Interfaces/widget_getter.dart';
import 'package:flutter/material.dart';
import 'package:a_to_z_dto/StoreDTO/customer_store_suggestion_dto.dart';
import 'package:my_widgets/Colors/color_service.dart';

class WDStoreSuggestionCard extends StatefulWidget {
  const WDStoreSuggestionCard({
    super.key,
    required this.storeSuggestionDTO,
    this.onCardClicked,
  });

  final ClsCustomerStoreSuggestionDTO storeSuggestionDTO;
  final Function(ClsCustomerStoreSuggestionDTO?)? onCardClicked;

  @override
  State<WDStoreSuggestionCard> createState() => _WDStoreSuggestionCardState();
}

class _WDStoreSuggestionCardState extends State<WDStoreSuggestionCard> {
  bool _isPressed = false;
  final Color _normalColor = Colors.white;
  final Color _pressedColor =
      Colors.blue[50]!; // Light blue background when pressed

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
          widget.onCardClicked?.call(widget.storeSuggestionDTO);
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
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Store Image - Fills entire width
                _buildStoreImage(isSmallDevice, isLargeDevice),

                const SizedBox(height: 6),

                // Store Name - Centered
                Text(
                  widget.storeSuggestionDTO.storeName ?? 'متجر غير معروف',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: isSmallDevice ? 20 : 25,
                    color: Colors.black,
                    overflow: TextOverflow.ellipsis,
                    fontFamily: 'Tajawal',
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                ),

                const SizedBox(height: 1),

                // Store Type - Centered
                Text(
                  widget.storeSuggestionDTO.storeTypeName ?? 'نوع غير معروف',
                  style: TextStyle(
                    fontSize: isSmallDevice ? 15 : 20,
                    color: ColorService.parseColor(
                      widget.storeSuggestionDTO.hexCode,
                      widget.storeSuggestionDTO.shade,
                    ),
                    overflow: TextOverflow.ellipsis,
                    fontFamily: 'Tajawal',
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                ),

                const SizedBox(height: 15),

                // Distance - Centered
                _buildDistanceInfo(isSmallDevice),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStoreImage(bool isSmallDevice, bool isLargeDevice) {
    final imageHeight = isSmallDevice ? 70.0 : (isLargeDevice ? 90.0 : 80.0);

    return Container(
      height: imageHeight,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child:
            widget.storeSuggestionDTO.storeImage != null &&
                    widget.storeSuggestionDTO.storeImage!.isNotEmpty
                ? CloudinaryImage(
                  imageUrl: widget.storeSuggestionDTO.storeImage!,
                  imageHeight: imageHeight,
                )
                : _buildPlaceholderIcon(imageHeight),
      ),
    );
  }

  Widget _buildPlaceholderIcon(double height) {
    return Center(
      child: Icon(
        Icons.store_mall_directory,
        color: Colors.grey[400],
        size: height * 0.5,
      ),
    );
  }

  Widget _buildDistanceInfo(bool isSmallDevice) {
    final distanceInMeters = widget.storeSuggestionDTO.distanceInMeters ?? 0;
    final distanceInKm = distanceInMeters / 1000;
    final formattedDistance = distanceInKm.toStringAsFixed(1);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.location_on,
          size: isSmallDevice ? 11 : 15,
          color: Colors.red,
        ),
        const SizedBox(width: 3),
        Text(
          '$formattedDistance كم',
          style: TextStyle(
            fontSize: isSmallDevice ? 12 : 15,
            color: Colors.grey[600],
            fontWeight: FontWeight.bold,
            fontFamily: 'Tajawal',
          ),
        ),
      ],
    );
  }
}

class GetCustomerStoreSuggestionWidget implements WidgetGetter {
  @override
  Widget getWidget(Object value, Function(Object?)? onClick) {
    return WDStoreSuggestionCard(
      storeSuggestionDTO: value as ClsCustomerStoreSuggestionDTO,
      onCardClicked: onClick,
    );
  }
}
