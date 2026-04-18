import 'package:familyresturant/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'core/service/visitor_service.dart';
import 'core/theme/app_theme.dart';
import 'features/cart/data/repositories/cart_repository_impl.dart';
import 'features/cart/domain/usecases/add_to_cart.dart';
import 'features/cart/domain/usecases/clear_cart.dart';
import 'features/cart/domain/usecases/remove_from_cart.dart';
import 'features/cart/domain/usecases/update_quantity.dart';
import 'features/cart/presentation/notifiers/cart_notifier.dart';
import 'features/cart/presentation/providers/cart_provider.dart';
import 'features/home/presentation/pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  VisitorService.logVisitor();

  final cartRepository = CartRepositoryImpl();
  final cartNotifier = CartNotifier(
    addToCart: AddToCart(cartRepository),
    removeFromCart: RemoveFromCart(cartRepository),
    updateQuantity: UpdateQuantity(cartRepository),
    clearCart: ClearCart(cartRepository),
    repository: cartRepository,
  );

  runApp(CartProvider(notifier: cartNotifier, child: EnjoyFamilyApp()));
}

class EnjoyFamilyApp extends StatelessWidget {
  const EnjoyFamilyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Family Restaurant — International City, Dubai',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      home: const HomePage(),
    );
  }
}
