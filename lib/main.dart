import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

/* Providers Personal */
import 'package:movies_api_flutter/providers/actor_provider.dart';
import 'package:movies_api_flutter/providers/movies_provider.dart';

/* Routes */
import 'package:movies_api_flutter/routes/routes.dart';

/* AppOpenAd? _appOpenAd;

Future<void> _loadAppOpenAd() async {
  await AppOpenAd.load(
    // adUnitId: 'ca-app-pub-3940256099942544/3419835294',
    adUnitId: 'ca-app-pub-2118916369098036/6225249921',
    request: const AdRequest(),
    adLoadCallback: AppOpenAdLoadCallback(
      onAdLoaded: (ad) {
        //print('Ad Is Loaded');
        _appOpenAd = ad;
        _appOpenAd!.show();
      },
      onAdFailedToLoad: (error) {
        //print('Ad Failed To Load ${error}');
        _appOpenAd?.dispose();
      },
    ),
    orientation: AppOpenAd.orientationPortrait,
  );
} */

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MobileAds.instance.initialize();
  // await _loadAppOpenAd();
  runApp(const AppState());
}

/* Este Es El Primer Widget Que Se va A Crear, Es Decir,
Después De Este Widget En Adelante, En Todos Los Widgets
Que Yo Quiera Tengo Acceso A Esta Misma Instancia De
MoviesProvider */
class AppState extends StatelessWidget {
  const AppState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MoviesProvider(), lazy: false),
        ChangeNotifierProvider(create: (_) => ActorProvider(), lazy: false),
      ],
      child: const MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Peliculas',
      initialRoute: 'home',
      routes: appRoutes,
      theme: ThemeData.dark().copyWith(
        appBarTheme: const AppBarTheme(
          color: Colors.indigo,
        ),
      ),
    );
  }
}
