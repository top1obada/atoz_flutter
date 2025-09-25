import 'package:a_to_z_dto/CustomerBalanceDTO/customer_balance_payment_history_dto.dart';
import 'package:a_to_z_widgets/Interfaces/widget_getter.dart';
import 'package:flutter/material.dart';

class WDCustomerBalancePaymentHistoryCard extends StatefulWidget {
  const WDCustomerBalancePaymentHistoryCard({
    super.key,
    required this.paymentHistory,
    this.onCardClicked,
  });

  final ClsCustomerBalancePaymentHistoryDTO paymentHistory;
  final Function(ClsCustomerBalancePaymentHistoryDTO?)? onCardClicked;

  @override
  State<WDCustomerBalancePaymentHistoryCard> createState() =>
      _WDCustomerBalancePaymentHistoryCardState();
}

class _WDCustomerBalancePaymentHistoryCardState
    extends State<WDCustomerBalancePaymentHistoryCard> {
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
          widget.onCardClicked?.call(widget.paymentHistory);
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

                // Request ID
                Text(
                  'طلب #${widget.paymentHistory.requestID ?? 'N/A'}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: _isPressed ? Colors.blue[800]! : Colors.black87,
                    fontFamily: 'Tajawal',
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 8),

                // Request Date
                if (widget.paymentHistory.requestDate != null)
                  Text(
                    _formatDate(widget.paymentHistory.requestDate!),
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
    final status = widget.paymentHistory.requestStatus;
    Color statusColor;
    String statusText;

    switch (status) {
      case 1: // ePending
        statusColor = Colors.orange;
        statusText = 'قيد الانتظار';
        break;
      case 2: // eCancled
        statusColor = Colors.red;
        statusText = 'ملغية';
        break;
      case 3: // eRejected
        statusColor = Colors.redAccent;
        statusText = 'مرفوضة';
        break;
      case 4: // eCompleted
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
        color: statusColor.withValues(
          alpha: 0.1,
        ), // Background with 10% opacity
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: statusColor.withValues(alpha: 0.3), // Border with 30% opacity
        ),
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
    final priceAfterDiscount = widget.paymentHistory.priceAfterDiscount ?? 0;
    final balanceUsed = widget.paymentHistory.balanceValueUsed ?? 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Price After Discount
        _buildPriceRow('السعر بعد الخصم', priceAfterDiscount, Colors.blue),

        // Balance Used
        if (balanceUsed > 0)
          _buildPriceRow('الرصيد المستخدم', -balanceUsed, Colors.orange),

        // Final Amount (if balance was used)
        if (balanceUsed > 0)
          Container(
            margin: const EdgeInsets.only(top: 8),
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.green[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.green[200]!),
            ),
            child: _buildPriceRow(
              'المبلغ المدفوغ',
              priceAfterDiscount - balanceUsed,
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
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: color,
                  fontFamily: 'Tajawal',
                ),
              ),
              const SizedBox(width: 4),
              Text(
                'ليرة سورية',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: color,
                  fontFamily: 'Tajawal',
                ),
              ),
            ],
          ),

          // Title text on the RIGHT side
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[700],
              fontFamily: 'Tajawal',
              fontWeight: FontWeight.bold,
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

class GetCustomerBalancePaymentHistoryWidget implements WidgetGetter {
  @override
  Widget getWidget(Object value, Function(Object?)? onClick) {
    return WDCustomerBalancePaymentHistoryCard(
      paymentHistory: value as ClsCustomerBalancePaymentHistoryDTO,
      onCardClicked: onClick,
    );
  }
}
