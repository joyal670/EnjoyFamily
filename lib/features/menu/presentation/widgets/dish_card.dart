import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/dish.dart';
import '../../../cart/presentation/providers/cart_provider.dart';

class DishCard extends StatefulWidget {
  final Dish dish;
  final VoidCallback onTap;
  final bool compact;

  const DishCard({
    super.key,
    required this.dish,
    required this.onTap,
    this.compact = false,
  });

  @override
  State<DishCard> createState() => _DishCardState();
}

class _DishCardState extends State<DishCard>
    with SingleTickerProviderStateMixin {
  bool _hovered = false;
  late AnimationController _pressCtrl;
  late Animation<double> _pressScale;

  @override
  void initState() {
    super.initState();
    _pressCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    );
    _pressScale = Tween<double>(begin: 1.0, end: 0.96)
        .animate(CurvedAnimation(parent: _pressCtrl, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _pressCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dish = widget.dish;
    final cart = CartProvider.of(context);
    final inCart = cart.quantityOf(dish.id) > 0;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTapDown: (_) => _pressCtrl.forward(),
        onTapUp: (_) {
          _pressCtrl.reverse();
          widget.onTap();
        },
        onTapCancel: () => _pressCtrl.reverse(),
        child: ScaleTransition(
          scale: _pressScale,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: dish.gradientColors,
              ),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: _hovered
                    ? AppColors.saffron.withOpacity(0.6)
                    : Colors.white.withOpacity(0.08),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: _hovered
                      ? dish.gradientColors[0].withOpacity(0.5)
                      : Colors.black.withOpacity(0.25),
                  blurRadius: _hovered ? 28 : 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: widget.compact
                ? _buildCompact(dish, inCart)
                : _buildFull(dish, inCart),
          ),
        ),
      ),
    );
  }

  Widget _buildFull(Dish dish, bool inCart) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon circle
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(dish.icon, color: Colors.white, size: 28),
          ),
          const Spacer(),
          // Badges
          Row(
            children: [
              if (dish.spiceLevel > 0)
                _Badge(
                  icon: Icons.local_fire_department,
                  color: Colors.redAccent,
                  label: '🌶 ' * dish.spiceLevel,
                ),
              if (dish.isVeg)
                _Badge(
                  icon: Icons.eco_rounded,
                  color: Colors.green,
                  label: 'Veg',
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            dish.name,
            style: GoogleFonts.playfairDisplay(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              height: 1.2,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            dish.description,
            style: GoogleFonts.montserrat(
              fontSize: 11,
              color: Colors.white.withOpacity(0.65),
              height: 1.4,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                dish.priceLabel,
                style: GoogleFonts.playfairDisplay(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.saffron,
                ),
              ),
              _AddButton(dish: dish, inCart: inCart),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCompact(Dish dish, bool inCart) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(dish.icon, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  dish.name,
                  style: GoogleFonts.montserrat(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  dish.priceLabel,
                  style: GoogleFonts.montserrat(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.saffron,
                  ),
                ),
              ],
            ),
          ),
          _AddButton(dish: dish, inCart: inCart),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  const _Badge({required this.icon, required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 4),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 10, color: color),
          const SizedBox(width: 3),
          Text(
            label,
            style: GoogleFonts.montserrat(
              fontSize: 9,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _AddButton extends StatefulWidget {
  final Dish dish;
  final bool inCart;
  const _AddButton({required this.dish, required this.inCart});

  @override
  State<_AddButton> createState() => _AddButtonState();
}

class _AddButtonState extends State<_AddButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 130));
    _scale = Tween<double>(begin: 1.0, end: 0.85)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cart = CartProvider.of(context);
    final inCart = cart.quantityOf(widget.dish.id) > 0;

    return GestureDetector(
      onTapDown: (_) => _ctrl.forward(),
      onTapUp: (_) {
        _ctrl.reverse();
        cart.add(widget.dish);
      },
      onTapCancel: () => _ctrl.reverse(),
      child: ScaleTransition(
        scale: _scale,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: inCart ? AppColors.saffron : Colors.white.withOpacity(0.15),
            shape: BoxShape.circle,
            border: Border.all(
              color: inCart
                  ? AppColors.saffron
                  : Colors.white.withOpacity(0.3),
            ),
          ),
          child: Icon(
            inCart ? Icons.check_rounded : Icons.add_rounded,
            color: Colors.white,
            size: 18,
          ),
        ),
      ),
    );
  }
}
