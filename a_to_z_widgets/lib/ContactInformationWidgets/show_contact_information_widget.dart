import 'package:a_to_z_dto/ContactInformationDTO/contact_information_dto.dart';
import 'package:a_to_z_widgets/Interfaces/widget_getter.dart';
import 'package:flutter/material.dart';

class WDContactInfoCard extends StatefulWidget {
  const WDContactInfoCard({
    super.key,
    required this.contactInfo,
    this.onCardClicked,
  });

  final ClsContactInformationDTO contactInfo;
  final Function(ClsContactInformationDTO?)? onCardClicked;

  @override
  State<WDContactInfoCard> createState() => _WDContactInfoCardState();
}

class _WDContactInfoCardState extends State<WDContactInfoCard> {
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
          widget.onCardClicked?.call(widget.contactInfo);
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
                // Contact Info ID badge
                _buildContactIDBadge(),

                const SizedBox(height: 12),

                // Main contact information
                _buildContactInfo(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContactIDBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.teal[50],
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.teal[200]!),
      ),
      child: Text(
        'معلومات الاتصال #${widget.contactInfo.contactInformationId ?? 'N/A'}',
        style: TextStyle(
          color: Colors.teal[800],
          fontWeight: FontWeight.bold,
          fontSize: 12,
          fontFamily: 'Tajawal',
        ),
      ),
    );
  }

  Widget _buildContactInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Email
        if (widget.contactInfo.email != null)
          _buildInfoRow(
            'البريد الإلكتروني',
            widget.contactInfo.email!,
            Icons.email,
            Colors.red[700]!,
          ),

        // Phone Number
        if (widget.contactInfo.phoneNumber != null)
          _buildInfoRow(
            'رقم الهاتف',
            widget.contactInfo.phoneNumber!,
            Icons.phone,
            Colors.green[700]!,
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
}

class GetContactInfoWidget implements WidgetGetter {
  @override
  Widget getWidget(Object value, Function(Object?)? onClick) {
    return WDContactInfoCard(
      contactInfo: value as ClsContactInformationDTO,
      onCardClicked: onClick,
    );
  }
}
