import 'package:a_to_z_providers/BasesProviders/base_current_login_info_provider.dart';
import 'package:a_to_z_providers/RequestProviders/show_request_provider.dart';
import 'package:a_to_z_providers/CustomerBalanceProviders/customer_balance_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomerBalanceDialog extends StatefulWidget {
  final Function(double)? onBalanceSelected;

  const CustomerBalanceDialog({super.key, this.onBalanceSelected});

  @override
  State<CustomerBalanceDialog> createState() => _CustomerBalanceDialogState();
}

class _CustomerBalanceDialogState extends State<CustomerBalanceDialog> {
  final TextEditingController _balanceController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _loadCustomerBalance();
    });
  }

  Future<void> _loadCustomerBalance() async {
    await context.read<PVCustomerBalance>().getCustomerBalance(
      context.read<PVBaseCurrentLoginInfo>().retrivingLoggedInDTO!.branchID,
    );
  }

  @override
  void dispose() {
    _balanceController.dispose();
    super.dispose();
  }

  String? _validateBalance(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Empty is allowed (will be treated as 0)
    }

    final parsedValue = double.tryParse(value);
    if (parsedValue == null) {
      return 'يرجى إدخال رقم صحيح';
    }

    if (parsedValue < 0) {
      return 'يجب أن يكون الرقم أكبر من أو يساوي الصفر';
    }

    final customerBalance = context.read<PVCustomerBalance>().customerBalance;
    if (customerBalance != null && parsedValue > customerBalance) {
      return 'المبلغ المدخل أكبر من الرصيد المتاح';
    }

    return null;
  }

  void _onOkPressed() {
    if (_formKey.currentState?.validate() ?? false) {
      final enteredValue =
          _balanceController.text.isEmpty
              ? 0.0
              : double.parse(_balanceController.text);

      widget.onBalanceSelected?.call(enteredValue);

      context.read<PVShowRequest>().changeBalanceUsedValue(enteredValue);

      Navigator.of(context).pop();
    }
  }

  void _onCancelPressed() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PVCustomerBalance>(
      builder: (context, pvCustomerBalance, child) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  'استخدام رصيد العميل',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[800],
                  ),
                  textAlign: TextAlign.right,
                ),

                const SizedBox(height: 16),

                // Current Balance
                if (pvCustomerBalance.customerBalance != null)
                  Text(
                    'الرصيد المتاح: ${pvCustomerBalance.customerBalance!.toStringAsFixed(2)} ليرة سورية',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.green[700],
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.right,
                  ),

                const SizedBox(height: 20),

                // Balance Input Field
                Form(
                  key: _formKey,
                  child: TextFormField(
                    controller: _balanceController,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.right,
                    decoration: InputDecoration(
                      labelText: 'المبلغ المراد استخدامه (ليرة سورية)',
                      labelStyle: TextStyle(color: Colors.blue[700]),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.blue[300]!),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.blue[500]!),
                      ),
                      filled: true,
                      fillColor: Colors.grey[50],
                      suffixIcon: Icon(
                        Icons
                            .currency_lira, // Changed from attach_money to currency_lira
                        color: Colors.blue[700],
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                    ),
                    validator: _validateBalance,
                    onChanged: (value) {
                      setState(() {
                        _errorMessage = _validateBalance(value);
                      });
                    },
                  ),
                ),

                if (_errorMessage != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    _errorMessage!,
                    style: TextStyle(color: Colors.red[700], fontSize: 12),
                    textAlign: TextAlign.right,
                  ),
                ],

                const SizedBox(height: 24),

                // Buttons Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Cancel Button
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _onCancelPressed,
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.red[700],
                          side: BorderSide(color: Colors.red[300]!),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text(
                          'إلغاء',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 16),

                    // OK Button (always enabled)
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _onOkPressed,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[700],
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          elevation: 2,
                        ),
                        child: const Text(
                          'موافق',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                // Loading Indicator
                if (pvCustomerBalance.isLoading)
                  const Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: Center(child: CircularProgressIndicator()),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// Usage function to show the dialog
Future<void> showCustomerBalanceDialog({
  required BuildContext context,
  required Function(double) onBalanceSelected,
}) {
  return showGeneralDialog(
    context: context,
    barrierLabel: "استخدام الرصيد",
    barrierDismissible: true,
    barrierColor: Colors.black.withValues(alpha: 0.6),
    transitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (con, animation, secondaryAnimation) {
      return MultiProvider(
        providers: [
          ChangeNotifierProvider.value(
            value: context.read<PVBaseCurrentLoginInfo>(),
          ),
          ChangeNotifierProvider(create: (_) => PVCustomerBalance()),
          ChangeNotifierProvider.value(value: context.read<PVShowRequest>()),
        ],
        child: CustomerBalanceDialog(onBalanceSelected: onBalanceSelected),
      );
    },
    transitionBuilder: (con, animation, secondaryAnimation, child) {
      return ScaleTransition(
        scale: CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
        child: child,
      );
    },
  );
}
