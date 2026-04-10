import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

/// Wraps [child] and overlays an animated count badge when [count] > 0.
class CartBadge extends StatelessWidget {
  final Widget child;
  final int count;

  const CartBadge({super.key, required this.child, required this.count});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        child,
        if (count > 0)
          Positioned(
            top: -4,
            right: -4,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              transitionBuilder: (child, animation) => ScaleTransition(
                scale: CurvedAnimation(
                    parent: animation, curve: Curves.easeOutBack),
                child: child,
              ),
              child: _Badge(key: ValueKey(count), count: count),
            ),
          ),
      ],
    );
  }
}

class _Badge extends StatelessWidget {
  final int count;
  const _Badge({super.key, required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.saffron,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: AppColors.saffron.withOpacity(0.4),
            blurRadius: 6,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Text(
        count > 99 ? '99+' : '$count',
        style: GoogleFonts.montserrat(
          fontSize: 9,
          fontWeight: FontWeight.w800,
          color: Colors.white,
        ),
      ),
    );
  }
}
