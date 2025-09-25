import 'package:a_to_z_dto/PersonDTO/person_info_dto.dart';
import 'package:a_to_z_widgets/Interfaces/widget_getter.dart';
import 'package:flutter/material.dart';

class WDPersonInfoCard extends StatefulWidget {
  const WDPersonInfoCard({
    super.key,
    required this.personInfo,
    this.onCardClicked,
  });

  final ClsPersonInfoDTO personInfo;
  final Function(ClsPersonInfoDTO?)? onCardClicked;

  @override
  State<WDPersonInfoCard> createState() => _WDPersonInfoCardState();
}

class _WDPersonInfoCardState extends State<WDPersonInfoCard> {
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
          widget.onCardClicked?.call(widget.personInfo);
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
                // Person Info title
                _buildPersonInfoTitle(),

                const SizedBox(height: 12),

                // Main person information
                _buildPersonInfo(),

                const SizedBox(height: 12),

                // Additional info if available
                if (widget.personInfo.birthDate != null) _buildBirthDateInfo(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPersonInfoTitle() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.purple[50],
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.purple[200]!),
      ),
      child: Text(
        'معلومات الشخص',
        style: TextStyle(
          color: Colors.purple[800],
          fontWeight: FontWeight.bold,
          fontSize: 14,
          fontFamily: 'Tajawal',
        ),
      ),
    );
  }

  Widget _buildPersonInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Name
        if (widget.personInfo.firstName != null &&
            widget.personInfo.lastName != null)
          _buildInfoRow(
            'الاسم الكامل',
            '${widget.personInfo.firstName!} ${widget.personInfo.lastName!}',
            Icons.person,
            Colors.purple[700]!,
          ),

        // Gender
        if (widget.personInfo.gender != null)
          _buildInfoRow(
            'الجنس',
            widget.personInfo.gender!,
            Icons.face,
            Colors.blue[700]!,
          ),

        // Country
        if (widget.personInfo.countryName != null)
          _buildInfoRow(
            'الجنسية',
            widget.personInfo.countryName!,
            Icons.flag,
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

  Widget _buildBirthDateInfo() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.orange[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.cake, size: 16, color: Colors.orange[700]),
              const SizedBox(width: 8),
              Text(
                'تاريخ الميلاد',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange[800],
                  fontFamily: 'Tajawal',
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            _formatDate(widget.personInfo.birthDate!),
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

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

class GetPersonInfoWidget implements WidgetGetter {
  @override
  Widget getWidget(Object value, Function(Object?)? onClick) {
    return WDPersonInfoCard(
      personInfo: value as ClsPersonInfoDTO,
      onCardClicked: onClick,
    );
  }
}
