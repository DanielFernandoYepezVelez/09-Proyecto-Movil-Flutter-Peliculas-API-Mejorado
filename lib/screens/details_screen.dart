import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

/* Models */
import 'package:peliculas_app/models/models.dart';

/* Widgets */
import 'package:peliculas_app/widgets/widgets.dart';

class DetailsScreen extends StatefulWidget {
  const DetailsScreen({Key? key}) : super(key: key);

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  BannerAd? bannerAd;
  BannerAd? bannerAdTwo;
  bool isLoaded = false;
  bool isLoadedTwo = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    bannerAd = BannerAd(
      size: AdSize.banner,
      adUnitId: "ca-app-pub-8802721251339887/6087297639",
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            isLoaded = true;
          });
          // print("Banner Ad Loaded");
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
        },
      ),
      request: AdRequest(),
    );

    bannerAd!.load();

    /* ---------------------------------------------- */

    bannerAdTwo = BannerAd(
      size: AdSize.banner,
      adUnitId: "ca-app-pub-8802721251339887/6087297639",
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            isLoadedTwo = true;
          });
          // print("Banner Ad Two Loaded");
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
        },
      ),
      request: AdRequest(),
    );

    bannerAdTwo!.load();
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
                isLoaded
                    ? Container(
                        height: 50,
                        child: AdWidget(ad: bannerAd!),
                      )
                    : SizedBox(),
                _Overview(movieOverview: movie),
                isLoadedTwo
                    ? Container(
                        height: 50,
                        child: AdWidget(ad: bannerAdTwo!),
                      )
                    : SizedBox(),
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
        titlePadding: EdgeInsets.all(0),
        title: Container(
          width: double.infinity,
          color: Colors.black12,
          alignment: Alignment.bottomCenter,
          padding: EdgeInsets.only(left: 10, right: 10, bottom: 5),
          child: Text(
            movieAppBar.title,
            style: TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ),
        background: FadeInImage(
          placeholder: AssetImage('assets/images/loading.gif'),
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
      margin: EdgeInsets.only(top: 20, bottom: 10),
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Hero(
            tag: this.moviePoster.heroAnimationID!,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: FadeInImage(
                height: 160,
                placeholder: AssetImage('assets/images/no-image.jpg'),
                image: NetworkImage(this.moviePoster.getPosterImg()),
              ),
            ),
          ),
          SizedBox(width: 20),
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: sizeWidth.width - 190),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  this.moviePoster.title,
                  style: textTheme.headline5,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
                Text(
                  this.moviePoster.originalTitle,
                  style: textTheme.headline5,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
                Row(
                  children: [
                    Icon(Icons.star_outline, size: 15, color: Colors.grey),
                    SizedBox(width: 5),
                    Text(
                      '${this.moviePoster.voteAverage}',
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
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
          child: Text(
            this.movieOverview.overview,
            style: Theme.of(context).textTheme.subtitle1,
            textAlign: TextAlign.justify,
          ),
        ),
      ],
    );
  }
}
