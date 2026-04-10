import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';

// ─── Confetti particle data (deterministic) ───────────────────────────────────

class _Particle {
  final double angle;
  final double speed;
  final double size;
  final Color color;
  const _Particle(this.angle, this.speed, this.size, this.color);
}

const _kParticles = [
  _Particle(0.1, 0.7, 6, AppColors.saffron),
  _Particle(0.5, 0.9, 4, Color(0xFF3498DB)),
  _Particle(0.9, 0.6, 5, AppColors.saffronLight),
  _Particle(1.3, 0.8, 7, Color(0xFF2ECC71)),
  _Particle(1.7, 0.5, 4, AppColors.saffron),
  _Particle(2.1, 0.9, 6, Color(0xFF9B59B6)),
  _Particle(2.5, 0.7, 5, Color(0xFFE74C3C)),
  _Particle(2.9, 0.6, 4, AppColors.saffron),
  _Particle(3.3, 0.8, 6, Color(0xFF3498DB)),
  _Particle(3.7, 0.7, 5, Color(0xFF2ECC71)),
  _Particle(4.1, 0.9, 4, AppColors.saffronLight),
  _Particle(4.5, 0.6, 7, AppColors.saffron),
  _Particle(4.9, 0.8, 5, Color(0xFF9B59B6)),
  _Particle(5.3, 0.7, 4, Color(0xFFE74C3C)),
  _Particle(5.7, 0.5, 6, AppColors.saffron),
  _Particle(6.1, 0.9, 5, Color(0xFF2ECC71)),
];

// ─── CustomPainters ───────────────────────────────────────────────────────────

class _CheckCirclePainter extends CustomPainter {
  final double circleProgress; // 0→1: circle stroke draws in
  final double checkProgress;  // 0→1: check draws in after circle
  const _CheckCirclePainter(
      {required this.circleProgress, required this.checkProgress});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = size.width / 2 - 6;

    // Circle stroke
    final circlePaint = Paint()
      ..color = const Color(0xFF1B7A3E)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      Rect.fromCircle(center: Offset(cx, cy), radius: r),
      -math.pi / 2,
      2 * math.pi * circleProgress,
      false,
      circlePaint,
    );

    // Fill circle once complete
    if (circleProgress >= 1) {
      canvas.drawCircle(
        Offset(cx, cy),
        r,
        Paint()..color = const Color(0xFF1B7A3E).withOpacity(0.15),
      );
    }

    // Checkmark path
    if (checkProgress > 0) {
      final checkPaint = Paint()
        ..color = const Color(0xFF1B7A3E)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 5
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round;

      // Checkmark: two segments
      // First segment: down-left (short arm)
      // Second segment: up-right (long arm)
      final p1 = Offset(cx - r * 0.35, cy + r * 0.05);
      final p2 = Offset(cx - r * 0.05, cy + r * 0.35);
      final p3 = Offset(cx + r * 0.42, cy - r * 0.32);

      final totalLen = (_dist(p1, p2) + _dist(p2, p3));
      final drawn = totalLen * checkProgress;
      final seg1Len = _dist(p1, p2);

      if (drawn <= seg1Len) {
        final t = drawn / seg1Len;
        final path = Path()
          ..moveTo(p1.dx, p1.dy)
          ..lineTo(p1.dx + (p2.dx - p1.dx) * t, p1.dy + (p2.dy - p1.dy) * t);
        canvas.drawPath(path, checkPaint);
      } else {
        final remaining = drawn - seg1Len;
        final seg2Len = _dist(p2, p3);
        final t = (remaining / seg2Len).clamp(0.0, 1.0);
        final path = Path()
          ..moveTo(p1.dx, p1.dy)
          ..lineTo(p2.dx, p2.dy)
          ..lineTo(p2.dx + (p3.dx - p2.dx) * t,
              p2.dy + (p3.dy - p2.dy) * t);
        canvas.drawPath(path, checkPaint);
      }
    }
  }

  double _dist(Offset a, Offset b) {
    final dx = b.dx - a.dx;
    final dy = b.dy - a.dy;
    return math.sqrt(dx * dx + dy * dy);
  }

  @override
  bool shouldRepaint(_CheckCirclePainter old) =>
      old.circleProgress != circleProgress ||
      old.checkProgress != checkProgress;
}

class _ConfettiPainter extends CustomPainter {
  final double t; // 0→1
  const _ConfettiPainter(this.t);

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    for (final p in _kParticles) {
      final dist = t * p.speed * math.min(size.width, size.height) * 0.55;
      final x = cx + dist * math.cos(p.angle);
      final y = cy + dist * math.sin(p.angle);
      final opacity = (1.0 - t * 0.8).clamp(0.0, 1.0);
      canvas.drawCircle(
        Offset(x, y),
        p.size * (1 - t * 0.4),
        Paint()..color = p.color.withOpacity(opacity),
      );
    }
  }

  @override
  bool shouldRepaint(_ConfettiPainter old) => old.t != t;
}

// ─── Screen ───────────────────────────────────────────────────────────────────

class OrderConfirmationPage extends StatefulWidget {
  const OrderConfirmationPage({super.key});

  @override
  State<OrderConfirmationPage> createState() =>
      _OrderConfirmationPageState();
}

class _OrderConfirmationPageState extends State<OrderConfirmationPage>
    with TickerProviderStateMixin {
  late AnimationController _circleCtrl;   // draws the circle stroke
  late AnimationController _checkCtrl;    // draws the checkmark
  late AnimationController _confettiCtrl; // particle burst
  late AnimationController _textCtrl;     // text + card fade in
  late AnimationController _pulseCtrl;    // pulsing glow ring

  @override
  void initState() {
    super.initState();

    _circleCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 650));
    _checkCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 450));
    _confettiCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1200));
    _textCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    _pulseCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1800))
      ..repeat();

    // Sequenced playback
    _circleCtrl.forward().then((_) {
      _checkCtrl.forward();
      _confettiCtrl.forward();
    });
    Future.delayed(const Duration(milliseconds: 900), () {
      if (mounted) _textCtrl.forward();
    });
  }

  @override
  void dispose() {
    _circleCtrl.dispose();
    _checkCtrl.dispose();
    _confettiCtrl.dispose();
    _textCtrl.dispose();
    _pulseCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    return Scaffold(
      backgroundColor: AppColors.charcoal,
      body: SafeArea(
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Confetti burst
            AnimatedBuilder(
              animation: _confettiCtrl,
              builder: (_, __) => Positioned.fill(
                child: CustomPaint(
                  painter: _ConfettiPainter(_confettiCtrl.value),
                ),
              ),
            ),
            // Main content
            SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 24 : 80,
                  vertical: 40,
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    // Animated checkmark
                    _buildCheckmark(),
                    const SizedBox(height: 32),
                    // Title
                    _buildText(isMobile),
                    const SizedBox(height: 28),
                    // Order details card
                    _buildDetailsCard(isMobile),
                    const SizedBox(height: 36),
                    // Back to home
                    _buildHomeButton(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckmark() {
    return AnimatedBuilder(
      animation: _pulseCtrl,
      builder: (_, child) {
        final pulse = (math.sin(_pulseCtrl.value * 2 * math.pi) + 1) / 2;
        return Stack(
          alignment: Alignment.center,
          children: [
            // Pulse ring
            Container(
              width: 140 + pulse * 20,
              height: 140 + pulse * 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF1B7A3E).withOpacity(0.07 * (1 - pulse)),
              ),
            ),
            child!,
          ],
        );
      },
      child: AnimatedBuilder(
        animation: Listenable.merge([_circleCtrl, _checkCtrl]),
        builder: (_, __) => SizedBox(
          width: 120,
          height: 120,
          child: CustomPaint(
            painter: _CheckCirclePainter(
              circleProgress: _circleCtrl.value,
              checkProgress: _checkCtrl.value,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildText(bool isMobile) {
    return FadeTransition(
      opacity: CurvedAnimation(parent: _textCtrl, curve: Curves.easeOut),
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.1),
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: _textCtrl, curve: Curves.easeOutCubic)),
        child: Column(
          children: [
            ScaleTransition(
              scale: CurvedAnimation(
                  parent: _textCtrl, curve: Curves.easeOutBack),
              child: Text(
                'Order Confirmed!',
                style: GoogleFonts.playfairDisplay(
                  fontSize: isMobile ? 32 : 40,
                  fontWeight: FontWeight.w700,
                  color: AppColors.warmBone,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Your food is being prepared with love.',
              textAlign: TextAlign.center,
              style: GoogleFonts.montserrat(
                fontSize: 14,
                color: AppColors.warmBone.withOpacity(0.55),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailsCard(bool isMobile) {
    return FadeTransition(
      opacity: CurvedAnimation(parent: _textCtrl, curve: Curves.easeOut),
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.15),
          end: Offset.zero,
        ).animate(CurvedAnimation(
            parent: _textCtrl,
            curve: const Interval(0.2, 1.0, curve: Curves.easeOutCubic))),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.darkCard,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.glassBorder),
          ),
          child: Column(
            children: [
              _DetailRow(
                icon: Icons.timer_rounded,
                label: 'Estimated Delivery',
                value: '25–35 min',
                color: Colors.blueAccent,
              ),
              const SizedBox(height: 16),
              _DetailRow(
                icon: Icons.location_on_rounded,
                label: 'Delivering To',
                value: 'Persia Cluster, Int\'l City',
                color: AppColors.saffron,
              ),
              const SizedBox(height: 16),
              _DetailRow(
                icon: Icons.phone_rounded,
                label: 'Contact',
                value: '04 435 7878',
                color: const Color(0xFF2ECC71),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.saffron.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                      color: AppColors.saffron.withOpacity(0.3)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.info_outline_rounded,
                        color: AppColors.saffron, size: 16),
                    const SizedBox(width: 8),
                    Text(
                      'We will call to confirm your order',
                      style: GoogleFonts.montserrat(
                        fontSize: 12,
                        color: AppColors.saffron,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHomeButton() {
    return FadeTransition(
      opacity: CurvedAnimation(
          parent: _textCtrl,
          curve: const Interval(0.4, 1.0, curve: Curves.easeOut)),
      child: Column(
        children: [
          GestureDetector(
            onTap: () =>
                Navigator.popUntil(context, (route) => route.isFirst),
            child: Container(
              width: double.infinity,
              height: 56,
              decoration: BoxDecoration(
                color: AppColors.saffron,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.saffron.withOpacity(0.4),
                    blurRadius: 18,
                    offset: const Offset(0, 6),
                  )
                ],
              ),
              child: Center(
                child: Text(
                  'Back to Home',
                  style: GoogleFonts.montserrat(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Text(
              'Order more dishes',
              style: GoogleFonts.montserrat(
                fontSize: 13,
                color: AppColors.warmBone.withOpacity(0.4),
                decoration: TextDecoration.underline,
                decorationColor: AppColors.warmBone.withOpacity(0.3),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  const _DetailRow(
      {required this.icon,
      required this.label,
      required this.value,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: color.withOpacity(0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 18),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.montserrat(
                  fontSize: 11,
                  color: AppColors.warmBone.withOpacity(0.45),
                ),
              ),
              Text(
                value,
                style: GoogleFonts.montserrat(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.warmBone,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
