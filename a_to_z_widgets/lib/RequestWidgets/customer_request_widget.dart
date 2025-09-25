import 'package:a_to_z_dto/RequestDTO/customer_request_dto.dart';
import 'package:a_to_z_widgets/Interfaces/widget_getter.dart';
import 'package:flutter/material.dart';
import 'package:a_to_z_dto/RequestDTO/request_dto.dart';

class WDCustomerRequestCard extends StatefulWidget {
  const WDCustomerRequestCard({
    super.key,
    required this.customerRequestDTO,
    this.onCardClicked,
  });

  final ClsCustomerRequestDto customerRequestDTO;
  final Function(ClsCustomerRequestDto?)? onCardClicked;

  @override
  State<WDCustomerRequestCard> createState() => _WDCustomerRequestCardState();
}

class _WDCustomerRequestCardState extends State<WDCustomerRequestCard> {
  bool _isPressed = false;
  final Color _normalColor = Colors.white;
  final Color _pressedColor = Color(0xFFE3F2FD);
  final Color _shadowColor = Colors.black12;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Responsive sizing
    final bool isSmallDevice = screenWidth < 380;
    final bool isMediumDevice = screenWidth < 600;

    final double cardWidth =
        isSmallDevice
            ? screenWidth * 0.9
            : isMediumDevice
            ? screenWidth * 0.85
            : 400;

    final double cardHeight =
        isSmallDevice
            ? 220
            : isMediumDevice
            ? 240
            : 260;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        onTap: () {
          widget.onCardClicked?.call(widget.customerRequestDTO);
          setState(() => _isPressed = false);
        },
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          transform: Matrix4.identity()..scale(_isPressed ? 0.98 : 1.0),
          child: Card(
            elevation: _isPressed ? 6 : 4,
            shadowColor: _shadowColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(
                color: _isPressed ? Colors.blueAccent : Colors.grey[300]!,
                width: _isPressed ? 2.0 : 1.2,
              ),
            ),
            color: _isPressed ? _pressedColor : _normalColor,
            margin: const EdgeInsets.symmetric(vertical: 6),
            child: Container(
              width: cardWidth,
              height: cardHeight,
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Section
                  _buildHeaderSection(isSmallDevice, isMediumDevice),

                  const SizedBox(height: 12),

                  // Store Information
                  _buildStoreInfo(isSmallDevice, isMediumDevice),

                  const SizedBox(height: 12),

                  // Dates Section
                  _buildDatesSection(isSmallDevice, isMediumDevice),

                  const SizedBox(height: 12),

                  // Status Indicator
                  _buildStatusIndicator(isSmallDevice, isMediumDevice),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection(bool isSmallDevice, bool isMediumDevice) {
    final Color statusColor = _getStatusColor();
    final double fontSize =
        isSmallDevice
            ? 16
            : isMediumDevice
            ? 18
            : 20;
    final double statusFontSize =
        isSmallDevice
            ? 12
            : isMediumDevice
            ? 13
            : 14;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            'طلب #${widget.customerRequestDTO.requestID ?? 'N/A'}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: fontSize,
              color: Colors.blue[900],
              fontFamily: 'Tajawal',
              height: 1.2,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: isSmallDevice ? 10 : 12,
            vertical: isSmallDevice ? 6 : 8,
          ),
          decoration: BoxDecoration(
            color: statusColor.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: statusColor, width: 1.5),
            boxShadow: [
              BoxShadow(
                color: statusColor.withValues(alpha: 0.2),
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            _getStatusText(),
            style: TextStyle(
              fontSize: statusFontSize,
              fontWeight: FontWeight.bold,
              color: statusColor,
              fontFamily: 'Tajawal',
              letterSpacing: 0.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStoreInfo(bool isSmallDevice, bool isMediumDevice) {
    final double titleSize =
        isSmallDevice
            ? 15
            : isMediumDevice
            ? 16
            : 17;
    final double subtitleSize =
        isSmallDevice
            ? 13
            : isMediumDevice
            ? 14
            : 15;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'المتجر',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: isSmallDevice ? 12 : 13,
            color: Colors.grey[600],
            fontFamily: 'Tajawal',
          ),
        ),
        const SizedBox(height: 4),
        Text(
          widget.customerRequestDTO.storeName ?? 'متجر غير معروف',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: titleSize,
            color: Colors.blue[800],
            fontFamily: 'Tajawal',
            height: 1.3,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Text(
          widget.customerRequestDTO.storeTypeName ?? 'نوع غير معروف',
          style: TextStyle(
            fontSize: subtitleSize,
            color: Colors.green[700],
            fontFamily: 'Tajawal',
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildDatesSection(bool isSmallDevice, bool isMediumDevice) {
    final double fontSize =
        isSmallDevice
            ? 13
            : isMediumDevice
            ? 14
            : 15;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.calendar_today,
              size: isSmallDevice ? 14 : 16,
              color: Colors.blue[700],
            ),
            const SizedBox(width: 6),
            Text(
              'التاريخ: ${_formatDate(widget.customerRequestDTO.requestDate)}',
              style: TextStyle(
                fontSize: fontSize,
                color: Colors.grey[700],
                fontFamily: 'Tajawal',
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        if (widget.customerRequestDTO.completedRequestDate != null) ...[
          const SizedBox(height: 6),
          Row(
            children: [
              Icon(
                Icons.check_circle,
                size: isSmallDevice ? 14 : 16,
                color: Colors.green[600],
              ),
              const SizedBox(width: 6),
              Text(
                'الإكتمال: ${_formatDate(widget.customerRequestDTO.completedRequestDate)}',
                style: TextStyle(
                  fontSize: fontSize,
                  color: Colors.green[700],
                  fontFamily: 'Tajawal',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildStatusIndicator(bool isSmallDevice, bool isMediumDevice) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'حالة الطلب',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: isSmallDevice ? 12 : 13,
            color: Colors.grey[600],
            fontFamily: 'Tajawal',
          ),
        ),
        const SizedBox(height: 6),
        LinearProgressIndicator(
          value: _getProgressValue(),
          backgroundColor: Colors.grey[200],
          valueColor: AlwaysStoppedAnimation<Color>(_getStatusColor()),
          borderRadius: BorderRadius.circular(8),
          minHeight: isSmallDevice ? 8 : 10,
        ),
        const SizedBox(height: 4),
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            '${(_getProgressValue() * 100).toStringAsFixed(0)}%',
            style: TextStyle(
              fontSize: isSmallDevice ? 11 : 12,
              color: _getStatusColor(),
              fontFamily: 'Tajawal',
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '--/--/----';
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  Color _getStatusColor() {
    switch (widget.customerRequestDTO.requestStatus) {
      case EnRequestStatus.ePending:
        return Colors.orange[700]!;
      case EnRequestStatus.eCancled:
        return Colors.red[700]!;
      case EnRequestStatus.eRejected:
        return Colors.red[900]!;
      case EnRequestStatus.eCompleted:
        return Colors.green[700]!;
      default:
        return Colors.grey[600]!;
    }
  }

  String _getStatusText() {
    switch (widget.customerRequestDTO.requestStatus) {
      case EnRequestStatus.ePending:
        return 'قيد الانتظار';
      case EnRequestStatus.eCancled:
        return 'ملغي';
      case EnRequestStatus.eRejected:
        return 'مرفوض';
      case EnRequestStatus.eCompleted:
        return 'مكتمل';
      default:
        return 'غير معروف';
    }
  }

  double _getProgressValue() {
    switch (widget.customerRequestDTO.requestStatus) {
      case EnRequestStatus.ePending:
        return 0.3;
      case EnRequestStatus.eCancled:
        return 0.0;
      case EnRequestStatus.eRejected:
        return 0.0;
      case EnRequestStatus.eCompleted:
        return 1.0;
      default:
        return 0.0;
    }
  }
}

class GetCustomerRequestWidget implements WidgetGetter {
  @override
  Widget getWidget(Object value, Function(Object?)? onClick) {
    return WDCustomerRequestCard(
      customerRequestDTO: value as ClsCustomerRequestDto,
      onCardClicked: onClick,
    );
  }
}
