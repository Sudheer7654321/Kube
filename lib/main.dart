import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:kube/pages/authentication/login_page.dart';
import 'package:kube/pages/cards/cards_main.dart';
import 'package:kube/pages/cards/cards_state.dart';
import 'package:kube/pages/crypto/crypto_page.dart';
import 'package:kube/pages/home/home_page.dart';
import 'package:kube/pages/investments/investments_page.dart';
import 'package:kube/pages/menu/menu_screen.dart';
import 'package:kube/pages/settings1/settings_screen.dart';
import 'package:kube/pages/stock/Orders_screen/order_provider.dart';
import 'package:kube/pages/stock/stock_bottom_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:kube/pages/stock/wishlist/wishlist_model.dart';
import 'package:kube/pages/upi/upi_navigation_bar.dart';
import 'package:kube/pages/pin/pin_page.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AppState()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
        ChangeNotifierProvider(create: (_) => WishListProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kube',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        //colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
      ),
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          if (snapshot.hasData) {
            return PinPage();
          }
          return LoginPage();
        },
      ),
    );
  }
}

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> with TickerProviderStateMixin {
  final ZoomDrawerController _zoomDrawerController = ZoomDrawerController();
  String currentPage = 'Dashboard';
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Widget getCurrentScreen() {
    Widget screen;
    switch (currentPage) {
      case 'Dashboard':
        screen = DashboardPage();
        break;
      case 'Cards':
        screen = CardPage();
        break;
      case 'Crypto':
        screen = CryptoPage();
        break;
      case 'Stocks':
        screen = StockNavigationBar();
        break;
      case 'Investments':
        screen = InvestmentsPage();
        break;
      case 'UPI & Payments':
        screen = UpiNavigationBar();
        break;
      case 'Settings':
        screen = SettingsScreen();
        break;
      default:
        screen = UpiNavigationBar();
    }

    return Container(key: ValueKey(currentPage), child: screen);
  }

  void onPageChanged(String pageName) {
    if (currentPage != pageName) {
      setState(() {
        currentPage = pageName;
      });
      _zoomDrawerController.close!();
      _animationController.forward(from: 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF263238), Color(0xFF37474F), Color(0xFF90A4AE)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: ZoomDrawer(
        controller: _zoomDrawerController,
        menuBackgroundColor: Colors.transparent,
        menuScreen: MenuScreen(
          onPageChanged: onPageChanged,
          currentPage: currentPage,
        ),
        mainScreen: AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          switchInCurve: Curves.easeInOut,
          switchOutCurve: Curves.easeInOut,
          transitionBuilder: (Widget child, Animation<double> animation) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1.0, 0.0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            );
          },
          child: getCurrentScreen(),
        ),
        angle: 0.0,
        showShadow: true,
        shrinkMainScreen: false,
        openCurve: Curves.easeInOutBack,
        slideWidth: MediaQuery.of(context).size.width * .7,
        mainScreenTapClose: true,
        shadowLayer1Color: Colors.grey.shade700,
        shadowLayer2Color: Colors.grey.shade800,
      ),
    );
  }
}
