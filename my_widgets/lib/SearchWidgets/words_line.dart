import 'dart:async';

import 'package:flutter/material.dart';

class WordItem {
  final String text;
  final Color color;
  final int? iconCodePoint; // Added iconCodePoint to WordItem

  WordItem(this.text, this.color, {this.iconCodePoint});
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

  @override
  void dispose() {
    _scrollController.dispose();
    _cooldownTimer?.cancel();
    super.dispose();
  }

  void _startCooldown() {
    setState(() {
      _isCooldown = true;
    });

    _cooldownTimer?.cancel();
    _cooldownTimer = Timer(Duration(milliseconds: widget.cooldownDuration), () {
      setState(() {
        _isCooldown = false;
      });
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

  Color _withOpacity(Color color, double opacity) {
    return color.withAlpha((color.a * opacity).round());
  }

  // Function to convert code point to icon
  IconData _codePointToIcon(
    int? codePoint, {
    IconData fallbackIcon = Icons.help_outline,
  }) {
    if (codePoint == null) return fallbackIcon;

    try {
      return IconData(codePoint, fontFamily: 'MaterialIcons');
    } catch (e) {
      print('Error converting code point $codePoint to icon: $e');
      return fallbackIcon;
    }
  }

  // Function to build the content (text or icon) based on selection state
  Widget _buildContent(WordItem wordItem, bool isSelected, bool isCooldown) {
    if (isSelected && wordItem.iconCodePoint != null) {
      // Show icon when selected and has code point
      return Icon(
        _codePointToIcon(wordItem.iconCodePoint),
        size: isSelected ? widget.selectedFontSize : widget.defaultFontSize,
        color: isSelected ? wordItem.color : widget.defaultColor,
      );
    } else {
      // Show text when not selected or no icon code point
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
            // Cooldown indicator
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

            // Main content
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
                            // If clicking the same item, toggle selection
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
                                    ? _withOpacity(wordItem.color, 0.2)
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
                              // Main content (text or icon)
                              _buildContent(wordItem, isSelected, _isCooldown),

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
