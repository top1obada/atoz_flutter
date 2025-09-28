import 'dart:async';

import 'package:a_to_z_providers/BasesProviders/base_current_login_info_provider.dart';
import 'package:a_to_z_providers/StoreProviders/customer_famous_stores_provider.dart';
import 'package:a_to_z_providers/StoreProviders/customer_favorite_stores_provider.dart';
import 'package:a_to_z_providers/StoreProviders/customer_privious_requests_stores_provider.dart';
import 'package:a_to_z_providers/StoreProviders/customer_stores_suggestions_provider.dart';
import 'package:a_to_z_providers/StoreTypeProviders/stores_types_with_colors_provider.dart';
import 'package:a_to_z_ui/CustomerMainMenuUI/bottom_line_main_menu.dart';
import 'package:a_to_z_ui/CustomerMainMenuUI/customer_favorite_stores_ui.dart';
import 'package:a_to_z_ui/CustomerMainMenuUI/search_customer_stores_ui.dart';
import 'package:flutter/material.dart';
import 'dart:math';

import 'package:a_to_z_ui/WidgetsUI/base_Scaffold.dart';

import 'package:a_to_z_ui/CustomerMainMenuUI/customer_stores_suggestions_ui.dart';
import 'package:provider/provider.dart';
import 'package:a_to_z_ui/CustomerMainMenuUI/customer_famous_stores_ui.dart';
import 'package:a_to_z_providers/StoreProviders/customer_searching_stores_provider.dart';

class PVRotations extends ChangeNotifier {
  bool _isRotating = false;

  bool get isRotating => _isRotating;

  set isRotating(bool value) {
    if (_isRotating != value) {
      _isRotating = value;
      notifyListeners();
    }
  }
}

enum EnMainMenuPages {
  eCustomerStoresSuggestions(1),
  eSearchCustomerStores(2),
  eCustomerFavoriteStores(3),
  eCustomerFamousStores(4);

  final int value;

  const EnMainMenuPages(this.value);

  @override
  String toString() {
    return name.substring(1, name.length);
  }

  static EnMainMenuPages? fromValue(int? value) {
    if (value == null) return null;
    return EnMainMenuPages.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw Exception('Unknown EnMainMenuPages value: $value'),
    );
  }
}

class PVMainMenuUiPagesProvider extends ChangeNotifier {
  EnMainMenuPages page = EnMainMenuPages.eCustomerStoresSuggestions;

  void changePage(EnMainMenuPages page) {
    this.page = page;
    notifyListeners();
  }
}

class CustomerMainMenuUi extends StatefulWidget {
  const CustomerMainMenuUi({super.key});

  @override
  State<CustomerMainMenuUi> createState() {
    return _CustomerMinMenuUi();
  }
}

class _CustomerMinMenuUi extends State<CustomerMainMenuUi>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  Timer? _pauseTimer;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2), // 2 seconds for one full rotation
    );

    // Start immediately with rotation
    _startRotation();
  }

  void _startPause() {
    final rotationsProvider = context.read<PVRotations>();
    rotationsProvider.isRotating = false;

    _pauseTimer = Timer(const Duration(seconds: 2), () {
      // Reset controller before starting new rotation
      _controller.reset();
      _startRotation();
    });
  }

  void _startRotation() {
    final rotationsProvider = context.read<PVRotations>();
    rotationsProvider.isRotating = true;

    _controller.forward().then((_) {
      // After rotation completes, pause for 2 seconds
      _startPause();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _pauseTimer?.cancel();
    super.dispose();
  }

  Widget _buildAnimatedIcon() {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        // One full rotation (0 to 2π) - only when rotating
        final double rotation =
            context.read<PVRotations>().isRotating
                ? _controller.value * 2 * pi
                : 0;
        // Gentle pulse animation only when rotating
        final scale =
            context.read<PVRotations>().isRotating
                ? 1.0 + sin(_controller.value * 2 * pi) * 0.1
                : 1.0;

        return Center(
          child: Transform.rotate(
            angle: rotation,
            child: Transform.scale(
              scale: scale,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white, // White circle
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withValues(
                        alpha: 0.5,
                      ), // Fixed: withOpacity
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    'assets/app_icon2.png',
                    width: 36,
                    height: 36,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.amber[300],
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: const Icon(
                          Icons.shopping_bag,
                          color: Colors.white,
                          size: 24,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTitleWidget() {
    return _buildAnimatedIcon();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BaseScaffold(
        titleWidget: Consumer<PVRotations>(
          builder: (context, value, child) => _buildTitleWidget(),
        ),
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Consumer<PVMainMenuUiPagesProvider>(
              builder: (context, value, child) {
                if (value.page == EnMainMenuPages.eSearchCustomerStores) {
                  return Expanded(
                    child: MultiProvider(
                      providers: [
                        ChangeNotifierProvider(
                          create: (_) => PVCustomerSearchStores(),
                        ),
                        ChangeNotifierProvider(
                          create: (_) => PVCustomerPreviousRequestsStores(),
                        ),
                        ChangeNotifierProvider.value(
                          value: context.read<PVBaseCurrentLoginInfo>(),
                        ),
                        ChangeNotifierProvider(create: (_) => PVSearch()),
                      ],
                      child: const SearchCustomerStoresUi(),
                    ),
                  );
                }
                if (value.page == EnMainMenuPages.eCustomerFavoriteStores) {
                  return Expanded(
                    child: MultiProvider(
                      providers: [
                        ChangeNotifierProvider(
                          create: (_) => PVCustomerFavoriteStores(),
                        ),
                        ChangeNotifierProvider.value(
                          value: context.read<PVBaseCurrentLoginInfo>(),
                        ),
                      ],
                      child: const CustomerFavoriteStoresUi(),
                    ),
                  );
                }

                if (value.page == EnMainMenuPages.eCustomerFamousStores) {
                  return Expanded(
                    child: MultiProvider(
                      providers: [
                        ChangeNotifierProvider(
                          create: (_) => PVCustomerFamousStores(),
                        ),
                        ChangeNotifierProvider.value(
                          value: context.read<PVBaseCurrentLoginInfo>(),
                        ),
                      ],
                      child: const CustomerFamousStoresUi(),
                    ),
                  );
                }
                return Expanded(
                  child: MultiProvider(
                    providers: [
                      ChangeNotifierProvider(
                        create: (_) => PVCustomerStoresSuggestions(),
                      ),
                      ChangeNotifierProvider.value(
                        value: context.read<PVBaseCurrentLoginInfo>(),
                      ),
                      ChangeNotifierProvider(
                        create: (_) => PVStoreTypesWithColors(),
                      ),
                    ],
                    child: const CustomerStoresSuggestionsUi(),
                  ),
                );
              },
            ),
            const BottomLineMainMenu(),
          ],
        ),
      ),
    );
  }
}
