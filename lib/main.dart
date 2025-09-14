// lib/main.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:my_shop_simple/core/theme/cubit/theme_cubit.dart';
import 'package:my_shop_simple/features/auth/auth_bloc.dart';
import 'package:my_shop_simple/features/auth/auth_event.dart';
import 'package:my_shop_simple/features/auth/auth_page.dart';
import 'package:my_shop_simple/features/auth/auth_state.dart';
import 'package:my_shop_simple/features/cart/cart_bloc.dart';
import 'package:my_shop_simple/features/cart/cart_page.dart';
import 'package:my_shop_simple/features/cart/cart_repository.dart';
import 'package:my_shop_simple/features/products/products_bloc.dart';
import 'package:my_shop_simple/features/products/products_page.dart';
import 'package:my_shop_simple/features/wishlist/wishlist_bloc.dart';
import 'package:my_shop_simple/features/wishlist/wishlist_page.dart';
import 'package:my_shop_simple/features/wishlist/wishlist_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Hive.initFlutter();
  await Hive.openBox<int>('cart');
  await Hive.openBox<int>('wishlist');
  await Hive.openBox<String>('products_cache');

  // auto login for integration test
  if (kDebugMode && bool.fromEnvironment('INTEGRATION_TEST')) {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: 'test@example.com',
        password: '123456',
      );
      print('Auto-login successful');
    } catch (e) {
      print('Auto-login failed: $e');
    }
  }

  runApp(const MyShopApp());
}

class MyShopApp extends StatelessWidget {
  const MyShopApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(create: (_) => AuthBloc()..add(AuthCheckRequested())),
        BlocProvider<ProductsBloc>(create: (_) => ProductsBloc()),
        BlocProvider<CartBloc>(create: (_) => CartBloc(CartRepository())),
        BlocProvider<WishlistBloc>(create: (_) => WishlistBloc(WishlistRepository())),
        BlocProvider<ThemeCubit>(create: (_) => ThemeCubit()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (_, mode) => MaterialApp(
          title: 'MyShop Firebase',
          debugShowCheckedModeBanner: false,
          theme: ThemeData.light(useMaterial3: true),
          darkTheme: ThemeData.dark(useMaterial3: true),
          themeMode: mode,
          home: BlocBuilder<AuthBloc, AuthState>(
            builder: (_, state) =>
                state is AuthAuthenticated ? const ProductsPage() : const AuthPage(),
          ),
          routes: {
            '/products': (_) => const ProductsPage(),
            '/cart': (_) => const CartPage(),
            '/wishlist': (_) => const WishlistPage(),
          },
        ),
      ),
    );
  }
}