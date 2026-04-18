import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_page_route.dart';
import '../../../../core/widgets/cart_badge.dart';
import '../../../cart/presentation/pages/cart_page.dart';
import '../../../cart/presentation/providers/cart_provider.dart';
import '../../../menu/presentation/pages/menu_page.dart';

class AppNavbar extends StatefulWidget {
  final ScrollController scrollController;
  const AppNavbar({super.key, required this.scrollController});

  @override
  State<AppNavbar> createState() => _AppNavbarState();
}

class _AppNavbarState extends State<AppNavbar> {
  bool _scrolled = false;

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final isScrolled = widget.scrollController.offset > 50;
    if (isScrolled != _scrolled) setState(() => _scrolled = isScrolled);
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_onScroll);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cart = CartProvider.of(context);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        color: _scrolled ? AppColors.charcoal.withOpacity(0.92) : Colors.transparent,
        boxShadow: _scrolled
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ]
            : [],
      ),
      child: ClipRect(
        child: Container(
          height: 72,
          padding: const EdgeInsets.symmetric(horizontal: 48),
          child: Row(
            children: [
              _buildLogo(),
              const Spacer(),
              _buildNavItems(context),
              const SizedBox(width: 32),
              // Cart icon
              GestureDetector(
                onTap: () => Navigator.push(context, SlideUpRoute(page: const CartPage())),
                child: CartBadge(
                  count: cart.totalCount,
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.darkCard,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.glassBorder),
                      ),
                      child: const Icon(
                        Icons.shopping_bag_outlined,
                        color: AppColors.warmBone,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              _buildOrderButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: AppColors.saffron,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.local_fire_department_rounded, color: Colors.white, size: 20),
        ),
        const SizedBox(width: 12),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'FAMILY',
              style: GoogleFonts.playfairDisplay(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.warmBone,
                letterSpacing: 1,
              ),
            ),
            Text(
              'RESTAURANT',
              style: GoogleFonts.montserrat(
                fontSize: 9,
                fontWeight: FontWeight.w600,
                color: AppColors.saffron,
                letterSpacing: 3,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildNavItems(BuildContext context) {
    return Row(
      children: [
        _NavLink(
          label: 'Menu',
          onTap: () => Navigator.push(context, SlideUpRoute(page: const MenuPage())),
        ),
        _NavLink(label: 'About'),
        _NavLink(label: 'Gallery'),
        _NavLink(label: 'Contact'),
      ],
    );
  }

  Widget _buildOrderButton(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => Navigator.push(context, SlideUpRoute(page: const MenuPage())),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: AppColors.saffron,
            borderRadius: BorderRadius.circular(6),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 11),
          child: Text(
            'Order Now',
            style: GoogleFonts.montserrat(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ),
    );
  }
}

class _NavLink extends StatefulWidget {
  final String label;
  final VoidCallback? onTap;
  const _NavLink({required this.label, this.onTap});

  @override
  State<_NavLink> createState() => _NavLinkState();
}

class _NavLinkState extends State<_NavLink> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 150),
            style: AppTextStyles.navItem.copyWith(
              color: _hovered ? AppColors.saffron : AppColors.warmBone.withOpacity(0.75),
            ),
            child: Text(widget.label),
          ),
        ),
      ),
    );
  }
}
