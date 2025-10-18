import 'package:flutter/material.dart';
import '../design/xfarm_theme.dart';

class XFarmCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final List<BoxShadow>? shadows;
  final BorderRadius? borderRadius;
  final Gradient? gradient;

  const XFarmCard({
    Key? key,
    required this.child,
    this.padding,
    this.onTap,
    this.backgroundColor,
    this.shadows,
    this.borderRadius,
    this.gradient,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: gradient == null ? (backgroundColor ?? XFarmTheme.cardBackground) : null,
        gradient: gradient,
        borderRadius: borderRadius ?? BorderRadius.circular(XFarmTheme.radiusMedium),
        boxShadow: shadows ?? XFarmTheme.farmCardShadow,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: borderRadius ?? BorderRadius.circular(XFarmTheme.radiusMedium),
          child: Padding(
            padding: padding ?? const EdgeInsets.all(XFarmTheme.spacingMedium),
            child: child,
          ),
        ),
      ),
    );
  }
}

class XFarmStatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color? iconColor;
  final Color? backgroundColor;
  final String? subtitle;
  final VoidCallback? onTap;
  final bool showTrend;
  final double? trendValue;

  const XFarmStatCard({
    Key? key,
    required this.title,
    required this.value,
    required this.icon,
    this.iconColor,
    this.backgroundColor,
    this.subtitle,
    this.onTap,
    this.showTrend = false,
    this.trendValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return XFarmCard(
      onTap: onTap,
      backgroundColor: backgroundColor,
      shadows: XFarmTheme.farmCardShadow,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(XFarmTheme.spacingSmall),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      (iconColor ?? XFarmTheme.primaryGreen).withValues(alpha: 0.1),
                      (iconColor ?? XFarmTheme.primaryGreen).withValues(alpha: 0.05),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(XFarmTheme.radiusSmall),
                ),
                child: Icon(
                  icon,
                  size: 32,
                  color: iconColor ?? XFarmTheme.primaryGreen,
                ),
              ),
              const Spacer(),
              if (showTrend && trendValue != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: XFarmTheme.spacingSmall,
                    vertical: XFarmTheme.spacingTiny,
                  ),
                  decoration: BoxDecoration(
                    color: trendValue! > 0 
                        ? XFarmTheme.healthyGreen.withValues(alpha: 0.1)
                        : XFarmTheme.criticalRed.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(XFarmTheme.radiusSmall),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        trendValue! > 0 ? Icons.arrow_upward : Icons.arrow_downward,
                        size: 16,
                        color: trendValue! > 0 ? XFarmTheme.healthyGreen : XFarmTheme.criticalRed,
                      ),
                      Text(
                        '${trendValue!.abs().toStringAsFixed(1)}%',
                        style: XFarmTheme.farmBodySmall.copyWith(
                          color: trendValue! > 0 ? XFarmTheme.healthyGreen : XFarmTheme.criticalRed,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              if (onTap != null)
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: XFarmTheme.secondaryText,
                ),
            ],
          ),
          const SizedBox(height: XFarmTheme.spacingMedium),
          Text(
            value,
            style: XFarmTheme.farmHeadingLarge.copyWith(
              color: iconColor ?? XFarmTheme.primaryGreen,
              fontWeight: FontWeight.w700,
              fontSize: 28,
            ),
          ),
          const SizedBox(height: XFarmTheme.spacingTiny),
          Text(
            title,
            style: XFarmTheme.farmLabelMedium.copyWith(
              color: XFarmTheme.secondaryText,
              fontWeight: FontWeight.w500,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: XFarmTheme.spacingTiny),
            Text(
              subtitle!,
              style: XFarmTheme.farmBodySmall.copyWith(
                color: XFarmTheme.hintText,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class XFarmAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? subtitle;
  final List<Widget>? actions;
  final Widget? leading;
  final bool automaticallyImplyLeading;
  final Color? backgroundColor;
  final Gradient? gradient;
  final double elevation;

  const XFarmAppBar({
    Key? key,
    required this.title,
    this.subtitle,
    this.actions,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.backgroundColor,
    this.gradient,
    this.elevation = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: gradient ?? XFarmTheme.farmGradient,
        color: backgroundColor,
      ),
      child: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: XFarmTheme.lightText.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(XFarmTheme.radiusSmall),
                  ),
                  child: Icon(
                    XFarmIcons.farm,
                    color: XFarmTheme.lightText,
                    size: 24,
                  ),
                ),
                const SizedBox(width: XFarmTheme.spacingMedium),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: XFarmTheme.farmHeadingMedium.copyWith(
                          color: XFarmTheme.lightText,
                          fontWeight: FontWeight.w700,
                          fontSize: 22,
                        ),
                      ),
                      if (subtitle != null)
                        Text(
                          subtitle!,
                          style: XFarmTheme.farmBodySmall.copyWith(
                            color: XFarmTheme.lightText.withValues(alpha: 0.8),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        backgroundColor: Colors.transparent,
        elevation: elevation,
        leading: leading,
        automaticallyImplyLeading: automaticallyImplyLeading,
        actions: actions,
        iconTheme: const IconThemeData(color: XFarmTheme.lightText),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class XFarmButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final XFarmButtonType type;
  final XFarmButtonSize size;
  final bool isLoading;
  final bool isFullWidth;

  const XFarmButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.icon,
    this.type = XFarmButtonType.primary,
    this.size = XFarmButtonSize.medium,
    this.isLoading = false,
    this.isFullWidth = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final buttonHeight = 44.0; // Default medium height
    final fontSize = 14.0; // Default medium font size

    Widget buttonChild = isLoading
        ? SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(XFarmTheme.lightText),
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 24),
                const SizedBox(width: 8),
              ],
              Text(
                text,
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          );

    Widget button;
    if (type == XFarmButtonType.primary) {
      button = ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: XFarmTheme.primaryGreen,
          foregroundColor: XFarmTheme.lightText,
          minimumSize: Size(0, buttonHeight),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(XFarmTheme.radiusSmall),
          ),
        ),
        child: buttonChild,
      );
    } else if (type == XFarmButtonType.secondary) {
      button = OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: XFarmTheme.primaryGreen,
          side: const BorderSide(color: XFarmTheme.primaryGreen),
          minimumSize: Size(0, buttonHeight),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(XFarmTheme.radiusSmall),
          ),
        ),
        child: buttonChild,
      );
    } else {
      button = TextButton(
        onPressed: isLoading ? null : onPressed,
        style: TextButton.styleFrom(
          foregroundColor: XFarmTheme.primaryGreen,
          minimumSize: Size(0, buttonHeight),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(XFarmTheme.radiusSmall),
          ),
        ),
        child: buttonChild,
      );
    }

    return isFullWidth
        ? SizedBox(width: double.infinity, child: button)
        : button;
  }
}

enum XFarmButtonType { primary, secondary, text }
enum XFarmButtonSize { small, medium, large }

class XFarmTextField extends StatelessWidget {
  final String? label;
  final String? hint;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final bool obscureText;
  final TextInputType? keyboardType;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final int? maxLines;
  final bool readOnly;
  final VoidCallback? onTap;
  final Function(String)? onChanged;

  const XFarmTextField({
    Key? key,
    this.label,
    this.hint,
    this.controller,
    this.validator,
    this.obscureText = false,
    this.keyboardType,
    this.prefixIcon,
    this.suffixIcon,
    this.maxLines = 1,
    this.readOnly = false,
    this.onTap,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: XFarmTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
        ],
        TextFormField(
          controller: controller,
          validator: validator,
          obscureText: obscureText,
          keyboardType: keyboardType,
          maxLines: maxLines,
          readOnly: readOnly,
          onTap: onTap,
          onChanged: onChanged,
          style: const TextStyle(
            fontSize: 16,
            color: XFarmTheme.textPrimary,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
              fontSize: 16,
              color: XFarmTheme.textSecondary,
            ),
            prefixIcon: prefixIcon != null
                ? Icon(prefixIcon, color: XFarmTheme.textSecondary)
                : null,
            suffixIcon: suffixIcon,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(XFarmTheme.radiusSmall),
              borderSide: const BorderSide(color: XFarmTheme.borderColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(XFarmTheme.radiusSmall),
              borderSide: const BorderSide(color: XFarmTheme.borderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(XFarmTheme.radiusSmall),
              borderSide: const BorderSide(color: XFarmTheme.primaryGreen, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(XFarmTheme.radiusSmall),
              borderSide: const BorderSide(color: Colors.red),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
        ),
      ],
    );
  }
}

class XFarmDropdown<T> extends StatelessWidget {
  final String? label;
  final String? hint;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final Function(T?)? onChanged;
  final String? Function(T?)? validator;
  final IconData? prefixIcon;

  const XFarmDropdown({
    Key? key,
    this.label,
    this.hint,
    this.value,
    required this.items,
    this.onChanged,
    this.validator,
    this.prefixIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: XFarmTheme.labelLarge,
          ),
          const SizedBox(height: XFarmTheme.spacingSmall),
        ],
        DropdownButtonFormField<T>(
          value: value,
          items: items,
          onChanged: onChanged,
          validator: validator,
          style: XFarmTheme.bodyLarge,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: XFarmTheme.bodyLarge.copyWith(
              color: XFarmTheme.textHint,
            ),
            prefixIcon: prefixIcon != null
                ? Icon(prefixIcon, color: XFarmTheme.textSecondary)
                : null,
            border: const OutlineInputBorder(
              borderRadius: XFarmTheme.borderRadiusSmall,
              borderSide: BorderSide(color: XFarmTheme.borderLight),
            ),
            enabledBorder: const OutlineInputBorder(
              borderRadius: XFarmTheme.borderRadiusSmall,
              borderSide: BorderSide(color: XFarmTheme.borderLight),
            ),
            focusedBorder: const OutlineInputBorder(
              borderRadius: XFarmTheme.borderRadiusSmall,
              borderSide: BorderSide(color: XFarmTheme.primaryGreen, width: 2),
            ),
            errorBorder: const OutlineInputBorder(
              borderRadius: XFarmTheme.borderRadiusSmall,
              borderSide: BorderSide(color: XFarmTheme.errorRed),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: XFarmTheme.spacingMedium,
              vertical: XFarmTheme.spacingMedium,
            ),
          ),
        ),
      ],
    );
  }
}

class XFarmListTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData? leading;
  final Widget? trailing;
  final VoidCallback? onTap;
  final Color? leadingColor;

  const XFarmListTile({
    Key? key,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onTap,
    this.leadingColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: leading != null
          ? Container(
              padding: const EdgeInsets.all(XFarmTheme.spacingSmall),
              decoration: BoxDecoration(
                color: (leadingColor ?? XFarmTheme.primaryGreen).withValues(alpha: 0.1),
                borderRadius: XFarmTheme.borderRadiusSmall,
              ),
              child: Icon(
                leading,
                color: leadingColor ?? XFarmTheme.primaryGreen,
                size: XFarmTheme.iconMedium,
              ),
            )
          : null,
      title: Text(
        title,
        style: XFarmTheme.bodyLarge.copyWith(
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              style: XFarmTheme.bodyMedium.copyWith(
                color: XFarmTheme.textSecondary,
              ),
            )
          : null,
      trailing: trailing ??
          (onTap != null
              ? const Icon(
                  Icons.arrow_forward_ios,
                  size: XFarmTheme.iconSmall,
                  color: XFarmTheme.textSecondary,
                )
              : null),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: XFarmTheme.spacingMedium,
        vertical: XFarmTheme.spacingSmall,
      ),
    );
  }
}