import 'package:audio_player/src/constants/color_constants.dart';
import 'package:flutter/material.dart';

///PlayerButton - Display Button with circular background along with [IconData]
class PlayerButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final double? iconSize;
  final Color? backgroundColor;
  final Color? iconColor;

  const PlayerButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.iconSize,
    this.backgroundColor,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: backgroundColor ?? ColorConstants.blue,
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [
              ColorConstants.primary,
              ColorConstants.blue,
            ],
            begin: const FractionalOffset(0.0, 1.0),
            end: const FractionalOffset(1.0, 0.0),
            stops: [0.0, 1.0],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(
            icon,
            size: iconSize ?? 28,
            color: iconColor ?? ColorConstants.white,
          ),
        ),
      ),
    );
  }
}
