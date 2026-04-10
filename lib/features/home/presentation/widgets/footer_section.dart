import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/scroll_reveal.dart';

class FooterSection extends StatelessWidget {
  const FooterSection({super.key});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final isMobile = w < 768;

    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF111111),
      ),
      child: Column(
        children: [
          _buildCta(isMobile),
          _buildDivider(),
          _buildFooterBody(isMobile),
          _buildBottomBar(isMobile),
        ],
      ),
    );
  }

  Widget _buildCta(bool isMobile) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 24 : 80,
        vertical: isMobile ? 60 : 80,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.saffron.withOpacity(0.12),
            Colors.transparent,
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        border: Border(
            bottom: BorderSide(color: AppColors.saffron.withOpacity(0.15))),
      ),
      child: ScrollReveal(
        child: isMobile
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildCtaText(isMobile),
                  const SizedBox(height: 24),
                  _buildCtaButtons(isMobile),
                ],
              )
            : Row(
                children: [
                  Expanded(child: _buildCtaText(isMobile)),
                  _buildCtaButtons(isMobile),
                ],
              ),
      ),
    );
  }

  Widget _buildCtaText(bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('READY TO ORDER?', style: AppTextStyles.label),
        const SizedBox(height: 8),
        Text(
          isMobile
              ? 'Your Next Great\nMeal Awaits'
              : 'Your Next Great Meal Awaits',
          style: isMobile
              ? AppTextStyles.sectionTitleMobile
              : AppTextStyles.sectionTitle,
        ),
      ],
    );
  }

  Widget _buildCtaButtons(bool isMobile) {
    return isMobile
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _CtaButton(
                label: 'Call Now: 04 435 7878',
                icon: Icons.phone_rounded,
                filled: true,
              ),
              const SizedBox(height: 12),
              _CtaButton(
                label: 'WhatsApp Order',
                icon: Icons.chat_rounded,
                filled: false,
              ),
            ],
          )
        : Row(
            children: [
              _CtaButton(
                label: 'Call: 04 435 7878',
                icon: Icons.phone_rounded,
                filled: true,
              ),
              const SizedBox(width: 12),
              _CtaButton(
                label: 'WhatsApp Order',
                icon: Icons.chat_rounded,
                filled: false,
              ),
            ],
          );
  }

  Widget _buildDivider() => Container(
        height: 1,
        color: Colors.white.withOpacity(0.06),
      );

  Widget _buildFooterBody(bool isMobile) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 24 : 80,
        vertical: 56,
      ),
      child: isMobile
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ScrollReveal(child: _buildBrandColumn()),
                const SizedBox(height: 40),
                ScrollReveal(delay: const Duration(milliseconds: 100), child: _buildLocationColumn()),
                const SizedBox(height: 40),
                ScrollReveal(delay: const Duration(milliseconds: 180), child: _buildLinksColumn()),
                const SizedBox(height: 40),
                ScrollReveal(delay: const Duration(milliseconds: 260), child: _buildHoursColumn()),
              ],
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 3, child: ScrollReveal(child: _buildBrandColumn())),
                Expanded(flex: 2, child: ScrollReveal(delay: const Duration(milliseconds: 100), child: _buildLocationColumn())),
                Expanded(flex: 2, child: ScrollReveal(delay: const Duration(milliseconds: 200), child: _buildLinksColumn())),
                Expanded(flex: 2, child: ScrollReveal(delay: const Duration(milliseconds: 300), child: _buildHoursColumn())),
              ],
            ),
    );
  }

  Widget _buildBrandColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.saffron,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.local_fire_department_rounded,
                  color: Colors.white, size: 22),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ENJOY FAMILY',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.warmBone,
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
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: 260,
          child: Text(
            'Authentic Desi Fusion and Tandoori specialties in the heart of International City, Dubai. Open 24 hours, 7 days a week.',
            style: AppTextStyles.footerText,
          ),
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            _SocialIcon(icon: Icons.facebook_rounded),
            const SizedBox(width: 10),
            _SocialIcon(icon: Icons.camera_alt_rounded),
            const SizedBox(width: 10),
            _SocialIcon(icon: Icons.tiktok),
          ],
        ),
      ],
    );
  }

  Widget _buildLocationColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FooterSectionTitle('Location'),
        const SizedBox(height: 16),
        _footerInfoRow(Icons.location_on_rounded,
            'Warsan First, Persia Cluster\nInternational City, Dubai'),
        const SizedBox(height: 12),
        _footerInfoRow(Icons.phone_rounded, '04 435 7878'),
        const SizedBox(height: 12),
        _footerInfoRow(Icons.directions_rounded, 'Get Directions →'),
        const SizedBox(height: 20),
        _MapPlaceholder(),
      ],
    );
  }

  Widget _footerInfoRow(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppColors.saffron, size: 16),
        const SizedBox(width: 10),
        Expanded(
          child: Text(text, style: AppTextStyles.footerText),
        ),
      ],
    );
  }

  Widget _buildLinksColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FooterSectionTitle('Quick Links'),
        const SizedBox(height: 16),
        ...['Our Menu', 'About Us', 'Gallery', 'Reviews', 'Careers', 'Contact']
            .map(
              (link) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: Text(
                    link,
                    style: AppTextStyles.footerText.copyWith(
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
              ),
            ),
      ],
    );
  }

  Widget _buildHoursColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FooterSectionTitle('Opening Hours'),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.saffron.withOpacity(0.08),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.saffron.withOpacity(0.2)),
          ),
          child: Row(
            children: [
              const Icon(Icons.access_time_rounded,
                  color: AppColors.saffron, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'We Never Close',
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.warmBone,
                      ),
                    ),
                    Text(
                      'Serving you 24 hours,\n7 days a week.',
                      style: AppTextStyles.footerText,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        ...['Mon – Fri', 'Saturday', 'Sunday'].map((day) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(day, style: AppTextStyles.footerText),
                  Text('Open 24 Hours',
                      style: AppTextStyles.footerText
                          .copyWith(color: AppColors.saffron)),
                ],
              ),
            )),
      ],
    );
  }

  Widget _buildBottomBar(bool isMobile) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 24 : 80,
        vertical: 20,
      ),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.white.withOpacity(0.06))),
      ),
      child: isMobile
          ? Column(
              children: [
                Text(
                  '© 2024 Enjoy Family Restaurant. All rights reserved.',
                  style: AppTextStyles.footerText
                      .copyWith(fontSize: 11),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 6),
                Text(
                  'International City, Dubai · Persia Cluster',
                  style: AppTextStyles.footerText
                      .copyWith(fontSize: 10, color: AppColors.saffron.withOpacity(0.6)),
                  textAlign: TextAlign.center,
                ),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '© 2024 Enjoy Family Restaurant. All rights reserved.',
                  style: AppTextStyles.footerText.copyWith(fontSize: 12),
                ),
                Text(
                  'International City, Dubai · Persia Cluster',
                  style: AppTextStyles.footerText
                      .copyWith(fontSize: 12, color: AppColors.saffron.withOpacity(0.6)),
                ),
              ],
            ),
    );
  }
}

class _FooterSectionTitle extends StatelessWidget {
  final String title;
  const _FooterSectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: GoogleFonts.montserrat(
        fontSize: 13,
        fontWeight: FontWeight.w700,
        color: AppColors.warmBone,
        letterSpacing: 0.5,
      ),
    );
  }
}

class _SocialIcon extends StatefulWidget {
  final IconData icon;
  const _SocialIcon({required this.icon});

  @override
  State<_SocialIcon> createState() => _SocialIconState();
}

class _SocialIconState extends State<_SocialIcon> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: _hovered
              ? AppColors.saffron
              : AppColors.darkCard,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: _hovered
                ? AppColors.saffron
                : AppColors.glassBorder,
          ),
        ),
        child: Icon(widget.icon,
            color: _hovered ? Colors.white : AppColors.warmBone.withOpacity(0.5),
            size: 18),
      ),
    );
  }
}

class _MapPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110,
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Stack(
        children: [
          CustomPaint(
            size: const Size(double.infinity, 110),
            painter: _MapGridPainter(),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppColors.saffron,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.saffron.withOpacity(0.4),
                        blurRadius: 12,
                        spreadRadius: 3,
                      )
                    ],
                  ),
                  child: const Icon(Icons.location_on_rounded,
                      color: Colors.white, size: 20),
                ),
                const SizedBox(height: 6),
                Text(
                  'Persia Cluster, Int\'l City',
                  style: GoogleFonts.montserrat(
                    fontSize: 10,
                    color: AppColors.warmBone.withOpacity(0.5),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MapGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.04)
      ..strokeWidth = 1;
    const s = 20.0;
    for (double x = 0; x < size.width; x += s) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += s) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(_MapGridPainter old) => false;
}

class _CtaButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final bool filled;
  const _CtaButton(
      {required this.label, required this.icon, required this.filled});

  @override
  State<_CtaButton> createState() => _CtaButtonState();
}

class _CtaButtonState extends State<_CtaButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        decoration: BoxDecoration(
          color: widget.filled
              ? (_hovered ? AppColors.saffronDark : AppColors.saffron)
              : (_hovered
                  ? AppColors.warmBone.withOpacity(0.1)
                  : Colors.transparent),
          borderRadius: BorderRadius.circular(8),
          border: widget.filled
              ? null
              : Border.all(
                  color: AppColors.warmBone.withOpacity(0.3)),
          boxShadow: widget.filled && _hovered
              ? [
                  BoxShadow(
                    color: AppColors.saffron.withOpacity(0.3),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  )
                ]
              : [],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              widget.icon,
              color: widget.filled
                  ? Colors.white
                  : AppColors.warmBone.withOpacity(0.8),
              size: 18,
            ),
            const SizedBox(width: 8),
            Text(
              widget.label,
              style: GoogleFonts.montserrat(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: widget.filled
                    ? Colors.white
                    : AppColors.warmBone.withOpacity(0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
