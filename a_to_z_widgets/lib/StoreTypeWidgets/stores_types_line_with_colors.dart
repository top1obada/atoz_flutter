import 'package:a_to_z_dto/StoreTypeDTO/store_type_with_color_dto.dart';
import 'package:flutter/material.dart';
import 'package:my_widgets/SearchWidgets/words_line.dart';
import 'package:my_widgets/Colors/color_service.dart';

class StoresTypesLineWithColors extends StatelessWidget {
  const StoresTypesLineWithColors({
    super.key,
    required this.storesTypesWithColors,
    required this.onItemClick,
  });

  final List<ClsStoreTypeWithColorDto>? storesTypesWithColors;
  final Function(String) onItemClick;

  @override
  Widget build(BuildContext context) {
    if (storesTypesWithColors == null) {
      return const Text(
        'حدث خطأ في تحميل البيانات',
        style: TextStyle(fontSize: 16, color: Colors.red),
        textAlign: TextAlign.center,
      );
    }

    if (storesTypesWithColors!.isEmpty) {
      return const Text(
        'لا توجد أنواع متاجر متاحة',
        style: TextStyle(fontSize: 16, color: Colors.grey),
        textAlign: TextAlign.center,
      );
    }

    // Convert DTOs to WordItems and add "All" as first item
    final List<WordItem> wordItems = [
      WordItem('الكل', Colors.grey), // "All" item without icon
      ...storesTypesWithColors!.map((storeType) {
        final Color color = ColorService.parseColor(
          storeType.hexCode,
          storeType.shade,
        );
        return WordItem(
          storeType.storeTypeName ?? 'غير معروف',
          color,
          iconName: storeType.codePoint, // Pass the icon name from DTO
        );
      }),
    ];

    return TextSelectorLine(
      wordItems: wordItems,
      onWordSelected: onItemClick,
      defaultColor: Colors.grey,
      backgroundColor: Colors.white,
      defaultFontSize: 16,
      selectedFontSize: 20,
      showBackground: true,
    );
  }
}
