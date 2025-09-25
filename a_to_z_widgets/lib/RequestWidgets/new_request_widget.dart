import 'package:a_to_z_dto/RequestDTO/request_dto.dart';
import 'package:a_to_z_widgets/Interfaces/widget_getter.dart';
import 'package:a_to_z_widgets/RequestWidgets/new_request.dart';
import 'package:flutter/material.dart';

class WDNewRequestCard extends StatefulWidget {
  const WDNewRequestCard({
    super.key,
    required this.newRequest,
    this.onCardClicked,
  });

  final ClsNewRequest newRequest;
  final Function(ClsNewRequest?)? onCardClicked;

  @override
  State<WDNewRequestCard> createState() => _WDNewRequestCardState();
}

class _WDNewRequestCardState extends State<WDNewRequestCard> {
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
          widget.onCardClicked?.call(widget.newRequest);
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
            width: double.infinity, // Fill available width
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Request Status with colored badge
                _buildStatusBadge(),

                const SizedBox(height: 12),

                // Store Name
                Text(
                  widget.newRequest.storeName ?? 'متجر غير معروف',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: _isPressed ? Colors.blue[800]! : Colors.black87,
                    fontFamily: 'Tajawal',
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                ),

                const SizedBox(height: 8),

                // Request Date
                if (widget.newRequest.requestDate != null)
                  Text(
                    _formatDate(widget.newRequest.requestDate!),
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      fontFamily: 'Tajawal',
                    ),
                    textAlign: TextAlign.center,
                  ),

                const SizedBox(height: 12),

                // Price Information
                _buildPriceInfo(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge() {
    final status = widget.newRequest.requestStatus;
    Color statusColor;
    String statusText;

    switch (status) {
      case EnRequestStatus.ePending:
        statusColor = Colors.orange;
        statusText = 'قيد الانتظار';
        break;
      case EnRequestStatus.eCancled:
        statusColor = Colors.red;
        statusText = 'ملغية';
        break;
      case EnRequestStatus.eRejected:
        statusColor = Colors.redAccent;
        statusText = 'مرفوضة';
        break;
      case EnRequestStatus.eCompleted:
        statusColor = Colors.green;
        statusText = 'مكتملة';
        break;
      default:
        statusColor = Colors.grey;
        statusText = 'غير معروف';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: statusColor.withValues(alpha: 0.3), width: 1),
      ),
      child: Text(
        statusText,
        style: TextStyle(
          color: statusColor,
          fontWeight: FontWeight.bold,
          fontSize: 12,
          fontFamily: 'Tajawal',
        ),
      ),
    );
  }

  Widget _buildPriceInfo() {
    final totalPrice = widget.newRequest.totalPrice ?? 0;
    final discount = widget.newRequest.discounts ?? 0;
    final balanceUsed = widget.newRequest.customerbalancedUsed ?? 0;
    final finalPrice = totalPrice - discount - balanceUsed;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Total Price (always shown)
        _buildPriceRow(
          'السعر الإجمالي',
          totalPrice,
          Colors.blue,
          hasStrikeThrough: discount > 0 || balanceUsed > 0,
        ),

        // Discount (if exists)
        if (discount > 0) _buildPriceRow('الخصم', -discount, Colors.green),

        // Balance Used (if exists)
        if (balanceUsed > 0)
          _buildPriceRow('الرصيد المستخدم', -balanceUsed, Colors.orange),

        // Final Price (if there are discounts or balance used)
        if (discount > 0 || balanceUsed > 0)
          Container(
            margin: const EdgeInsets.only(top: 8),
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.green[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.green[200]!),
            ),
            child: _buildPriceRow(
              'المبلغ النهائي',
              finalPrice,
              Colors.green[800]!,
              isBold: true,
            ),
          ),
      ],
    );
  }

  Widget _buildPriceRow(
    String title,
    double amount,
    Color color, {
    bool hasStrikeThrough = false,
    bool isBold = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Price value and unit on the LEFT side
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                amount.toStringAsFixed(2),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                  color: color,
                  fontFamily: 'Tajawal',
                  decoration:
                      hasStrikeThrough
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                  decorationColor: Colors.grey,
                  decorationThickness: 2,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                'ليرة سورية',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                  color: color,
                  fontFamily: 'Tajawal',
                  decoration:
                      hasStrikeThrough
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                  decorationColor: Colors.grey,
                  decorationThickness: 2,
                ),
              ),
            ],
          ),

          // Title text on the RIGHT side
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
              fontFamily: 'Tajawal',
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} - ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}

class GetNewRequestWidget implements WidgetGetter {
  @override
  Widget getWidget(Object value, Function(Object?)? onClick) {
    return WDNewRequestCard(
      newRequest: value as ClsNewRequest,
      onCardClicked: onClick,
    );
  }
}
