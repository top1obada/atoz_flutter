import 'dart:async';

import 'package:flutter/material.dart';

class WordItem {
  final String text;
  final Color color;

  WordItem(this.text, this.color);
}

class TextSelectorLine extends StatefulWidget {
  final List<WordItem> wordItems;
  final Function(String) onWordSelected;
  final Color defaultColor;
  final Color backgroundColor;
  final double defaultFontSize;
  final double selectedFontSize;
  final bool showBackground;
  final int cooldownDuration; // Cooldown duration in milliseconds

  const TextSelectorLine({
    super.key,
    required this.wordItems,
    required this.onWordSelected,
    this.defaultColor = Colors.grey,
    this.backgroundColor = const Color(0xFFF5F5F5),
    this.defaultFontSize = 16.0,
    this.selectedFontSize = 20.0,
    this.showBackground = true,
    this.cooldownDuration = 2000, // Default 2 seconds
  });

  @override
  State<TextSelectorLine> createState() => _TextSelectorLineState();
}

class _TextSelectorLineState extends State<TextSelectorLine> {
  int _selectedIndex = -1;
  final ScrollController _scrollController = ScrollController();
  bool _isCooldown = false;
  Timer? _cooldownTimer;

  @override
  void dispose() {
    _scrollController.dispose();
    _cooldownTimer?.cancel(); // Cancel any active timer
    super.dispose();
  }

  void _startCooldown() {
    setState(() {
      _isCooldown = true;
    });

    // Cancel any existing timer
    _cooldownTimer?.cancel();

    // Start new cooldown timer
    _cooldownTimer = Timer(Duration(milliseconds: widget.cooldownDuration), () {
      setState(() {
        _isCooldown = false;
      });
    });
  }

  void _scrollToSelectedItem(int index) {
    // Calculate the position to scroll to
    final double itemWidth = 100; // Approximate width of each item
    final double screenWidth = MediaQuery.of(context).size.width;
    final double scrollPosition =
        (index * itemWidth) - (screenWidth / 2) + (itemWidth / 2);

    _scrollController.animateTo(
      scrollPosition.clamp(0.0, _scrollController.position.maxScrollExtent),
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  // Helper method to create a color with opacity
  Color _withOpacity(Color color, double opacity) {
    return color.withAlpha((color.a * opacity).round());
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
            // Cooldown indicator (optional visual feedback)
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
            // Disable entire widget during cooldown
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
                            _selectedIndex = index;
                          });
                          _scrollToSelectedItem(index);
                          widget.onWordSelected(wordItem.text);

                          // Start cooldown timer
                          _startCooldown();
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
                                    ? _withOpacity(
                                      wordItem.color,
                                      0.2,
                                    ) // Using the helper method
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
                              Text(
                                wordItem.text,
                                style: TextStyle(
                                  fontSize:
                                      isSelected
                                          ? widget.selectedFontSize
                                          : widget.defaultFontSize,
                                  color:
                                      isSelected
                                          ? wordItem.color
                                          : widget.defaultColor,
                                  fontWeight:
                                      isSelected
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                  fontFamily: 'NotoNaskhArabic',
                                ),
                              ),
                              // Cooldown indicator on the selected item
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
