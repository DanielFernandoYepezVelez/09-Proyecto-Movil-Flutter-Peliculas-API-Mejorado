import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

/* Movies Provider */
import 'package:peliculas_app/providers/movies_provider.dart';

/* Actor Provider */
// import 'package:peliculas_app/providers/actor_provider.dart';

/* Models */
import 'package:peliculas_app/models/models.dart';

class CastingCards extends StatelessWidget {
  final int movieId;

  const CastingCards({Key? key, required this.movieId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /* Aqui Puedo Mandar A LLamar Mi Provider Y Ejecutar La Petición Http De Actores. */
    /* Pero En Este Caso Vamos Hacer La Petición Combinada Entre El FutureBuilder Y El Provider */
    final moviesProvider = Provider.of<MoviesProvider>(context, listen: false);

    return FutureBuilder(
      future: moviesProvider.getMovieCast(movieId),
      builder: (_, AsyncSnapshot<List<Cast>> snapshot) {
        if (!snapshot.hasData) {
          return Container(
            height: 180,
            child: CupertinoActivityIndicator(),
          );
        }

        /* Aqui Siempre Me Va A LLegar Información */
        final List<Cast> cast = snapshot.data!;

        return Container(
          margin: EdgeInsets.only(bottom: 30, top: 10),
          width: double.infinity,
          height: 180,
          // color: Colors.blueGrey,
          child: ListView.builder(
            itemCount: cast.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (_, int index) => _CastCard(actor: cast[index]),
          ),
        );
      },
    );
  }
}

class _CastCard extends StatefulWidget {
  final Cast actor;

  const _CastCard({Key? key, required this.actor}) : super(key: key);

  @override
  State<_CastCard> createState() => _CastCardState();
}

class _CastCardState extends State<_CastCard> {
  InterstitialAd? interstitialAd;
  bool isLoading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    InterstitialAd.load(
      adUnitId: "ca-app-pub-8802721251339887/9475028243",
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          setState(() {
            this.isLoading = true;
            this.interstitialAd = ad;
          });
          // print('Ad Loaded');
        },
        onAdFailedToLoad: (error) {
          // print('InterstitialAd failed to load: $error');
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      width: 110,
      height: 100,
      // color: Colors.deepPurple,
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              if (this.isLoading) {
                this.interstitialAd!.show();
              }

              Navigator.pushNamed(context, 'actor',
                  arguments: this.widget.actor.id);
            },
            child: Hero(
              tag: 'actor-${this.widget.actor.id}-1',
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: FadeInImage(
                  width: 100,
                  height: 140,
                  fit: BoxFit.cover,
                  placeholder: AssetImage('assets/images/no-image.jpg'),
                  image: NetworkImage(this.widget.actor.getProfilePath()),
                ),
              ),
            ),
          ),
          SizedBox(height: 5),
          Text(
            this.widget.actor.name,
            maxLines: 2,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
