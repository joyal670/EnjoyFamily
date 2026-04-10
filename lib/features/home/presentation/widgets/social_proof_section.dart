import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/scroll_reveal.dart';

class SocialProofSection extends StatelessWidget {
  const SocialProofSection({super.key});

  static const _reviews = [
    _Review(
      name: 'Ali Raza',
      country: 'Pakistan',
      rating: 5,
      text:
          'The best desi food in International City. The Tandoori Bonfire Pizza is a game-changer! Never thought fusion could taste this authentic.',
      timeAgo: '2 days ago',
      initials: 'AR',
    ),
    _Review(
      name: 'Mohammed Al Farsi',
      country: 'UAE',
      rating: 5,
      text:
          'I come here every Friday for the Mutton Karahi. The spice blend is unmatched anywhere in Dubai. Truly a hidden gem in Persia Cluster.',
      timeAgo: '1 week ago',
      initials: 'MF',
    ),
    _Review(
      name: 'Priya Sharma',
      country: 'India',
      rating: 4,
      text:
          'Amazing 24/7 breakfast! The Halwa Puri at 2am after a late shift is an absolute lifesaver. Service is always quick and warm.',
      timeAgo: '2 weeks ago',
      initials: 'PS',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final isMobile = w < 768;

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1A1A1A), Color(0xFF242424)],
        ),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 24 : 80,
        vertical: isMobile ? 60 : 100,
      ),
      child: Column(
        children: [
          _buildHeader(isMobile),
          const SizedBox(height: 56),
          _buildRatingBadge(),
          const SizedBox(height: 56),
          _buildReviews(isMobile),
          const SizedBox(height: 56),
          _buildPhotoGrid(isMobile),
        ],
      ),
    );
  }

  Widget _buildHeader(bool isMobile) {
    return Column(
      children: [
        Text('WHAT OUR GUESTS SAY', style: AppTextStyles.label),
        const SizedBox(height: 12),
        Text(
          'Loved by Thousands\nAcross Dubai',
          textAlign: TextAlign.center,
          style: isMobile
              ? AppTextStyles.sectionTitleMobile
              : AppTextStyles.sectionTitle,
        ),
      ],
    );
  }

  Widget _buildRatingBadge() {
    return LayoutBuilder(builder: (context, constraints) {
      // Switch to vertical layout on narrow screens to prevent overflow
      final isNarrow = constraints.maxWidth < 480;

      final ratingCol = Column(
        children: [
          Text(
            '4.5',
            style: GoogleFonts.playfairDisplay(
              fontSize: isNarrow ? 48 : 64,
              fontWeight: FontWeight.w700,
              color: AppColors.saffron,
              height: 1,
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(
              5,
              (i) => Icon(
                i < 4 ? Icons.star_rounded : Icons.star_half_rounded,
                color: AppColors.saffron,
                size: isNarrow ? 18 : 22,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'EXCELLENCE RATING',
            style: GoogleFonts.montserrat(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: AppColors.saffron.withOpacity(0.7),
              letterSpacing: 2,
            ),
          ),
        ],
      );

      final statsCol = Column(
        crossAxisAlignment:
            isNarrow ? CrossAxisAlignment.center : CrossAxisAlignment.start,
        children: [
          _AnimatedStatRow(
            icon: Icons.people_rounded,
            target: 10000,
            suffix: '+',
            label: 'Happy Guests',
          ),
          const SizedBox(height: 12),
          _AnimatedStatRow(
            icon: Icons.rate_review_rounded,
            target: 2400,
            suffix: '+',
            label: 'Reviews',
          ),
          const SizedBox(height: 12),
          _StatRow(
              icon: Icons.emoji_events_rounded,
              value: '#1',
              label: 'In Persia Cluster'),
        ],
      );

      return Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: isNarrow ? 20 : 40,
          vertical: 28,
        ),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF2D1A05), Color(0xFF1A1005)],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.saffron.withOpacity(0.3)),
        ),
        child: isNarrow
            ? Column(
                children: [
                  ratingCol,
                  const SizedBox(height: 20),
                  Container(
                    width: 60,
                    height: 1,
                    color: AppColors.saffron.withOpacity(0.2),
                  ),
                  const SizedBox(height: 20),
                  statsCol,
                ],
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ratingCol,
                  Container(
                    width: 1,
                    height: 80,
                    color: AppColors.saffron.withOpacity(0.2),
                    margin: const EdgeInsets.symmetric(horizontal: 32),
                  ),
                  statsCol,
                ],
              ),
      );
    });
  }

  Widget _buildReviews(bool isMobile) {
    if (isMobile) {
      return Column(
        children: List.generate(_reviews.length, (i) => Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: ScrollReveal(
            delay: Duration(milliseconds: 120 * i),
            child: _ReviewCard(review: _reviews[i]),
          ),
        )),
      );
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(_reviews.length, (i) => Expanded(
        child: Padding(
          padding: EdgeInsets.only(right: i < _reviews.length - 1 ? 20 : 0),
          child: ScrollReveal(
            delay: Duration(milliseconds: 110 * i),
            child: _ReviewCard(review: _reviews[i]),
          ),
        ),
      )),
    );
  }

  Widget _buildPhotoGrid(bool isMobile) {
    final colors = [
      const Color(0xFF3D1505),
      const Color(0xFF1A0D20),
      const Color(0xFF0A1A05),
      const Color(0xFF1A1200),
      const Color(0xFF0A1520),
      const Color(0xFF200A0A),
    ];
    final icons = [
      Icons.local_fire_department_rounded,
      Icons.soup_kitchen_rounded,
      Icons.breakfast_dining_rounded,
      Icons.rice_bowl_rounded,
      Icons.local_cafe_rounded,
      Icons.restaurant_rounded,
    ];
    final labels = [
      'Bonfire Pizza',
      'Karahi',
      'Breakfast',
      'Biryani',
      'Beverages',
      'Tandoori',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('FROM OUR KITCHEN', style: AppTextStyles.label),
        const SizedBox(height: 20),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: isMobile ? 2 : 3,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: isMobile ? 1.0 : 1.25,
          ),
          itemCount: 6,
          itemBuilder: (_, i) => ScrollReveal(
            delay: Duration(milliseconds: 60 * i),
            child: _PhotoCard(
              color: colors[i],
              icon: icons[i],
              label: labels[i],
            ),
          ),
        ),
      ],
    );
  }
}

class _StatRow extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  const _StatRow(
      {required this.icon, required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.saffron, size: 18),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: GoogleFonts.playfairDisplay(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.warmBone,
              ),
            ),
            Text(
              label,
              style: GoogleFonts.montserrat(
                fontSize: 11,
                color: AppColors.warmBone.withOpacity(0.5),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Stat row that uses an animated count-up for the number value.
class _AnimatedStatRow extends StatelessWidget {
  final IconData icon;
  final int target;
  final String suffix;
  final String label;
  const _AnimatedStatRow({
    required this.icon,
    required this.target,
    required this.suffix,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.saffron, size: 18),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CountUpText(
              target: target,
              suffix: suffix,
              style: GoogleFonts.playfairDisplay(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.warmBone,
              ),
            ),
            Text(
              label,
              style: GoogleFonts.montserrat(
                fontSize: 11,
                color: AppColors.warmBone.withOpacity(0.5),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ReviewCard extends StatelessWidget {
  final _Review review;
  const _ReviewCard({required this.review});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: List.generate(
              5,
              (i) => Icon(
                i < review.rating ? Icons.star_rounded : Icons.star_border_rounded,
                color: AppColors.saffron,
                size: 16,
              ),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            '"${review.text}"',
            style: GoogleFonts.montserrat(
              fontSize: 13.5,
              color: AppColors.warmBone.withOpacity(0.8),
              height: 1.7,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: AppColors.saffron.withOpacity(0.2),
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: AppColors.saffron.withOpacity(0.4)),
                ),
                child: Center(
                  child: Text(
                    review.initials,
                    style: GoogleFonts.montserrat(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.saffron,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    review.name,
                    style: GoogleFonts.montserrat(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.warmBone,
                    ),
                  ),
                  Text(
                    '${review.country} · ${review.timeAgo}',
                    style: GoogleFonts.montserrat(
                      fontSize: 11,
                      color: AppColors.warmBone.withOpacity(0.4),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PhotoCard extends StatefulWidget {
  final Color color;
  final IconData icon;
  final String label;
  const _PhotoCard(
      {required this.color, required this.icon, required this.label});

  @override
  State<_PhotoCard> createState() => _PhotoCardState();
}

class _PhotoCardState extends State<_PhotoCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: widget.color,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: _hovered
                ? AppColors.saffron.withOpacity(0.5)
                : AppColors.glassBorder,
          ),
          boxShadow: _hovered
              ? [
                  BoxShadow(
                    color: AppColors.saffron.withOpacity(0.1),
                    blurRadius: 20,
                  )
                ]
              : [],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(widget.icon,
                color: AppColors.saffron.withOpacity(_hovered ? 1 : 0.7),
                size: 36),
            const SizedBox(height: 10),
            Text(
              widget.label,
              style: GoogleFonts.montserrat(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.warmBone.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Review {
  final String name;
  final String country;
  final int rating;
  final String text;
  final String timeAgo;
  final String initials;
  const _Review({
    required this.name,
    required this.country,
    required this.rating,
    required this.text,
    required this.timeAgo,
    required this.initials,
  });
}
