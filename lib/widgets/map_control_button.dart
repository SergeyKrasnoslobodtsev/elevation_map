import 'package:flutter/material.dart';

class MapControlButton extends StatelessWidget {
  /// Иконка кнопки
  final IconData icon;

  /// Действие при нажатии
  final VoidCallback onTap;

  /// Размер кнопки
  final double size;

  /// Цвет иконки
  final Color? iconColor;

  /// Размер иконки
  final double iconSize;

  /// Внешние отступы
  final EdgeInsets margin;

  const MapControlButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.size = 44.0,
    this.iconColor,
    this.iconSize = 24.0,
    this.margin = EdgeInsets.zero,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      width: size,
      height: size,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: .8),
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: Icon(
              icon,
              color: iconColor ?? Colors.grey[700],
              size: iconSize,
            ),
          ),
        ),
      ),
    );
  }
}
