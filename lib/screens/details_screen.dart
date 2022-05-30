import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

/* Models */
import 'package:movies_api_flutter/models/models.dart';

/* Widgets */
import 'package:movies_api_flutter/widgets/widgets.dart';

class DetailsScreen extends StatefulWidget {
  const DetailsScreen({Key? key}) : super(key: key);

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  NativeAd? _nativeVideoAd2;
  bool _isLoadedVideoNative2 = false;

  @override
  void initState() {
    super.initState();
    _loadVideoNativeAd2();
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

  @override
  Widget build(BuildContext context) {
    /* Cambiar Por Una Instancia De Movie */
    /* final String movie = ModalRoute.of(context)?.settings.arguments.toString() ?? 'no-movie'; */
    final Movie movie = ModalRoute.of(context)!.settings.arguments as Movie;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _CustomAppBar(movieAppBar: movie),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                _PosterAndTitle(moviePoster: movie),
                Container(
                  height: 300,
                  child: !_isLoadedVideoNative2
                      ? FadeInImage(
                          placeholder: AssetImage('assets/images/giphy.gif'),
                          image: AssetImage('assets/images/giphy.gif'),
                        )
                      : AdWidget(ad: _nativeVideoAd2!),
                ),
                _Overview(movieOverview: movie),
                CastingCards(movieId: movie.id),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CustomAppBar extends StatelessWidget {
  final Movie movieAppBar;

  const _CustomAppBar({Key? key, required this.movieAppBar}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Colors.indigo,
      expandedHeight: 200,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        titlePadding: const EdgeInsets.all(0),
        title: Container(
          width: double.infinity,
          color: Colors.black12,
          alignment: Alignment.bottomCenter,
          padding: const EdgeInsets.only(left: 10, right: 10, bottom: 5),
          child: Text(
            movieAppBar.title,
            style: const TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ),
        background: FadeInImage(
          placeholder: const AssetImage('assets/images/loading.gif'),
          image: NetworkImage(movieAppBar.getBackgroundImg()),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class _PosterAndTitle extends StatelessWidget {
  final Movie moviePoster;

  const _PosterAndTitle({Key? key, required this.moviePoster})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sizeWidth = MediaQuery.of(context).size;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Container(
      margin: const EdgeInsets.only(top: 20, bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Hero(
            tag: moviePoster.heroAnimationID!,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: FadeInImage(
                height: 160,
                placeholder: const AssetImage('assets/images/no-image.jpg'),
                image: NetworkImage(moviePoster.getPosterImg()),
              ),
            ),
          ),
          const SizedBox(width: 20),
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: sizeWidth.width - 190),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  moviePoster.title,
                  style: textTheme.headline5,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
                Text(
                  moviePoster.originalTitle,
                  style: textTheme.headline5,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
                Row(
                  children: [
                    const Icon(Icons.star_outline,
                        size: 15, color: Colors.grey),
                    const SizedBox(width: 5),
                    Text(
                      '${moviePoster.voteAverage}',
                      style: textTheme.caption,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Overview extends StatelessWidget {
  final Movie movieOverview;

  const _Overview({Key? key, required this.movieOverview}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
          child: Text(
            movieOverview.overview,
            style: Theme.of(context).textTheme.subtitle1,
            textAlign: TextAlign.justify,
          ),
        ),
      ],
    );
  }
}
