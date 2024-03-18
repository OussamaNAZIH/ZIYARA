import 'package:flutter/material.dart';
import 'package:flutter_pfe/Widgets/tap_effect.dart';

class CommonButton extends StatelessWidget {
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final String? buttonText;
  final Widget? buttonTextWidget;
  final Color? textColor, backgroundColor;
  final bool? isClickable;
  final double radius;

  const CommonButton(
      {super.key,
      this.onTap,
      this.padding,
      this.buttonText ,
      this.buttonTextWidget,
      this.textColor=Colors.white,
      this.backgroundColor,
      this.isClickable = true,
      this.radius = 24});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.only(),
      child: TapEffect(
        isClickable: isClickable!,
        onClick: onTap ?? () {},
        child: SizedBox(
          height: 48,
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius),
            ),
            color: backgroundColor ?? Theme.of(context).primaryColor,
            shadowColor: Colors.black12.withOpacity(
                Theme.of(context).brightness == Brightness.dark ? 0.6 : 0.2),
            child: Center(child: buttonTextWidget ?? Text(buttonText ?? "",
            style : TextStyle(color: textColor,fontSize: 16)
            )),
          ),
        ),
      ),
    );
  }
}
