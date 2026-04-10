import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/scroll_reveal.dart';

class MenuSection extends StatefulWidget {
  const MenuSection({super.key});

  @override
  State<MenuSection> createState() => _MenuSectionState();
}

class _MenuSectionState extends State<MenuSection>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  static const _tabs = [
    'Breakfast',
    'Tandoori Fusion',
    'Biryani & Rice',
    'Chinese',
    'Beverages',
  ];

  static const _menuItems = {
    'Breakfast': [
      _MenuItem('Halwa Puri Set', 'Semolina halwa with crispy puri & channa', 'AED 22', false, false),
      _MenuItem('Egg Bhurji', 'Spiced scrambled eggs with onion & chilli', 'AED 18', true, false),
      _MenuItem('Nihari', 'Slow-cooked beef stew with ginger & spices', 'AED 38', true, false),
      _MenuItem('Paye (Trotters)', 'Traditional slow-cooked hoof soup', 'AED 42', false, false),
      _MenuItem('Aloo Paratha', 'Stuffed potato flatbread with butter & lassi', 'AED 16', false, true),
      _MenuItem('Channa Masala', 'Spiced chickpea curry with garlic naan', 'AED 20', false, true),
    ],
    'Tandoori Fusion': [
      _MenuItem('Tandoori Bonfire Pizza', 'Chicken, capsicum, bonfire sauce', 'AED 48', true, false),
      _MenuItem('Seekh Kebab Platter', 'Minced beef seekh with chutney & salad', 'AED 45', true, false),
      _MenuItem('Chicken Tikka Boti', 'Marinated chunks grilled in tandoor', 'AED 40', true, false),
      _MenuItem('Tandoori Naan Platter', 'Assorted naans with dips', 'AED 28', false, true),
      _MenuItem('Reshmi Kebab', 'Creamy chicken kebab with signature spice', 'AED 42', false, false),
      _MenuItem('Chapli Kebab', 'Peshawar-style flat beef patty', 'AED 38', true, false),
    ],
    'Biryani & Rice': [
      _MenuItem('Dum Biryani Royale', 'Saffron rice with tender meat, slow-cooked', 'AED 52', false, false),
      _MenuItem('Chicken Biryani', 'Fragrant basmati with spiced chicken', 'AED 42', false, false),
      _MenuItem('Mutton Karahi', 'Classic wok-fried mutton in tomato gravy', 'AED 65', true, false),
      _MenuItem('Vegetable Biryani', 'Aromatic rice with seasonal vegetables', 'AED 32', false, true),
      _MenuItem('White Rice & Dal', 'Steamed rice with slow-cooked lentils', 'AED 22', false, true),
      _MenuItem('Pilau Rice', 'Fragrant jeera pilau, standalone or pairing', 'AED 18', false, true),
    ],
    'Chinese': [
      _MenuItem('Chicken Fried Rice', 'Wok-tossed rice with egg & vegetables', 'AED 32', false, false),
      _MenuItem('Beef Chow Mein', 'Stir-fried noodles with beef & peppers', 'AED 36', false, false),
      _MenuItem('Sweet & Sour Chicken', 'Crispy chicken in tangy sauce', 'AED 38', false, false),
      _MenuItem('Manchurian', 'Crispy balls in spicy soy sauce', 'AED 32', true, true),
      _MenuItem('Spring Rolls (6pc)', 'Crispy vegetable spring rolls', 'AED 22', false, true),
      _MenuItem('Chicken Soup', 'Clear broth with chicken & noodles', 'AED 20', false, false),
    ],
    'Beverages': [
      _MenuItem('Mango Lassi', 'Chilled yogurt with ripe Alphonso mango', 'AED 14', false, true),
      _MenuItem('Fresh Lemon Mint', 'Squeezed lemon with fresh mint & soda', 'AED 12', false, true),
      _MenuItem('Pakistani Chai', 'Traditional doodh pati with cardamom', 'AED 8', false, true),
      _MenuItem('Rooh Afza Sherbet', 'Chilled rose & herb drink', 'AED 10', false, true),
      _MenuItem('Fresh Juices', 'Orange, Watermelon, or Mixed Fruit', 'AED 14', false, true),
      _MenuItem('Cold Coffee', 'Blended coffee with cream & ice', 'AED 16', false, true),
    ],
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _tabController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final isMobile = w < 768;

    return Container(
      color: AppColors.charcoal,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 0 : 80,
        vertical: isMobile ? 60 : 100,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: isMobile ? 24 : 0),
            child: ScrollReveal(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('EXPLORE OUR MENU', style: AppTextStyles.label),
                  const SizedBox(height: 12),
                  Text(
                    'Fresh from Our Kitchen',
                    style: isMobile
                        ? AppTextStyles.sectionTitleMobile
                        : AppTextStyles.sectionTitle,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'From dawn to midnight — every craving covered.',
                    style: GoogleFonts.montserrat(
                      fontSize: 15,
                      color: AppColors.warmBone.withOpacity(0.5),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 40),
          _buildTabBar(isMobile),
          const SizedBox(height: 32),
          _buildLegend(isMobile),
          const SizedBox(height: 24),
          _buildTabView(isMobile),
        ],
      ),
    );
  }

  Widget _buildTabBar(bool isMobile) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 24 : 0),
      child: Row(
        children: List.generate(_tabs.length, (i) {
          final selected = _tabController.index == i;
          return GestureDetector(
            onTap: () => _tabController.animateTo(i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(right: 8),
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 11),
              decoration: BoxDecoration(
                color: selected ? AppColors.saffron : AppColors.darkCard,
                borderRadius: BorderRadius.circular(50),
                border: Border.all(
                  color: selected
                      ? AppColors.saffron
                      : AppColors.glassBorder,
                ),
              ),
              child: Text(
                _tabs[i],
                style: GoogleFonts.montserrat(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: selected
                      ? Colors.white
                      : AppColors.warmBone.withOpacity(0.6),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildLegend(bool isMobile) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 24 : 0),
      child: Row(
        children: [
          _LegendItem(
              color: Colors.redAccent,
              icon: Icons.local_fire_department,
              label: 'Spicy'),
          const SizedBox(width: 20),
          _LegendItem(
              color: Colors.green,
              icon: Icons.eco_rounded,
              label: 'Vegetarian'),
        ],
      ),
    );
  }

  Widget _buildTabView(bool isMobile) {
    // TabBarView requires a bounded height (it is a horizontal viewport), which
    // is unavailable inside a SingleChildScrollView Column. Use AnimatedSwitcher
    // instead — it has no viewport and works with unbounded height.
    final tab = _tabs[_tabController.index];
    final items = _menuItems[tab] ?? [];

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 280),
      switchInCurve: Curves.easeOut,
      switchOutCurve: Curves.easeIn,
      transitionBuilder: (child, animation) => FadeTransition(
        opacity: animation,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.04, 0),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        ),
      ),
      child: KeyedSubtree(
        key: ValueKey(tab),
        child: isMobile
            ? Column(
                children: List.generate(
                  items.length,
                  (i) => _MenuListItem(item: items[i], isMobile: true),
                ),
              )
            : GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 4.5,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 4,
                ),
                itemCount: items.length,
                itemBuilder: (_, i) =>
                    _MenuListItem(item: items[i], isMobile: false),
              ),
      ),
    );
  }
}

class _MenuListItem extends StatefulWidget {
  final _MenuItem item;
  final bool isMobile;
  const _MenuListItem({required this.item, required this.isMobile});

  @override
  State<_MenuListItem> createState() => _MenuListItemState();
}

class _MenuListItemState extends State<_MenuListItem> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: EdgeInsets.symmetric(
          horizontal: widget.isMobile ? 24 : 0,
          vertical: 4,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: _hovered
              ? AppColors.darkCard
              : AppColors.darkCard.withOpacity(0.5),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _hovered
                ? AppColors.saffron.withOpacity(0.3)
                : Colors.transparent,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          item.name,
                          style: GoogleFonts.montserrat(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.warmBone,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (item.isSpicy)
                        Icon(Icons.local_fire_department,
                            color: Colors.redAccent, size: 15),
                      if (item.isVeg)
                        Icon(Icons.eco_rounded,
                            color: Colors.green, size: 15),
                    ],
                  ),
                  if (item.description.isNotEmpty) ...[
                    const SizedBox(height: 3),
                    Text(
                      item.description,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.montserrat(
                        fontSize: 12,
                        color: AppColors.warmBone.withOpacity(0.45),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 12),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              decoration: BoxDecoration(
                color: AppColors.saffron.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                    color: AppColors.saffron.withOpacity(0.3)),
              ),
              child: Text(
                item.price,
                style: GoogleFonts.montserrat(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.saffron,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String label;
  const _LegendItem(
      {required this.color, required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: color, size: 16),
        const SizedBox(width: 5),
        Text(
          label,
          style: GoogleFonts.montserrat(
            fontSize: 12,
            color: AppColors.warmBone.withOpacity(0.5),
          ),
        ),
      ],
    );
  }
}

class _MenuItem {
  final String name;
  final String description;
  final String price;
  final bool isSpicy;
  final bool isVeg;
  const _MenuItem(
      this.name, this.description, this.price, this.isSpicy, this.isVeg);
}
