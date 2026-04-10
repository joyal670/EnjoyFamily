import 'package:flutter/material.dart';
import '../widgets/navbar.dart';
import '../widgets/hero_section.dart';
import '../widgets/signature_series.dart';
import '../widgets/why_us_section.dart';
import '../widgets/menu_section.dart';
import '../widgets/social_proof_section.dart';
import '../widgets/footer_section.dart';
import '../widgets/mobile_bottom_nav.dart';
import '../../../../core/widgets/scroll_reveal.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    return ScrollRevealProvider(
      scrollController: _scrollController,
      child: Scaffold(
        backgroundColor: const Color(0xFF1A1A1A),
        extendBodyBehindAppBar: true,
        appBar: isMobile
            ? null
            : PreferredSize(
                preferredSize: const Size.fromHeight(72),
                child: AppNavbar(scrollController: _scrollController),
              ),
        body: SingleChildScrollView(
          controller: _scrollController,
          child: const Column(
            children: [
              HeroSection(),
              SignatureSeriesSection(),
              WhyUsSection(),
              MenuSection(),
              SocialProofSection(),
              FooterSection(),
            ],
          ),
        ),
        bottomNavigationBar: isMobile ? const MobileBottomNav() : null,
      ),
    );
  }
}
