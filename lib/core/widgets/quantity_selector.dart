import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

class QuantitySelector extends StatefulWidget {
  final int quantity;
  final ValueChanged<int> onChanged;
  final int min;
  final int max;
  final bool large;

  const QuantitySelector({
    super.key,
    required this.quantity,
    required this.onChanged,
    this.min = 1,
    this.max = 20,
    this.large = false,
  });

  @override
  State<QuantitySelector> createState() => _QuantitySelectorState();
}

class _QuantitySelectorState extends State<QuantitySelector>
    with SingleTickerProviderStateMixin {
  late AnimationController _bounceCtrl;
  late Animation<double> _bounce;

  @override
  void initState() {
    super.initState();
    _bounceCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _bounce = Tween<double>(begin: 1.0, end: 1.35).animate(
      CurvedAnimation(parent: _bounceCtrl, curve: Curves.elasticOut),
    );
  }

  @override
  void dispose() {
    _bounceCtrl.dispose();
    super.dispose();
  }

  void _change(int delta) {
    final next = widget.quantity + delta;
    if (next < widget.min || next > widget.max) return;
    widget.onChanged(next);
    _bounceCtrl.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    final sz = widget.large ? 44.0 : 36.0;
    final fontSize = widget.large ? 20.0 : 16.0;
    final iconSize = widget.large ? 22.0 : 18.0;

    return Container(
      height: sz,
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(sz / 2),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _QtyButton(
            icon: Icons.remove_rounded,
            size: sz,
            iconSize: iconSize,
            enabled: widget.quantity > widget.min,
            onTap: () => _change(-1),
          ),
          AnimatedBuilder(
            animation: _bounce,
            builder: (_, child) => Transform.scale(
              scale: _bounce.value,
              child: child,
            ),
            child: SizedBox(
              width: widget.large ? 48 : 40,
              child: Text(
                '${widget.quantity}',
                textAlign: TextAlign.center,
                style: GoogleFonts.montserrat(
                  fontSize: fontSize,
                  fontWeight: FontWeight.w800,
                  color: AppColors.warmBone,
                ),
              ),
            ),
          ),
          _QtyButton(
            icon: Icons.add_rounded,
            size: sz,
            iconSize: iconSize,
            enabled: widget.quantity < widget.max,
            onTap: () => _change(1),
          ),
        ],
      ),
    );
  }
}

class _QtyButton extends StatefulWidget {
  final IconData icon;
  final double size;
  final double iconSize;
  final bool enabled;
  final VoidCallback onTap;
  const _QtyButton({
    required this.icon,
    required this.size,
    required this.iconSize,
    required this.enabled,
    required this.onTap,
  });

  @override
  State<_QtyButton> createState() => _QtyButtonState();
}

class _QtyButtonState extends State<_QtyButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 120));
    _scale = Tween<double>(begin: 1.0, end: 0.82)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        if (widget.enabled) _ctrl.forward();
      },
      onTapUp: (_) {
        _ctrl.reverse();
        if (widget.enabled) widget.onTap();
      },
      onTapCancel: () => _ctrl.reverse(),
      child: ScaleTransition(
        scale: _scale,
        child: SizedBox(
          width: widget.size,
          height: widget.size,
          child: Icon(
            widget.icon,
            size: widget.iconSize,
            color: widget.enabled
                ? AppColors.saffron
                : AppColors.warmBone.withOpacity(0.2),
          ),
        ),
      ),
    );
  }
}
