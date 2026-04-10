import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

/// Provides the page [ScrollController] to descendant [ScrollReveal] and
/// [CountUpText] widgets so they can detect viewport entry.
class ScrollRevealProvider extends InheritedWidget {
  final ScrollController scrollController;

  const ScrollRevealProvider({
    super.key,
    required this.scrollController,
    required super.child,
  });

  static ScrollRevealProvider? of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<ScrollRevealProvider>();

  @override
  bool updateShouldNotify(ScrollRevealProvider old) => false;
}

// ─── Shared mixin ─────────────────────────────────────────────────────────────

/// Safe viewport check: always defers the actual RenderBox geometry read to
/// after the current frame finishes, avoiding layout-reentrancy crashes.
mixin _ViewportCheckMixin<T extends StatefulWidget> on State<T> {
  ScrollController? _sc;
  bool _pendingCheck = false; // deduplicate per-frame

  void attachScrollController(ScrollController? sc) {
    _sc = sc;
    _sc?.addListener(_scheduleCheck);
    _scheduleCheck(); // also check once on mount
  }

  void _scheduleCheck() {
    if (_pendingCheck || !mounted || isTriggered) return;
    _pendingCheck = true;
    // Always read geometry *after* layout+paint are complete.
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _pendingCheck = false;
      _doCheck();
    });
  }

  void _doCheck() {
    if (isTriggered || !mounted) return;
    final box = context.findRenderObject() as RenderBox?;
    if (box == null || !box.attached) return;
    // localToGlobal is safe here because we are in postFrameCallback.
    final topY = box.localToGlobal(Offset.zero).dy;
    final screenH = MediaQuery.of(context).size.height;
    if (topY < screenH * 0.93) {
      onVisible();
    }
  }

  bool get isTriggered;
  void onVisible();

  @override
  void dispose() {
    _sc?.removeListener(_scheduleCheck);
    super.dispose();
  }
}

// ─── ScrollReveal ─────────────────────────────────────────────────────────────

/// Fades + slides its [child] into view once it scrolls into the viewport.
class ScrollReveal extends StatefulWidget {
  final Widget child;
  final Duration delay;
  final Duration duration;
  final Offset slideFrom; // fractional, e.g. Offset(0, 0.07) = from below

  const ScrollReveal({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 680),
    this.slideFrom = const Offset(0, 0.07),
  });

  @override
  State<ScrollReveal> createState() => _ScrollRevealState();
}

class _ScrollRevealState extends State<ScrollReveal>
    with SingleTickerProviderStateMixin, _ViewportCheckMixin {
  late AnimationController _ctrl;
  late Animation<double> _fade;
  late Animation<Offset> _slide;
  bool _triggered = false;

  @override
  bool get isTriggered => _triggered;

  @override
  void onVisible() {
    _triggered = true;
    Future.delayed(widget.delay, () {
      if (mounted) _ctrl.forward();
    });
  }

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: widget.duration);
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _slide = Tween<Offset>(begin: widget.slideFrom, end: Offset.zero)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final sc = ScrollRevealProvider.of(context)?.scrollController;
      attachScrollController(sc);
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => FadeTransition(
        opacity: _fade,
        child: SlideTransition(position: _slide, child: widget.child),
      );
}

// ─── CountUpText ──────────────────────────────────────────────────────────────

/// Counts from 0 up to [target] when it scrolls into the viewport.
class CountUpText extends StatefulWidget {
  final int target;
  final String suffix;
  final TextStyle style;
  final Duration duration;

  const CountUpText({
    super.key,
    required this.target,
    required this.style,
    this.suffix = '',
    this.duration = const Duration(milliseconds: 1600),
  });

  @override
  State<CountUpText> createState() => _CountUpTextState();
}

class _CountUpTextState extends State<CountUpText>
    with SingleTickerProviderStateMixin, _ViewportCheckMixin {
  late AnimationController _ctrl;
  late Animation<int> _count;
  bool _started = false;

  @override
  bool get isTriggered => _started;

  @override
  void onVisible() {
    _started = true;
    _ctrl.forward();
  }

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: widget.duration);
    _count = IntTween(begin: 0, end: widget.target)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final sc = ScrollRevealProvider.of(context)?.scrollController;
      attachScrollController(sc);
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: _count,
        builder: (_, __) =>
            Text('${_count.value}${widget.suffix}', style: widget.style),
      );
}
