import 'dart:async';
import 'package:flutter/material.dart';

class WordItem {
  final String text;
  final Color color;
  final String? iconName;
  WordItem(this.text, this.color, {this.iconName});
}

class TextSelectorLine extends StatefulWidget {
  final List<WordItem> wordItems;
  final Function(String) onWordSelected;
  final Color defaultColor;
  final Color backgroundColor;
  final double defaultFontSize;
  final double selectedFontSize;
  final bool showBackground;
  final int cooldownDuration;

  const TextSelectorLine({
    super.key,
    required this.wordItems,
    required this.onWordSelected,
    this.defaultColor = Colors.grey,
    this.backgroundColor = const Color(0xFFF5F5F5),
    this.defaultFontSize = 16.0,
    this.selectedFontSize = 20.0,
    this.showBackground = true,
    this.cooldownDuration = 2000,
  });

  @override
  State<TextSelectorLine> createState() => _TextSelectorLineState();
}

class _TextSelectorLineState extends State<TextSelectorLine> {
  int _selectedIndex = -1;
  final ScrollController _scrollController = ScrollController();
  bool _isCooldown = false;
  Timer? _cooldownTimer;

  final Map<String, IconData> _iconMap = {
    'phone_iphone': Icons.phone_iphone,
    'checkroom': Icons.checkroom,
    'local_grocery_store': Icons.local_grocery_store,
    'restaurant': Icons.restaurant,
    'local_cafe': Icons.local_cafe,
    'chair': Icons.chair,
    'spa': Icons.spa,
    'sports_soccer': Icons.sports_soccer,
    'child_friendly': Icons.child_friendly,
    'menu_book': Icons.menu_book,
    'directions_car': Icons.directions_car,
    'pets': Icons.pets,
    'card_giftcard': Icons.card_giftcard,
    'kitchen': Icons.kitchen,
    'watch': Icons.watch,
    'watch_outlined': Icons.watch_outlined,
    'sports_esports': Icons.sports_esports,
    'handyman': Icons.handyman,
    'miscellaneous_services': Icons.miscellaneous_services,
    'computer': Icons.computer,
    'music_note': Icons.music_note,
    'home_repair_service': Icons.home_repair_service,
    'local_pharmacy': Icons.local_pharmacy,
  };

  @override
  void dispose() {
    _scrollController.dispose();
    _cooldownTimer?.cancel();
    super.dispose();
  }

  void _startCooldown() {
    setState(() => _isCooldown = true);
    _cooldownTimer?.cancel();
    _cooldownTimer = Timer(Duration(milliseconds: widget.cooldownDuration), () {
      setState(() => _isCooldown = false);
    });
  }

  void _scrollToSelectedItem(int index) {
    final double itemWidth = 100;
    final double screenWidth = MediaQuery.of(context).size.width;
    final double scrollPosition =
        (index * itemWidth) - (screenWidth / 2) + (itemWidth / 2);
    _scrollController.animateTo(
      scrollPosition.clamp(0.0, _scrollController.position.maxScrollExtent),
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  Widget _buildContent(WordItem wordItem, bool isSelected) {
    if (isSelected && wordItem.iconName != null) {
      return Icon(
        _iconMap[wordItem.iconName] ?? Icons.help_outline,
        size: isSelected ? widget.selectedFontSize : widget.defaultFontSize,
        color: isSelected ? wordItem.color : widget.defaultColor,
      );
    } else {
      return Text(
        wordItem.text,
        style: TextStyle(
          fontSize:
              isSelected ? widget.selectedFontSize : widget.defaultFontSize,
          color: isSelected ? wordItem.color : widget.defaultColor,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          fontFamily: 'NotoNaskhArabic',
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        decoration:
            widget.showBackground
                ? BoxDecoration(
                  color: widget.backgroundColor,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                )
                : null,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        margin: const EdgeInsets.all(8),
        child: Column(
          children: [
            if (_isCooldown && _selectedIndex != -1)
              Container(
                margin: const EdgeInsets.only(bottom: 8),
                child: LinearProgressIndicator(
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(
                    widget.wordItems[_selectedIndex].color,
                  ),
                  minHeight: 3,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            IgnorePointer(
              ignoring: _isCooldown,
              child: Opacity(
                opacity: _isCooldown ? 0.6 : 1.0,
                child: SingleChildScrollView(
                  controller: _scrollController,
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(widget.wordItems.length, (index) {
                      final isSelected = index == _selectedIndex;
                      final wordItem = widget.wordItems[index];
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            if (_selectedIndex == index) {
                              _selectedIndex = -1;
                            } else {
                              _selectedIndex = index;
                              _scrollToSelectedItem(index);
                              widget.onWordSelected(wordItem.text);
                              _startCooldown();
                            }
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            color:
                                isSelected
                                    ? wordItem.color.withOpacity(0.2)
                                    : Colors.transparent,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color:
                                  isSelected
                                      ? wordItem.color
                                      : Colors.transparent,
                              width: isSelected ? 1.5 : 1.0,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _buildContent(wordItem, isSelected),
                              if (isSelected && _isCooldown)
                                Padding(
                                  padding: const EdgeInsets.only(left: 8),
                                  child: SizedBox(
                                    width: 12,
                                    height: 12,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        wordItem.color,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
