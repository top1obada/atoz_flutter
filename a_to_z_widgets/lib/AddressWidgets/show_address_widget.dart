import 'package:a_to_z_dto/AddressDTO/adress_dto.dart';
import 'package:a_to_z_widgets/Interfaces/widget_getter.dart';
import 'package:flutter/material.dart';

class WDAddressCard extends StatefulWidget {
  const WDAddressCard({super.key, required this.address, this.onCardClicked});

  final ClsAddressDTO address;
  final Function(ClsAddressDTO?)? onCardClicked;

  @override
  State<WDAddressCard> createState() => _WDAddressCardState();
}

class _WDAddressCardState extends State<WDAddressCard> {
  bool _isPressed = false;
  final Color _normalColor = Colors.white;
  final Color _pressedColor = Colors.blue[50]!;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        onTap: () {
          widget.onCardClicked?.call(widget.address);
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
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Address ID badge
                _buildAddressIDBadge(),

                const SizedBox(height: 12),

                // Main address information
                _buildAddressInfo(),

                const SizedBox(height: 12),

                // Additional notes if available
                if (widget.address.importantNotes != null &&
                    widget.address.importantNotes!.isNotEmpty)
                  _buildImportantNotes(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAddressIDBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.blue[200]!),
      ),
      child: Text(
        'العنوان #${widget.address.addressID ?? 'N/A'}',
        style: TextStyle(
          color: Colors.blue[800],
          fontWeight: FontWeight.bold,
          fontSize: 12,
          fontFamily: 'Tajawal',
        ),
      ),
    );
  }

  Widget _buildAddressInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // City and Area
        if (widget.address.city != null && widget.address.areaName != null)
          _buildInfoRow(
            'المدينة والمنطقة',
            '${widget.address.city!} - ${widget.address.areaName!}',
            Icons.location_city,
            Colors.blue[700]!,
          ),

        // Street
        if (widget.address.streetNameOrNumber != null)
          _buildInfoRow(
            'الشارع',
            widget.address.streetNameOrNumber!,
            Icons.streetview,
            Colors.green[700]!,
          ),

        // Building
        if (widget.address.buildingName != null)
          _buildInfoRow(
            'المبنى',
            widget.address.buildingName!,
            Icons.apartment,
            Colors.orange[700]!,
          ),
      ],
    );
  }

  Widget _buildInfoRow(String title, String value, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 8),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontFamily: 'Tajawal',
                  ),
                ),
                // Value
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                    fontFamily: 'Tajawal',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImportantNotes() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.amber[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.amber[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.note, size: 16, color: Colors.amber[700]),
              const SizedBox(width: 8),
              Text(
                'ملاحظات مهمة',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.amber[800],
                  fontFamily: 'Tajawal',
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            widget.address.importantNotes!,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[700],
              fontFamily: 'Tajawal',
            ),
          ),
        ],
      ),
    );
  }
}

class GetAddressWidget implements WidgetGetter {
  @override
  Widget getWidget(Object value, Function(Object?)? onClick) {
    return WDAddressCard(
      address: value as ClsAddressDTO,
      onCardClicked: onClick,
    );
  }
}
