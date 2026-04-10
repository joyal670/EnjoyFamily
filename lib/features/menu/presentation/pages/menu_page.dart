import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/datasources/menu_local_datasource.dart';
import '../../data/repositories/menu_repository_impl.dart';
import '../../domain/entities/dish.dart';
import '../../domain/usecases/get_all_dishes.dart';
import '../../domain/usecases/get_dishes_by_category.dart';
import '../../domain/usecases/search_dishes.dart';
import '../../../cart/presentation/notifiers/cart_notifier.dart';
import '../../../cart/presentation/providers/cart_provider.dart';
import '../../../../core/widgets/app_page_route.dart';
import '../../../../core/widgets/cart_badge.dart';
import '../widgets/dish_card.dart';
import 'dish_detail_page.dart';
import '../../../cart/presentation/pages/cart_page.dart';

class MenuPage extends StatefulWidget {
  final DishCategory? initialCategory;
  const MenuPage({super.key, this.initialCategory});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _entryCtrl;
  late Animation<double> _entryFade;
  late Animation<Offset> _entrySlide;

  DishCategory? _selectedCategory;
  String _searchQuery = '';
  final _searchCtrl = TextEditingController();
  bool _searchFocused = false;
  final _searchFocus = FocusNode();

  late final GetAllDishes _getAllDishes;
  late final GetDishesByCategory _getDishesByCategory;
  late final SearchDishes _searchDishesUC;

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.initialCategory;
    final repo = MenuRepositoryImpl(MenuLocalDatasourceImpl());
    _getAllDishes = GetAllDishes(repo);
    _getDishesByCategory = GetDishesByCategory(repo);
    _searchDishesUC = SearchDishes(repo);

    _entryCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..forward();
    _entryFade = CurvedAnimation(parent: _entryCtrl, curve: Curves.easeOut);
    _entrySlide = Tween<Offset>(
      begin: const Offset(0, -0.04),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _entryCtrl, curve: Curves.easeOutCubic));

    _searchFocus.addListener(() {
      setState(() => _searchFocused = _searchFocus.hasFocus);
    });
  }

  @override
  void dispose() {
    _entryCtrl.dispose();
    _searchCtrl.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  List<Dish> get _displayedDishes {
    if (_searchQuery.isNotEmpty) return _searchDishesUC(_searchQuery);
    if (_selectedCategory != null) return _getDishesByCategory(_selectedCategory!);
    return _getAllDishes();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;
    final cart = CartProvider.of(context);

    return Scaffold(
      backgroundColor: AppColors.charcoal,
      appBar: _buildAppBar(cart, isMobile),
      body: Column(
        children: [
          // Search bar
          SlideTransition(
            position: _entrySlide,
            child: FadeTransition(
              opacity: _entryFade,
              child: _buildSearchBar(isMobile),
            ),
          ),
          // Category filter
          FadeTransition(
            opacity: _entryFade,
            child: _buildCategoryFilter(),
          ),
          // Grid
          Expanded(child: _buildDishGrid(isMobile)),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(CartNotifier cart, bool isMobile) {
    return AppBar(
      backgroundColor: AppColors.charcoal,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded,
            color: AppColors.warmBone, size: 20),
        onPressed: () => Navigator.pop(context),
      ),
      title: FadeTransition(
        opacity: _entryFade,
        child: Text(
          'Our Menu',
          style: GoogleFonts.playfairDisplay(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: AppColors.warmBone,
          ),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: GestureDetector(
            onTap: () =>
                Navigator.push(context, SlideUpRoute(page: const CartPage())),
            child: CartBadge(
              count: cart.totalCount,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.darkCard,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.glassBorder),
                ),
                child: const Icon(Icons.shopping_bag_outlined,
                    color: AppColors.warmBone, size: 20),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar(bool isMobile) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
          isMobile ? 16 : 24, 12, isMobile ? 16 : 24, 0),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        decoration: BoxDecoration(
          color: AppColors.darkCard,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: _searchFocused
                ? AppColors.saffron.withOpacity(0.6)
                : AppColors.glassBorder,
          ),
          boxShadow: _searchFocused
              ? [
                  BoxShadow(
                    color: AppColors.saffron.withOpacity(0.12),
                    blurRadius: 16,
                  )
                ]
              : [],
        ),
        child: TextField(
          controller: _searchCtrl,
          focusNode: _searchFocus,
          style: GoogleFonts.montserrat(
              color: AppColors.warmBone, fontSize: 14),
          decoration: InputDecoration(
            hintText: 'Search dishes…',
            hintStyle: GoogleFonts.montserrat(
              color: AppColors.warmBone.withOpacity(0.3),
              fontSize: 14,
            ),
            prefixIcon: Icon(Icons.search_rounded,
                color: AppColors.warmBone.withOpacity(0.4), size: 20),
            suffixIcon: _searchQuery.isNotEmpty
                ? GestureDetector(
                    onTap: () {
                      _searchCtrl.clear();
                      setState(() => _searchQuery = '');
                    },
                    child: Icon(Icons.close_rounded,
                        color: AppColors.warmBone.withOpacity(0.4), size: 18),
                  )
                : null,
            border: InputBorder.none,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 14, horizontal: 4),
          ),
          onChanged: (v) => setState(() => _searchQuery = v),
        ),
      ),
    );
  }

  Widget _buildCategoryFilter() {
    return SizedBox(
      height: 52,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: [
          _CategoryChip(
            label: 'All',
            icon: Icons.restaurant_rounded,
            selected: _selectedCategory == null && _searchQuery.isEmpty,
            onTap: () => setState(() {
              _selectedCategory = null;
              _searchQuery = '';
              _searchCtrl.clear();
            }),
          ),
          ...DishCategory.values.map((cat) => _CategoryChip(
                label: cat.label,
                icon: cat.tabIcon,
                selected: _selectedCategory == cat,
                onTap: () => setState(() {
                  _selectedCategory = cat;
                  _searchQuery = '';
                  _searchCtrl.clear();
                }),
              )),
        ],
      ),
    );
  }

  Widget _buildDishGrid(bool isMobile) {
    final dishes = _displayedDishes;
    final crossCount = isMobile ? 2 : 4;

    if (dishes.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off_rounded,
                color: AppColors.warmBone.withOpacity(0.2), size: 56),
            const SizedBox(height: 12),
            Text(
              'No dishes found',
              style: GoogleFonts.montserrat(
                color: AppColors.warmBone.withOpacity(0.4),
                fontSize: 15,
              ),
            ),
          ],
        ),
      );
    }

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 280),
      transitionBuilder: (child, anim) => FadeTransition(
        opacity: anim,
        child: child,
      ),
      child: GridView.builder(
        key: ValueKey('${_selectedCategory}-$_searchQuery'),
        padding: EdgeInsets.fromLTRB(
          isMobile ? 12 : 24,
          12,
          isMobile ? 12 : 24,
          100,
        ),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossCount,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: isMobile ? 0.75 : 0.80,
        ),
        itemCount: dishes.length,
        itemBuilder: (context, i) => _AnimatedDishCard(
          dish: dishes[i],
          index: i,
          onTap: () => Navigator.push(
            context,
            SlideUpRoute(page: DishDetailPage(dish: dishes[i])),
          ),
        ),
      ),
    );
  }
}

// ─── Staggered card entrance ──────────────────────────────────────────────────

class _AnimatedDishCard extends StatefulWidget {
  final Dish dish;
  final int index;
  final VoidCallback onTap;
  const _AnimatedDishCard(
      {required this.dish, required this.index, required this.onTap});

  @override
  State<_AnimatedDishCard> createState() => _AnimatedDishCardState();
}

class _AnimatedDishCardState extends State<_AnimatedDishCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _fade;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));

    final delay = Duration(milliseconds: (40 * (widget.index % 8)).clamp(0, 320));
    Future.delayed(delay, () {
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
        child: DishCard(dish: widget.dish, onTap: widget.onTap),
      ),
    );
  }
}

// ─── Category chip ────────────────────────────────────────────────────────────

class _CategoryChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;
  const _CategoryChip({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? AppColors.saffron : AppColors.darkCard,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? AppColors.saffron : AppColors.glassBorder,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 14,
              color: selected ? Colors.white : AppColors.warmBone.withOpacity(0.5),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: GoogleFonts.montserrat(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: selected
                    ? Colors.white
                    : AppColors.warmBone.withOpacity(0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
