import 'package:flutter/material.dart';

/// Shared app bar used across booking flow pages.
class BookingAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? subtitle;
  final bool showShare;
  final bool showClose;

  const BookingAppBar({
    super.key,
    required this.title,
    this.subtitle,
    this.showShare = true,
    this.showClose = false,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = Theme.of(context).colorScheme;
    final bgColor = isDark ? const Color(0xFF0B0F1A) : Colors.white;

    return AppBar(
      backgroundColor: bgColor,
      elevation: 0,
      leading: IconButton(
        icon: Icon(
          showClose ? Icons.close : Icons.arrow_back,
          color: colors.onSurface,
        ),
        onPressed: () => Navigator.pop(context),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: colors.onSurface,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (subtitle != null)
            Text(
              subtitle!,
              style: TextStyle(
                color: colors.onSurface.withValues(alpha: 0.6),
                fontSize: 13,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
        ],
      ),
      titleSpacing: 0,
      actions: [
        if (showShare)
          IconButton(
            icon: Icon(Icons.share_outlined, color: colors.onSurface),
            onPressed: () {},
          ),
      ],
    );
  }
}
