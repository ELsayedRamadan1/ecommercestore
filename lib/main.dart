import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'src/injection.dart' as di;
import 'src/core/app_theme.dart';
import 'src/presentation/pages/login_page.dart';
import 'src/presentation/pages/home_page.dart';
import 'src/presentation/pages/cart_page.dart';
import 'src/presentation/pages/splash_page.dart';
import 'src/presentation/bloc/auth_cubit.dart';
import 'src/presentation/bloc/products_cubit.dart';
import 'src/presentation/bloc/cart_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => di.sl<AuthCubit>()..checkAutoLogin()),
        BlocProvider(create: (_) => di.sl<ProductsCubit>()),
        BlocProvider(create: (_) => di.sl<CartCubit>()),
        // ProductsCubit will be provided in HomePage by route builder using DI
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'متجر صغير',
        theme: AppTheme.light(),
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('ar')],
        locale: const Locale('ar'),
        // Force RTL
        builder: (context, child) => Directionality(textDirection: TextDirection.rtl, child: child!),
        routes: {
          '/': (_) => const RootPage(),
          '/home': (_) => const HomePage(),
          '/cart': (_) => const CartPage(),
        },
        initialRoute: '/splash',
        onGenerateRoute: (settings) {
          if (settings.name == '/splash') return MaterialPageRoute(builder: (_) => const SplashPage());
          return null;
        },
      ),
    );
  }
}

class RootPage extends StatelessWidget {
  const RootPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(builder: (context, state) {
      if (state is AuthAuthenticated) {
        return const HomePage();
      }
      if (state is AuthLoading) {
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      }
      return const LoginPage();
    });
  }
}
