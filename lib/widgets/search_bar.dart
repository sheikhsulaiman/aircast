import 'package:flutter/material.dart';
import '../config/app_colors.dart';

class SearchBar extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback onSearch;
  final VoidCallback onClose;
  final Duration animationDuration;

  const SearchBar({
    super.key,
    required this.controller,
    required this.onSearch,
    required this.onClose,
    this.animationDuration = const Duration(milliseconds: 400),
  });

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.appBackground.withAlpha(200),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.statsBackground, width: 1.5),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              InkWell(
                onTap: widget.onClose,
                child: const Icon(
                  Icons.close,
                  color: Colors.redAccent,
                  size: 24,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: widget.controller,
                  autofocus: true,
                  style: _textStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  decoration: InputDecoration(
                    hintText: 'Search city...',
                    hintStyle: _textStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textGray,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onSubmitted: (_) => widget.onSearch(),
                ),
              ),
              InkWell(
                onTap: widget.onSearch,
                child: const Icon(
                  Icons.arrow_forward,
                  color: AppColors.badgeGreen,
                  size: 24,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  TextStyle _textStyle({
    double fontSize = 16,
    FontWeight fontWeight = FontWeight.w400,
    Color color = AppColors.textBlack,
  }) {
    return TextStyle(
      fontFamily: 'SFProText',
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
    );
  }
}
