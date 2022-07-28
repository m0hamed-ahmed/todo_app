import 'package:algoriza_internship_todo/resources/color_manager.dart';
import 'package:algoriza_internship_todo/resources/values_manager.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final Color buttonColor;
  final Color borderColor;
  final Color textColor;
  final double width;
  final double height;
  final double elevation;
  final double radius;
  final IconData? icon;
  final IconData? spacerIcon;
  final Color spacerIconColor;

  const CustomButton({
    Key? key,
    required this.onPressed,
    required this.text,
    this.buttonColor = ColorManager.green,
    this.borderColor = Colors.transparent,
    this.textColor = ColorManager.white,
    this.width = double.infinity,
    this.height = 45,
    this.elevation = 1,
    this.radius = 15,
    this.icon,
    this.spacerIcon,
    this.spacerIconColor = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      minWidth: width,
      height: height,
      color: buttonColor,
      elevation: elevation,
      hoverElevation: elevation,
      focusElevation: elevation,
      highlightElevation: elevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius),
        side: BorderSide(color: borderColor)
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if(icon != null) Icon(icon, color: ColorManager.white, size: AppSize.s18),
          if(icon != null) const SizedBox(width: AppSize.s10),

          Text(text, style: TextStyle(color: textColor)),

          if(spacerIcon != null) const Spacer(),
          if(spacerIcon != null) Icon(spacerIcon, color: spacerIconColor, size: AppSize.s18),
        ],
      ),
    );
  }
}