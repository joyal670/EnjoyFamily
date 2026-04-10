import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../menu/presentation/pages/menu_page.dart';
import '../../../../core/widgets/app_page_route.dart';

// ─── Particle data ───────────────────────────────────────────────────────────

class _Particle {
  final double x, y, size, speed, opacity;
  const _Particle(this.x, this.y, this.size, this.speed, this.opacity);
}

// Deterministic "random" particle field — no dart:math Random needed at runtime
const List<_Particle> _kParticles = [
  _Particle(0.08, 0.10, 1.8, 0.12, 0.20),
  _Particle(0.17, 0.55, 1.2, 0.08, 0.14),
  _Particle(0.25, 0.82, 2.0, 0.15, 0.18),
  _Particle(0.34, 0.30, 1.4, 0.10, 0.22),
  _Particle(0.42, 0.70, 1.6, 0.13, 0.16),
  _Particle(0.51, 0.15, 1.0, 0.07, 0.12),
  _Particle(0.60, 0.48, 2.2, 0.16, 0.20),
  _Particle(0.68, 0.90, 1.4, 0.09, 0.15),
  _Particle(0.75, 0.35, 1.8, 0.11, 0.18),
  _Particle(0.84, 0.62, 1.2, 0.08, 0.13),
  _Particle(0.91, 0.20, 2.0, 0.14, 0.19),
  _Particle(0.13, 0.76, 1.6, 0.12, 0.17),
  _Particle(0.46, 0.40, 1.0, 0.06, 0.11),
  _Particle(0.78, 0.05, 2.4, 0.18, 0.22),
  _Particle(0.30, 0.95, 1.2, 0.09, 0.14),
  _Particle(0.55, 0.60, 1.8, 0.13, 0.16),
  _Particle(0.03, 0.45, 2.0, 0.10, 0.18),
  _Particle(0.95, 0.80, 1.4, 0.11, 0.15),
  _Particle(0.20, 0.22, 1.0, 0.07, 0.12),
  _Particle(0.70, 0.75, 1.6, 0.14, 0.17),
];

// ─── CustomPainters ──────────────────────────────────────────────────────────

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.025)
      ..strokeWidth = 1;
    const s = 60.0;
    for (double x = 0; x < size.width; x += s) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += s) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(_GridPainter _) => false;
}

class _ParticlePainter extends CustomPainter {
  final double t; // 0.0–1.0 looping
  const _ParticlePainter(this.t);

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in _kParticles) {
      final yFrac = ((p.y - t * p.speed) % 1.0 + 1.0) % 1.0;
      final paint = Paint()
        ..color = AppColors.saffron.withOpacity(p.opacity)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(
        Offset(p.x * size.width, yFrac * size.height),
        p.size,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_ParticlePainter old) => old.t != t;
}

class _PulseRingPainter extends CustomPainter {
  final double t; // 0.0–1.0 looping
  const _PulseRingPainter(this.t);

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final maxR = size.width * 0.62;

    for (int i = 0; i < 3; i++) {
      final phase = (t + i / 3.0) % 1.0;
      final radius = maxR * (0.35 + phase * 0.65);
      final opacity = (1.0 - phase) * 0.30;
      if (opacity <= 0) continue;
      canvas.drawCircle(
        Offset(cx, cy),
        radius,
        Paint()
          ..color = AppColors.saffron.withOpacity(opacity)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.0,
      );
    }
  }

  @override
  bool shouldRepaint(_PulseRingPainter old) => old.t != t;
}

// ─── Main HeroSection ─────────────────────────────────────────────────────────

class HeroSection extends StatefulWidget {
  const HeroSection({super.key});

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection>
    with TickerProviderStateMixin {
  // Entry animations
  late AnimationController _entryCtrl;
  late Animation<double> _fadeIn;
  late Animation<Offset> _slideUp;

  // Floating bob for hero visual
  late AnimationController _floatCtrl;
  late Animation<double> _floatY;

  // Particle drift
  late AnimationController _particleCtrl;

  // Pulse rings
  late AnimationController _pulseCtrl;

  @override
  void initState() {
    super.initState();

    _entryCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1300),
    );
    _fadeIn = CurvedAnimation(parent: _entryCtrl, curve: Curves.easeOut);
    _slideUp = Tween<Offset>(
      begin: const Offset(0, 0.10),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _entryCtrl, curve: Curves.easeOutCubic));

    _floatCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3200),
    )..repeat(reverse: true);
    _floatY = Tween<double>(begin: 0, end: -14).animate(
      CurvedAnimation(parent: _floatCtrl, curve: Curves.easeInOut),
    );

    _particleCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat();

    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat();

    _entryCtrl.forward();
  }

  @override
  void dispose() {
    _entryCtrl.dispose();
    _floatCtrl.dispose();
    _particleCtrl.dispose();
    _pulseCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    return SizedBox(
      width: double.infinity,
      height: isMobile ? 620 : 760,
      child: Stack(
        children: [
          _buildBackground(),
          // Animated particles
          AnimatedBuilder(
            animation: _particleCtrl,
            builder: (_, __) => Positioned.fill(
              child: CustomPaint(
                painter: _ParticlePainter(_particleCtrl.value),
              ),
            ),
          ),
          _buildOverlay(),
          _buildFloatingOrbs(),
          _buildContent(isMobile),
          _buildScrollIndicator(),
        ],
      ),
    );
  }

  Widget _buildBackground() {
    return Positioned.fill(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0D0D0D), Color(0xFF1A1A1A), Color(0xFF2C1810)],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: CustomPaint(painter: _GridPainter()),
      ),
    );
  }

  Widget _buildOverlay() {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: const Alignment(0.6, -0.3),
            radius: 0.9,
            colors: [
              AppColors.saffron.withOpacity(0.16),
              Colors.transparent,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFloatingOrbs() {
    return Stack(
      children: [
        Positioned(
          right: -60,
          top: 80,
          child: _Orb(size: 300, color: AppColors.saffron.withOpacity(0.06)),
        ),
        Positioned(
          left: -40,
          bottom: 100,
          child: _Orb(size: 200, color: AppColors.saffron.withOpacity(0.04)),
        ),
        Positioned(
          right: 200,
          bottom: 60,
          child: _Orb(size: 120, color: AppColors.saffron.withOpacity(0.08)),
        ),
      ],
    );
  }

  Widget _buildContent(bool isMobile) {
    return Positioned.fill(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 24 : 80,
          vertical: isMobile ? 100 : 0,
        ),
        child: isMobile ? _buildMobileContent() : _buildDesktopContent(),
      ),
    );
  }

  Widget _buildDesktopContent() {
    return Row(
      children: [
        Expanded(
          flex: 6,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Badge — stagger 0ms
              FadeTransition(
                opacity: _fadeIn,
                child: _LocationBadge(desktop: true),
              ),
              const SizedBox(height: 28),
              // Headline — slides up
              SlideTransition(
                position: _slideUp,
                child: FadeTransition(
                  opacity: _fadeIn,
                  child: Text(
                    'Authentic\nFlavors,\nModern Spirit.',
                    style: AppTextStyles.heroHeadline,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              FadeTransition(
                opacity: _fadeIn,
                child: SizedBox(
                  width: 480,
                  child: Text(
                    'Experience the finest Desi Fusion and Tandoori specialties in the heart of International City, Dubai. Open 24/7 for your cravings.',
                    style: AppTextStyles.heroSubheadline,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              FadeTransition(
                opacity: _fadeIn,
                child: Builder(
                  builder: (ctx) => Row(
                    children: [
                      _PrimaryButton(
                          label: 'View Our Menu',
                          icon: Icons.restaurant_menu,
                          onTap: () => Navigator.push(
                              ctx, SlideUpRoute(page: const MenuPage()))),
                      const SizedBox(width: 16),
                      _OutlineButton(
                          label: 'Order Delivery',
                          icon: Icons.delivery_dining_rounded,
                          onTap: () => Navigator.push(
                              ctx, SlideUpRoute(page: const MenuPage()))),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 52),
              FadeTransition(opacity: _fadeIn, child: _buildStats()),
            ],
          ),
        ),
        Expanded(
          flex: 4,
          child: FadeTransition(
            opacity: _fadeIn,
            child: _buildHeroVisual(),
          ),
        ),
      ],
    );
  }

  Widget _buildMobileContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 32),
        FadeTransition(
            opacity: _fadeIn, child: _LocationBadge(desktop: false)),
        const SizedBox(height: 20),
        SlideTransition(
          position: _slideUp,
          child: FadeTransition(
            opacity: _fadeIn,
            child: Text('Authentic\nFlavors,\nModern Spirit.',
                style: AppTextStyles.heroHeadlineMobile),
          ),
        ),
        const SizedBox(height: 16),
        FadeTransition(
          opacity: _fadeIn,
          child: Text(
            'Experience the finest Desi Fusion & Tandoori specialties in Dubai. Open 24/7.',
            style: AppTextStyles.heroSubheadlineMobile,
          ),
        ),
        const SizedBox(height: 28),
        FadeTransition(
          opacity: _fadeIn,
          child: Builder(
            builder: (ctx) => Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _PrimaryButton(
                    label: 'View Our Menu',
                    icon: Icons.restaurant_menu,
                    onTap: () => Navigator.push(
                        ctx, SlideUpRoute(page: const MenuPage()))),
                const SizedBox(height: 12),
                _OutlineButton(
                    label: 'Order Delivery',
                    icon: Icons.delivery_dining_rounded,
                    onTap: () => Navigator.push(
                        ctx, SlideUpRoute(page: const MenuPage()))),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStats() {
    return Row(
      children: [
        _StatItem(value: '4.5★', label: 'Rating'),
        _divider(),
        _StatItem(value: '24/7', label: 'Open Always'),
        _divider(),
        _StatItem(value: '10+', label: 'Years Serving'),
      ],
    );
  }

  Widget _divider() => Container(
        width: 1,
        height: 32,
        color: AppColors.warmBone.withOpacity(0.2),
        margin: const EdgeInsets.symmetric(horizontal: 24),
      );

  Widget _buildHeroVisual() {
    return Center(
      // Floating bob animation
      child: AnimatedBuilder(
        animation: _floatY,
        builder: (_, child) => Transform.translate(
          offset: Offset(0, _floatY.value),
          child: child,
        ),
        child: SizedBox(
          width: 360,
          height: 360,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Outer glow gradient
              Container(
                width: 360,
                height: 360,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.saffron.withOpacity(0.15),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
              // Animated pulse rings
              AnimatedBuilder(
                animation: _pulseCtrl,
                builder: (_, __) => SizedBox(
                  width: 360,
                  height: 360,
                  child: CustomPaint(
                    painter: _PulseRingPainter(_pulseCtrl.value),
                  ),
                ),
              ),
              // Main circle
              Container(
                width: 270,
                height: 270,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppColors.darkCard, AppColors.charcoal],
                  ),
                  border: Border.all(
                    color: AppColors.saffron.withOpacity(0.30),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.saffron.withOpacity(0.22),
                      blurRadius: 64,
                      spreadRadius: 8,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.local_fire_department_rounded,
                        color: AppColors.saffron, size: 60),
                    const SizedBox(height: 12),
                    Text(
                      'Tandoori\nBonfire Pizza',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 21,
                        fontWeight: FontWeight.w700,
                        color: AppColors.warmBone,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Signature Dish',
                      style: GoogleFonts.montserrat(
                        fontSize: 11,
                        color: AppColors.saffron,
                        letterSpacing: 1.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              // Floating badges
              Positioned(
                top: 28,
                right: 8,
                child: _FloatingBadge(
                  icon: Icons.star_rounded,
                  text: '4.5 Stars',
                  delay: const Duration(milliseconds: 200),
                ),
              ),
              Positioned(
                bottom: 32,
                left: 0,
                child: _FloatingBadge(
                  icon: Icons.access_time_filled,
                  text: 'Open 24/7',
                  delay: const Duration(milliseconds: 500),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScrollIndicator() {
    return Positioned(
      bottom: 20,
      left: 0,
      right: 0,
      child: Center(
        child: Column(
          children: [
            Text(
              'SCROLL TO EXPLORE',
              style: GoogleFonts.montserrat(
                fontSize: 9,
                letterSpacing: 3,
                color: AppColors.warmBone.withOpacity(0.35),
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            _ScrollDot(),
          ],
        ),
      ),
    );
  }
}

// ─── Scroll dot (bouncing) ────────────────────────────────────────────────────

class _ScrollDot extends StatefulWidget {
  @override
  State<_ScrollDot> createState() => _ScrollDotState();
}

class _ScrollDotState extends State<_ScrollDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _y;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _y = Tween<double>(begin: 0, end: 8).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _y,
      builder: (_, __) => Transform.translate(
        offset: Offset(0, _y.value),
        child: Container(
          width: 1,
          height: 36,
          color: AppColors.warmBone.withOpacity(0.2),
        ),
      ),
    );
  }
}

// ─── LocationBadge ────────────────────────────────────────────────────────────

class _LocationBadge extends StatelessWidget {
  final bool desktop;
  const _LocationBadge({required this.desktop});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: desktop ? 14 : 12,
        vertical: desktop ? 6 : 5,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.saffron.withOpacity(0.5)),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        desktop
            ? 'INTERNATIONAL CITY, DUBAI — OPEN 24/7'
            : 'INTERNATIONAL CITY • OPEN 24/7',
        style: GoogleFonts.montserrat(
          fontSize: desktop ? 11 : 9,
          fontWeight: FontWeight.w600,
          color: AppColors.saffron,
          letterSpacing: desktop ? 2 : 1.5,
        ),
      ),
    );
  }
}

// ─── Floating badge (entrance animation) ─────────────────────────────────────

class _FloatingBadge extends StatefulWidget {
  final IconData icon;
  final String text;
  final Duration delay;
  const _FloatingBadge(
      {required this.icon, required this.text, required this.delay});

  @override
  State<_FloatingBadge> createState() => _FloatingBadgeState();
}

class _FloatingBadgeState extends State<_FloatingBadge>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _fade;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutBack));

    Future.delayed(const Duration(milliseconds: 900) + widget.delay, () {
      if (mounted) _ctrl.forward();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.glassWhite,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.glassBorder),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 16,
                offset: const Offset(0, 4),
              )
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(widget.icon, color: AppColors.saffron, size: 16),
              const SizedBox(width: 6),
              Text(
                widget.text,
                style: GoogleFonts.montserrat(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.warmBone,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Stat item ────────────────────────────────────────────────────────────────

class _StatItem extends StatelessWidget {
  final String value;
  final String label;
  const _StatItem({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: GoogleFonts.playfairDisplay(
            fontSize: 26,
            fontWeight: FontWeight.w700,
            color: AppColors.saffron,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.montserrat(
            fontSize: 11,
            color: AppColors.warmBone.withOpacity(0.5),
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}

class _Orb extends StatelessWidget {
  final double size;
  final Color color;
  const _Orb({required this.size, required this.color});

  @override
  Widget build(BuildContext context) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      );
}

// ─── Primary Button (with shimmer sweep) ─────────────────────────────────────

class _PrimaryButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final VoidCallback? onTap;
  const _PrimaryButton({required this.label, required this.icon, this.onTap});

  @override
  State<_PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<_PrimaryButton>
    with TickerProviderStateMixin {
  bool _hovered = false;
  late AnimationController _shimmerCtrl;
  late Animation<double> _shimmer;
  late AnimationController _scaleCtrl;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _shimmerCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat();
    _shimmer = CurvedAnimation(parent: _shimmerCtrl, curve: Curves.linear);

    _scaleCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scale = Tween<double>(begin: 1.0, end: 1.04)
        .animate(CurvedAnimation(parent: _scaleCtrl, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _shimmerCtrl.dispose();
    _scaleCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) {
        setState(() => _hovered = true);
        _scaleCtrl.forward();
      },
      onExit: (_) {
        setState(() => _hovered = false);
        _scaleCtrl.reverse();
      },
      child: GestureDetector(
        onTap: widget.onTap,
        child: ScaleTransition(
        scale: _scale,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: _hovered ? AppColors.saffronDark : AppColors.saffron,
            borderRadius: BorderRadius.circular(8),
            boxShadow: _hovered
                ? [
                    BoxShadow(
                      color: AppColors.saffron.withOpacity(0.45),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    )
                  ]
                : [],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 28, vertical: 16),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(widget.icon, color: Colors.white, size: 18),
                      const SizedBox(width: 10),
                      Text(
                        widget.label,
                        style: GoogleFonts.montserrat(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ],
                  ),
                ),
                // Shimmer sweep overlay
                Positioned.fill(
                  child: AnimatedBuilder(
                    animation: _shimmer,
                    builder: (_, __) {
                      final x = _shimmer.value * 2.4 - 0.7;
                      return Transform.translate(
                        offset: Offset(x * 200, 0),
                        child: Transform.rotate(
                          angle: math.pi / 6,
                          child: Container(
                            width: 40,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.white.withOpacity(0),
                                  Colors.white.withOpacity(0.22),
                                  Colors.white.withOpacity(0),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      ),
    );
  }
}

// ─── Outline Button ───────────────────────────────────────────────────────────

class _OutlineButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final VoidCallback? onTap;
  const _OutlineButton({required this.label, required this.icon, this.onTap});

  @override
  State<_OutlineButton> createState() => _OutlineButtonState();
}

class _OutlineButtonState extends State<_OutlineButton>
    with SingleTickerProviderStateMixin {
  bool _hovered = false;
  late AnimationController _scaleCtrl;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _scaleCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scale = Tween<double>(begin: 1.0, end: 1.04)
        .animate(CurvedAnimation(parent: _scaleCtrl, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _scaleCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) {
        setState(() => _hovered = true);
        _scaleCtrl.forward();
      },
      onExit: (_) {
        setState(() => _hovered = false);
        _scaleCtrl.reverse();
      },
      child: GestureDetector(
        onTap: widget.onTap,
        child: ScaleTransition(
        scale: _scale,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: _hovered
                ? AppColors.warmBone.withOpacity(0.12)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: _hovered
                  ? AppColors.warmBone.withOpacity(0.85)
                  : AppColors.warmBone.withOpacity(0.5),
              width: 1.5,
            ),
          ),
          padding:
              const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(widget.icon, color: AppColors.warmBone, size: 18),
              const SizedBox(width: 10),
              Text(
                widget.label,
                style: GoogleFonts.montserrat(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.warmBone,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
        ),
      ),
      ),
    );
  }
}
