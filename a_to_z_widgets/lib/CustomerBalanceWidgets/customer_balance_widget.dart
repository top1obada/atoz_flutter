import 'package:flutter/material.dart';

class WDCustomerBalanceTopUp extends StatelessWidget {
  final double? customerBalance;
  final VoidCallback? onTap;

  const WDCustomerBalanceTopUp({
    super.key,
    required this.customerBalance,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blue[700]!, Colors.blue[900]!],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withValues(alpha: 0.3),
              spreadRadius: 2,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(color: Colors.blue[300]!, width: 1.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title in Arabic
            Text(
              'رصيد العميل',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontFamily: 'Tajawal',
              ),
            ),

            const SizedBox(height: 15),

            // Balance Amount
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  _formatBalance(customerBalance),
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    fontFamily: 'Tajawal',
                    height: 1.1, // Controls text vertical spacing :cite[6]
                  ),
                ),

                // Currency in Arabic
                Text(
                  'ليرة سورية',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.blue[100],
                    fontFamily: 'Tajawal',
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            // Top-up prompt in Arabic
            Row(
              children: [
                Icon(
                  Icons.add_circle_outline,
                  color: Colors.blue[100],
                  size: 16,
                ),
                const SizedBox(width: 6),
                Text(
                  'انقر لإضافة رصيد',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.blue[100],
                    fontFamily: 'Tajawal',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatBalance(double? balance) {
    if (balance == null) return '0.00';
    return balance.toStringAsFixed(2);
  }
}
