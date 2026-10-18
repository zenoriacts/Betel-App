import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

class GradientText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final Gradient gradient;
  const GradientText(
    this.text, {
    super.key,
    this.style,
    this.gradient = AppColors.accentGradient,
  });
  @override
  Widget build(BuildContext context) => ShaderMask(
    blendMode: BlendMode.srcIn,
    shaderCallback: (b) => gradient.createShader(b),
    child: Text(text, style: style),
  );
}

class GlowCard extends StatelessWidget {
  final Widget child;
  final Color glowColor;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  const GlowCard({
    super.key,
    required this.child,
    this.glowColor = AppColors.accent,
    this.borderRadius = 16,
    this.padding,
  });
  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(borderRadius),
      color: Theme.of(context).colorScheme.surface,
      border: Border.all(
        color: Theme.of(context).colorScheme.outlineVariant,
        width: 0.5,
      ),
      boxShadow: [
        BoxShadow(
          color: glowColor.withOpacity(0.08),
          blurRadius: 20,
          spreadRadius: 2,
        ),
      ],
    ),
    padding: padding ?? const EdgeInsets.all(16),
    child: child,
  );
}

class FeatureInputField extends StatefulWidget {
  final String featureName, displayName, unit, icon, description;
  final double minValue, maxValue, currentValue;
  final ValueChanged<double> onChanged;
  final String? errorText;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onRawChanged;

  const FeatureInputField({
    super.key,
    required this.featureName,
    required this.displayName,
    required this.unit,
    required this.icon,
    required this.description,
    required this.minValue,
    required this.maxValue,
    required this.currentValue,
    required this.onChanged,
    this.errorText,
    this.validator,
    this.onRawChanged,
  });

  @override
  State<FeatureInputField> createState() => _FeatureInputFieldState();
}

class _FeatureInputFieldState extends State<FeatureInputField> {
  late TextEditingController _ctrl;
  bool _editing = false;
  String? _inlineError;

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController(text: widget.currentValue.toStringAsFixed(1));
  }

  @override
  void didUpdateWidget(FeatureInputField old) {
    super.didUpdateWidget(old);
    if (!_editing && old.currentValue != widget.currentValue) {
      _ctrl.text = widget.currentValue.toStringAsFixed(1);
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _onTextChange(String v) {
    widget.onRawChanged?.call(v);
    if (widget.validator != null) {
      final err = widget.validator!(v);
      setState(() {
        _inlineError = err;
      });
    }
    final parsed = double.tryParse(v);
    if (parsed != null) {
      widget.onChanged(parsed);
    }
  }

  @override
  Widget build(BuildContext context) {
    final double safeVal = widget.currentValue.clamp(
      widget.minValue,
      widget.maxValue,
    );
    final double progress =
        (safeVal - widget.minValue) / (widget.maxValue - widget.minValue);
    final String? effectiveError = _inlineError ?? widget.errorText;
    final bool hasError = effectiveError != null;

    Color progressColor = hasError
        ? AppColors.error
        : (progress < 0.3
              ? AppColors.error
              : (progress < 0.6 ? AppColors.accent3 : AppColors.accent));

    return GlowCard(
      glowColor: hasError ? AppColors.error : progressColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(widget.icon, style: const TextStyle(fontSize: 20)),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.displayName,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      widget.description,
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 100,
                child: TextFormField(
                  controller: _ctrl,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (v) {
                    final err = widget.validator?.call(v);
                    if (err != _inlineError) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (mounted) setState(() => _inlineError = err);
                      });
                    }
                    return err;
                  },
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  onTap: () => setState(() => _editing = true),
                  onChanged: _onTextChange,
                  onFieldSubmitted: (v) {
                    setState(() => _editing = false);
                    _onTextChange(v);
                  },
                  textAlign: TextAlign.right,
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: progressColor,
                  ),
                  decoration: InputDecoration(
                    isDense: true,
                    errorStyle: const TextStyle(height: 0, fontSize: 0),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 8,
                    ),
                    suffixText: widget.unit,
                    suffixStyle: GoogleFonts.inter(
                      fontSize: 11,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: hasError
                            ? AppColors.error
                            : Theme.of(context).colorScheme.outlineVariant,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: hasError
                            ? AppColors.error
                            : Theme.of(context).colorScheme.outlineVariant,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: hasError
                            ? AppColors.error
                            : Theme.of(context).colorScheme.primary,
                        width: 1.5,
                      ),
                    ),
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.surface,
                  ),
                ),
              ),
            ],
          ),
          if (hasError)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Row(
                children: [
                  const Icon(
                    Icons.error_outline_rounded,
                    size: 14,
                    color: AppColors.error,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      effectiveError,
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: AppColors.error,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 10),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: progressColor,
              inactiveTrackColor: Theme.of(context).colorScheme.outlineVariant,
              thumbColor: progressColor,
              overlayColor: progressColor.withOpacity(0.15),
              trackHeight: 4,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7),
            ),
            child: Slider(
              value: safeVal,
              min: widget.minValue,
              max: widget.maxValue,
              onChanged: (v) {
                widget.onChanged(v);
                _ctrl.text = v.toStringAsFixed(1);
                _onTextChange(_ctrl.text);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${widget.minValue.toStringAsFixed(widget.minValue == widget.minValue.roundToDouble() ? 0 : 1)} ${widget.unit}',
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                Text(
                  '${widget.maxValue.toStringAsFixed(widget.maxValue == widget.maxValue.roundToDouble() ? 0 : 1)} ${widget.unit}',
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MetricChip extends StatelessWidget {
  final String label, value;
  final Color color;
  final String? subtitle;
  const MetricChip({
    super.key,
    required this.label,
    required this.value,
    required this.color,
    this.subtitle,
  });
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    decoration: BoxDecoration(
      color: color.withOpacity(0.08),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: color.withOpacity(0.25)),
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: GoogleFonts.jetBrainsMono(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 11,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        if (subtitle != null)
          Text(
            subtitle!,
            style: GoogleFonts.inter(
              fontSize: 10,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
      ],
    ),
  );
}

class SectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? trailing;
  const SectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.trailing,
  });
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Row(
      children: [
        Container(
          width: 3,
          height: 20,
          decoration: BoxDecoration(
            gradient: AppColors.accentGradient,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              if (subtitle != null)
                Text(
                  subtitle!,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
            ],
          ),
        ),
        if (trailing != null) trailing!,
      ],
    ),
  );
}
