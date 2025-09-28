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
  late Animation<double> _rotationAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );

    _rotationAnimation = Tween<double>(begin: 0, end: 2 * pi).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 1.0, curve: Curves.linear),
      ),
    );

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 1.1), weight: 1),
      TweenSequenceItem(tween: Tween<double>(begin: 1.1, end: 0.9), weight: 1),
      TweenSequenceItem(tween: Tween<double>(begin: 0.9, end: 1.0), weight: 1),
    ]).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 1.0, curve: Curves.easeInOut),
      ),
    );

    _bounceAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: -10.0),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: -10.0, end: 0.0),
        weight: 1,
      ),
      TweenSequenceItem(tween: Tween<double>(begin: 0.0, end: -5.0), weight: 1),
      TweenSequenceItem(tween: Tween<double>(begin: -5.0, end: 0.0), weight: 1),
    ]).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 1.0, curve: Curves.elasticOut),
      ),
    );

    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildAnimatedIcon() {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _bounceAnimation.value),
          child: Transform.scale(
            scale: _scaleAnimation.value,
            child: Transform.rotate(
              angle: _rotationAnimation.value,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      Colors.amber.shade300,
                      Colors.orange.shade400,
                      Colors.deepOrange.shade400,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.amber.withValues(alpha: 0.6),
                      blurRadius: 15,
                      spreadRadius: 2,
                      offset: const Offset(0, 4),
                    ),
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.3),
                      blurRadius: 10,
                      spreadRadius: 1,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(6),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(8),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Image.asset(
                      'assets/app_icon2.png',
                      width: 40,
                      height: 40,
                      fit: BoxFit.cover,
                    ),
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildAnimatedIcon(),
        const SizedBox(width: 12),
        ShaderMask(
          shaderCallback:
              (bounds) => LinearGradient(
                colors: [
                  Colors.amber.shade300,
                  Colors.orange.shade400,
                  Colors.deepOrange.shade400,
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ).createShader(bounds),
          child: Text(
            'A TO Z',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: [
                Shadow(
                  color: Colors.black.withValues(alpha: 0.5),
                  blurRadius: 8,
                  offset: const Offset(2, 2),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BaseScaffold(
        titleWidget: _buildTitleWidget(), // Use titleWidget instead of title
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
