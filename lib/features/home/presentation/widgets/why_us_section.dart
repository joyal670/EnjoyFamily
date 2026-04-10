import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/scroll_reveal.dart';

class WhyUsSection extends StatelessWidget {
  const WhyUsSection({super.key});

  static const _features = [
    _Feature(
      icon: Icons.access_time_filled_rounded,
      title: '24/7 Availability',
      body:
          'Your late-night hunger or early-morning tradition, solved. We never close our kitchen — because great food has no curfew.',
      accentColor: Color(0xFF3498DB),
    ),
    _Feature(
      icon: Icons.verified_rounded,
      title: 'Unmatched Authenticity',
      body:
          'No shortcuts. Real tandoors, real spices, real flavor. Every dish is a promise of tradition, prepared by masters of Desi cuisine.',
      accentColor: Color(0xFFE67E22),
    ),
    _Feature(
      icon: Icons.delivery_dining_rounded,
      title: 'Fast & Fresh Delivery',
      body:
          'Warm meals delivered to your doorstep across Warsan and International City. From our tandoor to your table — in under 30 minutes.',
      accentColor: Color(0xFF2ECC71),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final isMobile = w < 768;

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFF9F7F2), Color(0xFFF0EDE6)],
        ),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 24 : 80,
        vertical: isMobile ? 60 : 100,
      ),
      child: Column(
        children: [
          ScrollReveal(
            child: Column(
              children: [
                Text('THE ENJOY FAMILY DIFFERENCE', style: AppTextStyles.label.copyWith(color: AppColors.saffron)),
                const SizedBox(height: 12),
                Text(
                  "Why We Are\nPersia's Favorite",
                  textAlign: TextAlign.center,
                  style: isMobile
                      ? AppTextStyles.sectionTitleMobileDark
                      : AppTextStyles.sectionTitleDark,
                ),
                const SizedBox(height: 16),
                Text(
                  'More than a restaurant — a community institution',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.montserrat(
                    fontSize: 15,
                    color: AppColors.charcoal.withOpacity(0.5),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 56),
          isMobile
              ? Column(
                  children: List.generate(_features.length, (i) => Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: ScrollReveal(
                      delay: Duration(milliseconds: 100 * i),
                      child: _FeatureCard(feature: _features[i], isMobile: true),
                    ),
                  )),
                )
              : Row(
                  children: List.generate(_features.length, (i) => Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                          right: i < _features.length - 1 ? 24 : 0),
                      child: ScrollReveal(
                        delay: Duration(milliseconds: 130 * i),
                        child: _FeatureCard(feature: _features[i], isMobile: false),
                      ),
                    ),
                  )),
                ),
        ],
      ),
    );
  }
}

class _FeatureCard extends StatefulWidget {
  final _Feature feature;
  final bool isMobile;
  const _FeatureCard({required this.feature, required this.isMobile});

  @override
  State<_FeatureCard> createState() => _FeatureCardState();
}

class _FeatureCardState extends State<_FeatureCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final f = widget.feature;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        transform: Matrix4.translationValues(0, _hovered ? -6 : 0, 0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color:
                _hovered ? f.accentColor.withOpacity(0.3) : Colors.transparent,
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: _hovered
                  ? f.accentColor.withOpacity(0.12)
                  : Colors.black.withOpacity(0.06),
              blurRadius: _hovered ? 30 : 16,
              offset: const Offset(0, 8),
            )
          ],
        ),
        padding: const EdgeInsets.all(32),
        child: widget.isMobile
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildIcon(f),
                  const SizedBox(width: 20),
                  Expanded(child: _buildText(f)),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildIcon(f),
                  const SizedBox(height: 24),
                  _buildText(f),
                ],
              ),
      ),
    );
  }

  Widget _buildIcon(_Feature f) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: f.accentColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Icon(f.icon, color: f.accentColor, size: 30),
    );
  }

  Widget _buildText(_Feature f) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          f.title,
          style: GoogleFonts.playfairDisplay(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.charcoal,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          f.body,
          style: GoogleFonts.montserrat(
            fontSize: 13.5,
            color: AppColors.charcoal.withOpacity(0.6),
            height: 1.7,
          ),
        ),
      ],
    );
  }
}

class _Feature {
  final IconData icon;
  final String title;
  final String body;
  final Color accentColor;
  const _Feature(
      {required this.icon,
      required this.title,
      required this.body,
      required this.accentColor});
}
