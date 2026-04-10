import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/datasources/menu_local_datasource.dart';
import '../../data/repositories/menu_repository_impl.dart';
import '../../domain/usecases/get_dishes_by_category.dart';
import '../../domain/entities/dish.dart';
import '../../../cart/presentation/providers/cart_provider.dart';
import '../../../../core/widgets/app_page_route.dart';
import '../../../../core/widgets/cart_badge.dart';
import '../widgets/dish_card.dart';
import '../../../../core/widgets/quantity_selector.dart';
import '../../../cart/presentation/pages/cart_page.dart';

class DishDetailPage extends StatefulWidget {
  final Dish dish;
  const DishDetailPage({super.key, required this.dish});

  @override
  State<DishDetailPage> createState() => _DishDetailPageState();
}

class _DishDetailPageState extends State<DishDetailPage>
    with TickerProviderStateMixin {
  late AnimationController _visualCtrl;
  late Animation<double> _visualScale;
  late Animation<double> _visualFade;

  late AnimationController _infoCtrl;
  late Animation<Offset> _infoSlide;
  late Animation<double> _infoFade;

  late AnimationController _addCtrl;
  late Animation<double> _addScale;

  // "Added" confirmation state
  bool _showAdded = false;
  int _localQty = 1;
  bool _cartInitialized = false;

  @override
  void initState() {
    super.initState();

    _visualCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 550),
    );
    _visualScale = Tween<double>(begin: 0.80, end: 1.0).animate(
      CurvedAnimation(parent: _visualCtrl, curve: Curves.easeOutBack),
    );
    _visualFade = CurvedAnimation(parent: _visualCtrl, curve: Curves.easeOut);

    _infoCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _infoSlide = Tween<Offset>(
      begin: const Offset(0, 0.12),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _infoCtrl, curve: Curves.easeOutCubic));
    _infoFade = CurvedAnimation(parent: _infoCtrl, curve: Curves.easeOut);

    _addCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _addScale = Tween<double>(begin: 1.0, end: 0.94)
        .animate(CurvedAnimation(parent: _addCtrl, curve: Curves.easeOut));

    // Stagger entry animations
    _visualCtrl.forward();
    Future.delayed(const Duration(milliseconds: 150), () {
      if (mounted) _infoCtrl.forward();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_cartInitialized) {
      _cartInitialized = true;
      final qty = CartProvider.of(context).quantityOf(widget.dish.id);
      if (qty > 0) _localQty = qty;
    }
  }

  @override
  void dispose() {
    _visualCtrl.dispose();
    _infoCtrl.dispose();
    _addCtrl.dispose();
    super.dispose();
  }

  void _addToCart() async {
    final cart = CartProvider.of(context);
    cart.add(widget.dish, qty: _localQty);
    _addCtrl.forward();
    setState(() => _showAdded = true);
    await Future.delayed(const Duration(milliseconds: 1400));
    if (mounted) {
      _addCtrl.reverse();
      setState(() => _showAdded = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final dish = widget.dish;
    final isMobile = MediaQuery.of(context).size.width < 768;
    final cart = CartProvider.of(context);

    return Scaffold(
      backgroundColor: AppColors.charcoal,
      body: CustomScrollView(
        slivers: [
          // ── SliverAppBar with dish visual ───────────────────────────────
          SliverAppBar(
            expandedHeight: isMobile ? 300 : 360,
            pinned: true,
            backgroundColor: dish.gradientColors.last,
            leading: Padding(
              padding: const EdgeInsets.all(8),
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.35),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.arrow_back_ios_new_rounded,
                      color: Colors.white, size: 18),
                ),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 12, top: 4),
                child: GestureDetector(
                  onTap: () => Navigator.push(
                      context, SlideUpRoute(page: const CartPage())),
                  child: CartBadge(
                    count: cart.totalCount,
                    child: Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.35),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.shopping_bag_outlined,
                          color: Colors.white, size: 18),
                    ),
                  ),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: _buildVisual(dish),
            ),
          ),

          // ── Info panel ─────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: SlideTransition(
              position: _infoSlide,
              child: FadeTransition(
                opacity: _infoFade,
                child: _buildInfoPanel(dish, isMobile),
              ),
            ),
          ),

          // ── Related dishes ─────────────────────────────────────────────
          SliverToBoxAdapter(
            child: FadeTransition(
              opacity: _infoFade,
              child: _buildRelated(dish, isMobile),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 120)),
        ],
      ),
      // ── Sticky bottom bar ───────────────────────────────────────────────
      bottomNavigationBar: _buildBottomBar(isMobile),
    );
  }

  Widget _buildVisual(Dish dish) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            dish.gradientColors[0],
            dish.gradientColors[1],
          ],
        ),
      ),
      child: Center(
        child: ScaleTransition(
          scale: _visualScale,
          child: FadeTransition(
            opacity: _visualFade,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 60),
                Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.12),
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: Colors.white.withOpacity(0.2), width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: dish.gradientColors[0].withOpacity(0.5),
                        blurRadius: 40,
                        spreadRadius: 10,
                      )
                    ],
                  ),
                  child: Icon(dish.icon, color: Colors.white, size: 72),
                ),
                const SizedBox(height: 20),
                Text(
                  dish.category.label,
                  style: GoogleFonts.montserrat(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Colors.white.withOpacity(0.6),
                    letterSpacing: 2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoPanel(Dish dish, bool isMobile) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 40,
        vertical: 28,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Name + price row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  dish.name,
                  style: GoogleFonts.playfairDisplay(
                    fontSize: isMobile ? 26 : 32,
                    fontWeight: FontWeight.w700,
                    color: AppColors.warmBone,
                    height: 1.15,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Text(
                dish.priceLabel,
                style: GoogleFonts.playfairDisplay(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: AppColors.saffron,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          // Badges row
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: [
              _InfoChip(
                icon: Icons.access_time_rounded,
                label: dish.prepTime,
                color: Colors.blueAccent,
              ),
              if (dish.spiceLevel > 0)
                _InfoChip(
                  icon: Icons.local_fire_department_rounded,
                  label: ['Mild', 'Medium', 'Hot', 'Extra Hot'][dish.spiceLevel],
                  color: Colors.redAccent,
                ),
              if (dish.isVeg)
                _InfoChip(
                  icon: Icons.eco_rounded,
                  label: 'Vegetarian',
                  color: Colors.green,
                ),
            ],
          ),
          const SizedBox(height: 20),
          // Description
          Text(
            dish.longDescription,
            style: GoogleFonts.montserrat(
              fontSize: 14,
              color: AppColors.warmBone.withOpacity(0.7),
              height: 1.75,
            ),
          ),
          const SizedBox(height: 24),
          // Highlights
          Text(
            'HIGHLIGHTS',
            style: GoogleFonts.montserrat(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppColors.saffron,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: dish.highlights
                .map((h) => Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.saffron.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                            color: AppColors.saffron.withOpacity(0.3)),
                      ),
                      child: Text(
                        h,
                        style: GoogleFonts.montserrat(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppColors.warmBone,
                        ),
                      ),
                    ))
                .toList(),
          ),
          const SizedBox(height: 28),
          // Quantity selector
          Row(
            children: [
              Text(
                'Quantity',
                style: GoogleFonts.montserrat(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.warmBone.withOpacity(0.7),
                ),
              ),
              const SizedBox(width: 20),
              QuantitySelector(
                quantity: _localQty,
                onChanged: (v) => setState(() => _localQty = v),
                large: true,
                min: 1,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRelated(Dish dish, bool isMobile) {
    final related = GetDishesByCategory(
            MenuRepositoryImpl(MenuLocalDatasourceImpl()))(dish.category)
        .where((d) => d.id != dish.id)
        .take(4)
        .toList();
    if (related.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 20 : 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'YOU MIGHT ALSO LIKE',
            style: GoogleFonts.montserrat(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppColors.saffron,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 68,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: related.length,
              itemBuilder: (_, i) => Padding(
                padding: EdgeInsets.only(right: i < related.length - 1 ? 10 : 0),
                child: SizedBox(
                  width: 200,
                  child: DishCard(
                    dish: related[i],
                    compact: true,
                    onTap: () => Navigator.pushReplacement(
                      context,
                      SlideUpRoute(page: DishDetailPage(dish: related[i])),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(bool isMobile) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        isMobile ? 20 : 40,
        14,
        isMobile ? 20 : 40,
        MediaQuery.of(context).padding.bottom + 14,
      ),
      decoration: BoxDecoration(
        color: AppColors.charcoal,
        border: Border(
            top: BorderSide(color: AppColors.glassBorder)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, -4),
          )
        ],
      ),
      child: ScaleTransition(
        scale: _addScale,
        child: GestureDetector(
          onTapDown: (_) => _addCtrl.forward(),
          onTapUp: (_) {
            _addCtrl.reverse();
            if (!_showAdded) _addToCart();
          },
          onTapCancel: () => _addCtrl.reverse(),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            height: 56,
            decoration: BoxDecoration(
              color: _showAdded ? const Color(0xFF1B7A3E) : AppColors.saffron,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: (_showAdded
                          ? const Color(0xFF1B7A3E)
                          : AppColors.saffron)
                      .withOpacity(0.4),
                  blurRadius: 18,
                  offset: const Offset(0, 6),
                )
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  transitionBuilder: (child, anim) => ScaleTransition(
                    scale: CurvedAnimation(
                        parent: anim, curve: Curves.easeOutBack),
                    child: child,
                  ),
                  child: Icon(
                    _showAdded
                        ? Icons.check_circle_rounded
                        : Icons.shopping_bag_outlined,
                    key: ValueKey(_showAdded),
                    color: Colors.white,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 10),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: Text(
                    _showAdded
                        ? 'Added to Cart!'
                        : 'Add to Cart  •  ${widget.dish.priceLabel}',
                    key: ValueKey(_showAdded),
                    style: GoogleFonts.montserrat(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
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

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  const _InfoChip({required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: color),
          const SizedBox(width: 5),
          Text(
            label,
            style: GoogleFonts.montserrat(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
