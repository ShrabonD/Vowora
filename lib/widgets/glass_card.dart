import 'dart:ui';
import 'package:flutter/material.dart';
import '../core/theme/vowora_theme.dart';

class GlassCard extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final Color backgroundColor;
  final Color borderColor;
  final double blurSigma;

  const GlassCard({
    super.key,
    required this.child,
    this.borderRadius = 28.0,
    this.padding = const EdgeInsets.all(24.0),
    this.margin,
    this.backgroundColor = VoworaColors.darkGlassBackground,
    this.borderColor = VoworaColors.darkGlassBorder,
    this.blurSigma = 16.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(borderRadius),
              border: Border.all(
                color: borderColor,
                width: 1.0,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.25),
                  blurRadius: 30,
                  spreadRadius: -5,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
