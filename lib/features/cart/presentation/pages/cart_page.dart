import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/cart_item.dart';
import '../notifiers/cart_notifier.dart';
import '../providers/cart_provider.dart';
import '../../../../core/widgets/app_page_route.dart';
import '../../../../core/widgets/quantity_selector.dart';
import 'order_confirmation_page.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _entryCtrl;
  late Animation<double> _entryFade;

  bool _ordering = false;

  @override
  void initState() {
    super.initState();
    _entryCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    )..forward();
    _entryFade = CurvedAnimation(parent: _entryCtrl, curve: Curves.easeOut);
  }

  @override
  void dispose() {
    _entryCtrl.dispose();
    super.dispose();
  }

  Future<void> _placeOrder(CartNotifier cart) async {
    setState(() => _ordering = true);
    await Future.delayed(const Duration(milliseconds: 1600));
    if (!mounted) return;
    cart.clear();
    Navigator.pushReplacement(
        context, FadeRoute(page: const OrderConfirmationPage()));
  }

  @override
  Widget build(BuildContext context) {
    final cart = CartProvider.of(context);
    final items = cart.items;
    final isMobile = MediaQuery.of(context).size.width < 768;

    return Scaffold(
      backgroundColor: AppColors.charcoal,
      appBar: AppBar(
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
            'Your Order',
            style: GoogleFonts.playfairDisplay(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: AppColors.warmBone,
            ),
          ),
        ),
        actions: [
          if (items.isNotEmpty)
            TextButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => _ClearDialog(onConfirm: cart.clear),
                );
              },
              child: Text(
                'Clear',
                style: GoogleFonts.montserrat(
                  color: AppColors.warmBone.withOpacity(0.5),
                  fontSize: 13,
                ),
              ),
            ),
        ],
      ),
      body: FadeTransition(
        opacity: _entryFade,
        child: items.isEmpty
            ? _buildEmpty()
            : _buildCartContent(items, cart, isMobile),
      ),
      bottomNavigationBar: items.isEmpty
          ? null
          : _buildPlaceOrderBar(cart, isMobile),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: AppColors.darkCard,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.glassBorder),
            ),
            child: Icon(Icons.shopping_bag_outlined,
                size: 48, color: AppColors.warmBone.withOpacity(0.25)),
          ),
          const SizedBox(height: 20),
          Text(
            'Your cart is empty',
            style: GoogleFonts.playfairDisplay(
              fontSize: 22,
              color: AppColors.warmBone,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add dishes from our menu to get started',
            style: GoogleFonts.montserrat(
              fontSize: 13,
              color: AppColors.warmBone.withOpacity(0.4),
            ),
          ),
          const SizedBox(height: 32),
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
              decoration: BoxDecoration(
                color: AppColors.saffron,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Browse Menu',
                style: GoogleFonts.montserrat(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartContent(
      List<CartItem> items, CartNotifier cart, bool isMobile) {
    return ListView(
      padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 16 : 40, vertical: 16),
      children: [
        // Items
        ...List.generate(items.length, (i) {
          final item = items[i];
          return _CartItemTile(
            key: ValueKey(item.dish.id),
            item: item,
            index: i,
            onRemove: () => cart.remove(item.dish.id),
            onQuantityChanged: (q) => cart.setQuantity(item.dish.id, q),
          );
        }),
        const SizedBox(height: 24),
        // Order summary
        _OrderSummaryCard(cart: cart),
        const SizedBox(height: 100),
      ],
    );
  }

  Widget _buildPlaceOrderBar(CartNotifier cart, bool isMobile) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        isMobile ? 20 : 40,
        14,
        isMobile ? 20 : 40,
        MediaQuery.of(context).padding.bottom + 14,
      ),
      decoration: BoxDecoration(
        color: AppColors.charcoal,
        border: Border(top: BorderSide(color: AppColors.glassBorder)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, -4),
          )
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total',
                style: GoogleFonts.montserrat(
                  fontSize: 13,
                  color: AppColors.warmBone.withOpacity(0.6),
                ),
              ),
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: cart.total),
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeOut,
                builder: (_, v, __) => Text(
                  'AED ${v.toStringAsFixed(0)}',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: AppColors.saffron,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: _ordering ? null : () => _placeOrder(cart),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              height: 56,
              decoration: BoxDecoration(
                color: _ordering
                    ? AppColors.saffron.withOpacity(0.6)
                    : AppColors.saffron,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  if (!_ordering)
                    BoxShadow(
                      color: AppColors.saffron.withOpacity(0.4),
                      blurRadius: 18,
                      offset: const Offset(0, 6),
                    )
                ],
              ),
              child: Center(
                child: _ordering
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        'Place Order',
                        style: GoogleFonts.montserrat(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Cart Item Tile ───────────────────────────────────────────────────────────

class _CartItemTile extends StatefulWidget {
  final CartItem item;
  final int index;
  final VoidCallback onRemove;
  final ValueChanged<int> onQuantityChanged;

  const _CartItemTile({
    super.key,
    required this.item,
    required this.index,
    required this.onRemove,
    required this.onQuantityChanged,
  });

  @override
  State<_CartItemTile> createState() => _CartItemTileState();
}

class _CartItemTileState extends State<_CartItemTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _fade;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: const Offset(0.06, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));

    Future.delayed(Duration(milliseconds: 50 * widget.index), () {
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
    final dish = widget.item.dish;
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: Dismissible(
          key: ValueKey(dish.id),
          direction: DismissDirection.endToStart,
          background: Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.redAccent.withOpacity(0.15),
              borderRadius: BorderRadius.circular(16),
            ),
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            child: const Icon(Icons.delete_outline_rounded,
                color: Colors.redAccent, size: 26),
          ),
          onDismissed: (_) => widget.onRemove(),
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.darkCard,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.glassBorder),
            ),
            child: Row(
              children: [
                // Icon
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: dish.gradientColors,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(dish.icon, color: Colors.white, size: 28),
                ),
                const SizedBox(width: 14),
                // Name + desc
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        dish.name,
                        style: GoogleFonts.montserrat(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.warmBone,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 3),
                      Text(
                        dish.priceLabel + ' each',
                        style: GoogleFonts.montserrat(
                          fontSize: 12,
                          color: AppColors.warmBone.withOpacity(0.45),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                // Quantity + subtotal
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    QuantitySelector(
                      quantity: widget.item.quantity,
                      onChanged: widget.onQuantityChanged,
                      min: 0,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'AED ${widget.item.subtotal.toStringAsFixed(0)}',
                      style: GoogleFonts.montserrat(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.saffron,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Order Summary Card ───────────────────────────────────────────────────────

class _OrderSummaryCard extends StatelessWidget {
  final CartNotifier cart;
  const _OrderSummaryCard({required this.cart});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'ORDER SUMMARY',
            style: GoogleFonts.montserrat(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppColors.saffron,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 16),
          _SummaryRow('Subtotal', 'AED ${cart.subtotal.toStringAsFixed(0)}'),
          const SizedBox(height: 8),
          _SummaryRow('Delivery', 'AED ${cart.deliveryFee.toStringAsFixed(0)}'),
          const SizedBox(height: 16),
          Container(height: 1, color: AppColors.glassBorder),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total',
                style: GoogleFonts.montserrat(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.warmBone,
                ),
              ),
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: cart.total),
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeOut,
                builder: (_, v, __) => Text(
                  'AED ${v.toStringAsFixed(0)}',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: AppColors.saffron,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Icon(Icons.location_on_rounded,
                  size: 14, color: AppColors.warmBone.withOpacity(0.4)),
              const SizedBox(width: 5),
              Text(
                'Warsan First, Persia Cluster, Dubai',
                style: GoogleFonts.montserrat(
                  fontSize: 11,
                  color: AppColors.warmBone.withOpacity(0.4),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  const _SummaryRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: GoogleFonts.montserrat(
                fontSize: 13,
                color: AppColors.warmBone.withOpacity(0.5))),
        Text(value,
            style: GoogleFonts.montserrat(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.warmBone)),
      ],
    );
  }
}

// ─── Clear Dialog ─────────────────────────────────────────────────────────────

class _ClearDialog extends StatelessWidget {
  final VoidCallback onConfirm;
  const _ClearDialog({required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.darkCard,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text('Clear cart?',
          style: GoogleFonts.playfairDisplay(
              color: AppColors.warmBone,
              fontSize: 20,
              fontWeight: FontWeight.w700)),
      content: Text('All items will be removed.',
          style: GoogleFonts.montserrat(
              color: AppColors.warmBone.withOpacity(0.6), fontSize: 13)),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel',
              style: GoogleFonts.montserrat(
                  color: AppColors.warmBone.withOpacity(0.5))),
        ),
        TextButton(
          onPressed: () {
            onConfirm();
            Navigator.pop(context);
          },
          child: Text('Clear',
              style: GoogleFonts.montserrat(
                  color: Colors.redAccent, fontWeight: FontWeight.w700)),
        ),
      ],
    );
  }
}
