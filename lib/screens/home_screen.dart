import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

/* Movie Search (Buscador) */
import 'package:movies_api_flutter/search/search_delegete.dart';

/* Movies Provider */
import 'package:movies_api_flutter/providers/movies_provider.dart';

/* Widgets */
import 'package:movies_api_flutter/widgets/widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  NativeAd? _nativeVideoAd;
  bool _isLoadedVideoNative = false;

  NativeAd? _nativeVideoAd2;
  bool _isLoadedVideoNative2 = false;

  NativeAd? _nativeVideoAd3;
  bool _isLoadedVideoNative3 = false;

  @override
  void initState() {
    super.initState();
    _loadVideoNativeAd();
    _loadVideoNativeAd2();
    _loadVideoNativeAd3();
  }

  void _loadVideoNativeAd() {
    _nativeVideoAd = NativeAd(
      // adUnitId: 'ca-app-pub-3940256099942544/1044960115',
      adUnitId: 'ca-app-pub-2118916369098036/6746589133',
      factoryId: 'listTile',
      request: const AdRequest(),
      listener: NativeAdListener(onAdLoaded: (ad) {
        /* print('Video Ad Loaded Successfully'); */
        setState(() {
          _isLoadedVideoNative = true;
        });
      }, onAdFailedToLoad: (ad, error) {
        /* print(
            'Actually Ad Video Failed To Load ${error.message}, ${error.code}'); */
        ad.dispose();
      }),
    );

    _nativeVideoAd!.load();
  }

  void _loadVideoNativeAd2() {
    _nativeVideoAd2 = NativeAd(
      // adUnitId: 'ca-app-pub-3940256099942544/1044960115',
      adUnitId: 'ca-app-pub-2118916369098036/6746589133',
      factoryId: 'listTile',
      request: const AdRequest(),
      listener: NativeAdListener(onAdLoaded: (ad) {
        /* print('Video Ad Loaded Successfully'); */
        setState(() {
          _isLoadedVideoNative2 = true;
        });
      }, onAdFailedToLoad: (ad, error) {
        /* print(
            'Actually Ad Video Failed To Load ${error.message}, ${error.code}'); */
        ad.dispose();
      }),
    );

    _nativeVideoAd2!.load();
  }

  void _loadVideoNativeAd3() {
    _nativeVideoAd3 = NativeAd(
      // adUnitId: 'ca-app-pub-3940256099942544/1044960115',
      adUnitId: 'ca-app-pub-2118916369098036/6746589133',
      factoryId: 'listTile',
      request: const AdRequest(),
      listener: NativeAdListener(onAdLoaded: (ad) {
        /* print('Video Ad Loaded Successfully'); */
        setState(() {
          _isLoadedVideoNative3 = true;
        });
      }, onAdFailedToLoad: (ad, error) {
        /* print(
            'Actually Ad Video Failed To Load ${error.message}, ${error.code}'); */
        ad.dispose();
      }),
    );

    _nativeVideoAd3!.load();
  }

  @override
  Widget build(BuildContext context) {
    final moviesProvider = Provider.of<MoviesProvider>(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text('Peliculas En Cine'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search_outlined),
            onPressed: () =>
                showSearch(context: context, delegate: MovieSearchDelegate()),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CardSwiper(movies: moviesProvider.onDisplayMovies),
            Container(
              height: 300,
              child: !_isLoadedVideoNative
                  ? FadeInImage(
                      placeholder: AssetImage('assets/images/giphy.gif'),
                      image: AssetImage('assets/images/giphy.gif'),
                    )
                  : AdWidget(ad: _nativeVideoAd!),
            ),
            MovieSlider(
              categoryTitle: 'Populares',
              movies: moviesProvider.popularMovies,
              onNextPage: () => moviesProvider.getPopularMovies(),
            ),
            Container(
              height: 300,
              child: !_isLoadedVideoNative2
                  ? FadeInImage(
                      placeholder: AssetImage('assets/images/giphy.gif'),
                      image: AssetImage('assets/images/giphy.gif'),
                    )
                  : AdWidget(ad: _nativeVideoAd2!),
            ),
            MovieSlider(
              categoryTitle: 'Mejor Calificadas',
              movies: moviesProvider.topRateMovies,
              onNextPage: () => moviesProvider.getRateTopMovies(),
            ),
            Container(
              height: 300,
              child: !_isLoadedVideoNative3
                  ? FadeInImage(
                      placeholder: AssetImage('assets/images/giphy.gif'),
                      image: AssetImage('assets/images/giphy.gif'),
                    )
                  : AdWidget(ad: _nativeVideoAd3!),
            ),
            MovieSlider(
              categoryTitle: 'Próximos Lanzamientos',
              movies: moviesProvider.upcomingMovies,
              onNextPage: () => moviesProvider.getUpcomingMovies(),
            ),
          ],
        ),
      ),
    );
  }
}
