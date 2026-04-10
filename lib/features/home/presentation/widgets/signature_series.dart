import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/scroll_reveal.dart';

class SignatureSeriesSection extends StatelessWidget {
  const SignatureSeriesSection({super.key});

  static const _items = [
    _SignatureItem(
      icon: Icons.local_fire_department_rounded,
      tag: 'CHEF\'S MASTERPIECE',
      name: 'Tandoori Bonfire Pizza',
      description:
          'Our legendary fusion masterpiece. Spicy tandoori chicken, fresh capsicum, and our secret bonfire sauce on a hand-stretched base.',
      price: 'AED 48',
      badge: 'Best Seller',
      spiceLevel: 2,
      color1: Color(0xFF3D1505),
      color2: Color(0xFF1A1A1A),
    ),
    _SignatureItem(
      icon: Icons.soup_kitchen_rounded,
      tag: 'TRADITIONAL RECIPE',
      name: 'Authentic Mutton Karahi',
      description:
          'Slow-cooked to perfection in traditional woks with hand-ground spices. A timeless recipe passed through generations.',
      price: 'AED 65',
      badge: 'Fan Favorite',
      spiceLevel: 3,
      color1: Color(0xFF1A0D05),
      color2: Color(0xFF2D1A0A),
    ),
    _SignatureItem(
      icon: Icons.breakfast_dining_rounded,
      tag: 'ALL DAY BREAKFAST',
      name: '24-Hour Desi Breakfast',
      description:
          'From Halwa Puri sets to spicy Egg Bhurji — authentic mornings, any time of day. Because great mornings don\'t follow a clock.',
      price: 'AED 28',
      badge: 'Available 24/7',
      spiceLevel: 1,
      color1: Color(0xFF0A1A05),
      color2: Color(0xFF151A10),
    ),
    _SignatureItem(
      icon: Icons.rice_bowl_rounded,
      tag: 'HOUSE SPECIALTY',
      name: 'Dum Biryani Royale',
      description:
          'Fragrant basmati rice layered with tender meat, saffron, and caramelized onions — slow-cooked in a sealed pot to lock in every aroma.',
      price: 'AED 52',
      badge: 'New',
      spiceLevel: 2,
      color1: Color(0xFF1A1205),
      color2: Color(0xFF1A1A1A),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final isMobile = w < 768;

    return Container(
      color: AppColors.charcoal,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(
              isMobile ? 24 : 80,
              isMobile ? 60 : 90,
              isMobile ? 24 : 80,
              0,
            ),
            child: ScrollReveal(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('SIGNATURE SERIES', style: AppTextStyles.label),
                  const SizedBox(height: 12),
                  Text(
                    isMobile ? 'Our\nSignature Dishes' : 'Our Signature Dishes',
                    style: isMobile
                        ? AppTextStyles.sectionTitleMobile
                        : AppTextStyles.sectionTitle,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Handcrafted with passion. Served with pride.',
                    style: GoogleFonts.montserrat(
                      fontSize: 15,
                      color: AppColors.warmBone.withOpacity(0.5),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 40),
          SizedBox(
            height: 380,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: isMobile ? 24 : 80),
              itemCount: _items.length,
              itemBuilder: (context, index) => Padding(
                padding: EdgeInsets.only(
                    right: index < _items.length - 1 ? 20 : 0),
                // Staggered entrance: each card slides in from the right
                child: ScrollReveal(
                  delay: Duration(milliseconds: 120 * index),
                  slideFrom: const Offset(0.08, 0),
                  child: _SignatureCard(item: _items[index]),
                ),
              ),
            ),
          ),
          SizedBox(height: isMobile ? 60 : 90),
        ],
      ),
    );
  }
}

class _SignatureCard extends StatefulWidget {
  final _SignatureItem item;
  const _SignatureCard({required this.item});

  @override
  State<_SignatureCard> createState() => _SignatureCardState();
}

class _SignatureCardState extends State<_SignatureCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        width: 300,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [item.color1, item.color2],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: _hovered
                ? AppColors.saffron.withOpacity(0.5)
                : AppColors.glassBorder,
            width: 1,
          ),
          boxShadow: _hovered
              ? [
                  BoxShadow(
                    color: AppColors.saffron.withOpacity(0.15),
                    blurRadius: 30,
                    offset: const Offset(0, 10),
                  )
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  )
                ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: AppColors.saffron.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(14),
                      border:
                          Border.all(color: AppColors.saffron.withOpacity(0.3)),
                    ),
                    child: Icon(item.icon,
                        color: AppColors.saffron, size: 28),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.saffron.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: AppColors.saffron.withOpacity(0.4)),
                    ),
                    child: Text(
                      item.badge,
                      style: GoogleFonts.montserrat(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: AppColors.saffron,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(item.tag, style: AppTextStyles.label),
              const SizedBox(height: 8),
              Text(item.name, style: AppTextStyles.cardTitle),
              const SizedBox(height: 12),
              Expanded(
                child: Text(item.description, style: AppTextStyles.cardBody),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    item.price,
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: AppColors.saffron,
                    ),
                  ),
                  Row(
                    children: List.generate(
                      3,
                      (i) => Icon(
                        Icons.local_fire_department,
                        size: 16,
                        color: i < item.spiceLevel
                            ? AppColors.saffron
                            : AppColors.warmBone.withOpacity(0.2),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SignatureItem {
  final IconData icon;
  final String tag;
  final String name;
  final String description;
  final String price;
  final String badge;
  final int spiceLevel;
  final Color color1;
  final Color color2;

  const _SignatureItem({
    required this.icon,
    required this.tag,
    required this.name,
    required this.description,
    required this.price,
    required this.badge,
    required this.spiceLevel,
    required this.color1,
    required this.color2,
  });
}
