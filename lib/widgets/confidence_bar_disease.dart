import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

/// Animated horizontal confidence bar for a single class.
class ConfidenceBar extends StatelessWidget {
  final String label;
  final double confidence; // 0.0 – 1.0
  final bool isTopPrediction;
  final int animationDelayMs;

  const ConfidenceBar({
    super.key,
    required this.label,
    required this.confidence,
    this.isTopPrediction = false,
    this.animationDelayMs = 0,
  });

  Color _barColor(BuildContext context) {
    if (isTopPrediction) {
      if (label == 'Healthy Leaf') return AppColors.success;
      if (label == 'Dried Leaf') return AppColors.warning;
      return AppColors.error;
    }
    return Theme.of(context).colorScheme.onSurfaceVariant;
  }

  @override
  Widget build(BuildContext context) {
    return Animate(
      effects: [
        FadeEffect(
          delay: Duration(milliseconds: animationDelayMs),
          duration: 300.ms,
        ),
        SlideEffect(
          delay: Duration(milliseconds: animationDelayMs),
          duration: 300.ms,
          begin: const Offset(-0.1, 0),
          end: Offset.zero,
        ),
      ],
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      if (isTopPrediction) ...[
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: _barColor(context),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                      ],
                      Expanded(
                        child: Text(
                          label,
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: isTopPrediction
                                ? FontWeight.w600
                                : FontWeight.w400,
                            color: isTopPrediction
                                ? Theme.of(context).colorScheme.onSurface
                                : Theme.of(
                                    context,
                                  ).colorScheme.onSurfaceVariant,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  '${(confidence * 100).toStringAsFixed(1)}%',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: isTopPrediction
                        ? _barColor(context)
                        : Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            LayoutBuilder(
              builder: (context, constraints) {
                return Stack(
                  children: [
                    // Background track
                    Container(
                      width: constraints.maxWidth,
                      height: 6,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.outlineVariant,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                    // Filled bar
                    TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0, end: confidence),
                      duration: Duration(milliseconds: 600 + animationDelayMs),
                      curve: Curves.easeOutCubic,
                      builder: (context, value, _) {
                        return Container(
                          width: constraints.maxWidth * value,
                          height: 6,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: isTopPrediction
                                  ? [
                                      _barColor(context),
                                      _barColor(context).withOpacity(0.6),
                                    ]
                                  : [
                                      Theme.of(
                                        context,
                                      ).colorScheme.onSurfaceVariant,
                                      Theme.of(context)
                                          .colorScheme
                                          .onSurfaceVariant
                                          .withOpacity(0.5),
                                    ],
                            ),
                            borderRadius: BorderRadius.circular(3),
                          ),
                        );
                      },
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
