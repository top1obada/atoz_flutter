import 'package:a_to_z_ui/CustomerMainMenuUI/customer_main_menu_ui.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BottomLineMainMenu extends StatelessWidget {
  const BottomLineMainMenu({super.key});

  @override
  Widget build(BuildContext context) {
    PVMainMenuUiPagesProvider mainMenuUiPagesProvider =
        context.watch<PVMainMenuUiPagesProvider>();
    EnMainMenuPages currentPage = mainMenuUiPagesProvider.page;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.blueGrey.withValues(alpha: 0.15),
            blurRadius: 12,
            spreadRadius: 1,
            offset: const Offset(0, -4),
          ),
        ],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // زر الرئيسية
          _buildNavItem(
            icon: Icons.home,
            label: 'الرئيسية',
            isActive: currentPage == EnMainMenuPages.eCustomerStoresSuggestions,
            activeColor: Colors.blue,
            onPressed: () {
              mainMenuUiPagesProvider.changePage(
                EnMainMenuPages.eCustomerStoresSuggestions,
              );
            },
          ),

          // زر البحث
          _buildNavItem(
            icon: Icons.search,
            label: 'بحث',
            isActive: currentPage == EnMainMenuPages.eSearchCustomerStores,
            activeColor: Colors.blue,
            onPressed: () {
              mainMenuUiPagesProvider.changePage(
                EnMainMenuPages.eSearchCustomerStores,
              );
            },
          ),

          // زر المفضلة
          _buildNavItem(
            icon: Icons.favorite_border,
            label: 'المفضلة',
            isActive: currentPage == EnMainMenuPages.eCustomerFavoriteStores,
            activeColor: Colors.pink,
            onPressed: () {
              mainMenuUiPagesProvider.changePage(
                EnMainMenuPages.eCustomerFavoriteStores,
              );
            },
          ),

          // زر الرائجة
          _buildNavItem(
            icon: Icons.whatshot,
            label: 'الرائجة',
            isActive: currentPage == EnMainMenuPages.eCustomerFamousStores,
            activeColor: Colors.blue,
            onPressed: () {
              mainMenuUiPagesProvider.changePage(
                EnMainMenuPages.eCustomerFamousStores,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required bool isActive,
    required Color activeColor,
    required VoidCallback onPressed,
  }) {
    // Define shade colors manually since regular Color doesn't have shade getters
    final Color shade50 =
        isActive ? _getShadeColor(activeColor, 50) : Colors.transparent;
    final Color shade100 = _getShadeColor(activeColor, 100);
    final Color shade700 = _getShadeColor(activeColor, 700);
    final Color grey500 = Colors.grey.shade500;
    final Color grey600 = Colors.grey.shade600;

    return GestureDetector(
      onTap: onPressed,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Animated icon container
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: isActive ? shade50 : Colors.transparent,
              shape: BoxShape.circle,
              border: isActive ? Border.all(color: shade100, width: 2) : null,
            ),
            child: Icon(icon, color: isActive ? shade700 : grey500, size: 26),
          ),

          const SizedBox(height: 6),

          // Text with smooth animation
          AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 200),
            style: TextStyle(
              fontSize: 12,
              fontFamily: 'Tajawal',
              color: isActive ? shade700 : grey600,
              fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
              height: 1.2,
            ),
            child: Text(label, textAlign: TextAlign.center),
          ),
        ],
      ),
    );
  }

  // Helper function to approximate shade colors
  Color _getShadeColor(Color baseColor, int shadeValue) {
    // For MaterialColors like Colors.blue, Colors.pink, etc.
    if (baseColor is MaterialColor || baseColor is MaterialAccentColor) {
      // If it's already a MaterialColor, we can use the shade getters
      final materialColor = baseColor as dynamic;
      return materialColor[shadeValue] ?? baseColor;
    }

    // For regular Colors, create approximate shades
    final hsl = HSLColor.fromColor(baseColor);

    switch (shadeValue) {
      case 50:
        return hsl.withLightness(0.95).toColor();
      case 100:
        return hsl.withLightness(0.9).toColor();
      case 200:
        return hsl.withLightness(0.8).toColor();
      case 300:
        return hsl.withLightness(0.7).toColor();
      case 400:
        return hsl.withLightness(0.6).toColor();
      case 500:
        return hsl.withLightness(0.5).toColor();
      case 600:
        return hsl.withLightness(0.4).toColor();
      case 700:
        return hsl.withLightness(0.3).toColor();
      case 800:
        return hsl.withLightness(0.2).toColor();
      case 900:
        return hsl.withLightness(0.1).toColor();
      default:
        return baseColor;
    }
  }
}
