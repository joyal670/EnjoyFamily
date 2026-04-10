import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../cart/presentation/providers/cart_provider.dart';
import '../../../menu/presentation/pages/menu_page.dart';
import '../../../cart/presentation/pages/cart_page.dart';
import '../../../../core/widgets/app_page_route.dart';
import '../../../../core/widgets/cart_badge.dart';

class MobileBottomNav extends StatefulWidget {
  const MobileBottomNav({super.key});

  @override
  State<MobileBottomNav> createState() => _MobileBottomNavState();
}

class _MobileBottomNavState extends State<MobileBottomNav> {
  int _selected = 0;

  void _handleTap(int index, BuildContext context) {
    setState(() => _selected = index);
    switch (index) {
      case 1: // Menu
        Navigator.push(context, SlideUpRoute(page: const MenuPage()))
            .then((_) => setState(() => _selected = 0));
        break;
      case 2: // Cart
        Navigator.push(context, SlideUpRoute(page: const CartPage()))
            .then((_) => setState(() => _selected = 0));
        break;
      case 3: // Call
        // Optionally launch phone dialer; for now just highlight
        break;
      case 4: // Location
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = CartProvider.of(context);

    final items = <_NavItem>[
      const _NavItem(icon: Icons.home_rounded, label: 'Home'),
      const _NavItem(icon: Icons.restaurant_menu_rounded, label: 'Menu'),
      _NavItem(
        icon: Icons.shopping_bag_outlined,
        label: 'Cart',
        badge: cart.totalCount,
      ),
      const _NavItem(icon: Icons.phone_rounded, label: 'Call'),
      const _NavItem(icon: Icons.location_on_rounded, label: 'Location'),
    ];

    return ClipRect(
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.charcoal.withOpacity(0.95),
          border: Border(
            top: BorderSide(color: AppColors.glassBorder),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: 62,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(items.length, (i) {
                final item = items[i];
                final selected = _selected == i;
                return GestureDetector(
                  onTap: () => _handleTap(i, context),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: selected
                          ? AppColors.saffron.withOpacity(0.12)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CartBadge(
                          count: item.badge,
                          child: Icon(
                            item.icon,
                            color: selected
                                ? AppColors.saffron
                                : AppColors.warmBone.withOpacity(0.4),
                            size: 22,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          item.label,
                          style: GoogleFonts.montserrat(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: selected
                                ? AppColors.saffron
                                : AppColors.warmBone.withOpacity(0.4),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;
  final int badge;
  const _NavItem({required this.icon, required this.label, this.badge = 0});
}
