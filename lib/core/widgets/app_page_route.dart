import 'package:flutter/material.dart';

/// Slide-up + fade transition. Used for all primary navigation pushes.
class SlideUpRoute<T> extends PageRouteBuilder<T> {
  SlideUpRoute({required Widget page})
      : super(
          transitionDuration: const Duration(milliseconds: 380),
          reverseTransitionDuration: const Duration(milliseconds: 300),
          pageBuilder: (_, __, ___) => page,
          transitionsBuilder: (_, animation, secondaryAnimation, child) {
            final slide = Tween<Offset>(
              begin: const Offset(0, 0.05),
              end: Offset.zero,
            ).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeOutCubic));

            final fade = CurvedAnimation(parent: animation, curve: Curves.easeOut);

            // Outgoing screen gently dims + nudges up
            final secondarySlide = Tween<Offset>(
              begin: Offset.zero,
              end: const Offset(0, -0.03),
            ).animate(CurvedAnimation(
                parent: secondaryAnimation, curve: Curves.easeIn));

            final secondaryFade =
                Tween<double>(begin: 1.0, end: 0.88).animate(
              CurvedAnimation(parent: secondaryAnimation, curve: Curves.easeIn),
            );

            return SlideTransition(
              position: secondarySlide,
              child: FadeTransition(
                opacity: secondaryFade,
                child: FadeTransition(
                  opacity: fade,
                  child: SlideTransition(position: slide, child: child),
                ),
              ),
            );
          },
        );
}

/// Pure fade transition. Used for the order confirmation screen.
class FadeRoute<T> extends PageRouteBuilder<T> {
  FadeRoute({required Widget page})
      : super(
          transitionDuration: const Duration(milliseconds: 500),
          reverseTransitionDuration: const Duration(milliseconds: 300),
          pageBuilder: (_, __, ___) => page,
          transitionsBuilder: (_, animation, __, child) => FadeTransition(
            opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
            child: child,
          ),
        );
}
