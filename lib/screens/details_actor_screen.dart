import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

/* Actor Provider */
import 'package:peliculas_app/providers/actor_provider.dart';

/* Actor Model */
import 'package:peliculas_app/models/models.dart';

class DetailsActorScreen extends StatefulWidget {
  const DetailsActorScreen({Key? key}) : super(key: key);

  @override
  State<DetailsActorScreen> createState() => _DetailsActorScreenState();
}

class _DetailsActorScreenState extends State<DetailsActorScreen> {
  BannerAd? bannerAd;
  bool isLoaded = false;

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
  }

  @override
  Widget build(BuildContext context) {
    /* Aqui Yo Estoy Seguro Que Siempre Voy A Recibir Datos (!) */
    final int actorId = ModalRoute.of(context)!.settings.arguments as int;
    final actorProvider = Provider.of<ActorProvider>(context, listen: false);

    return FutureBuilder(
      future: actorProvider.getActorInformation(actorId),
      builder: (_, AsyncSnapshot<PeopleResponse> snapshot) {
        if (!snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.black12,
              elevation: 0,
              centerTitle: true,
              title: Text(
                'Información No Disponible',
                style: TextStyle(
                  color: Colors.white38,
                ),
              ),
            ),
            body: Container(
              alignment: Alignment.center,
              child: CupertinoActivityIndicator(),
            ),
          );
        }

        /* Aqui Yo Estoy Seguro Que Siempre Voy A Recibir Datos (!) */
        final PeopleResponse actorInformation = snapshot.data!;

        return Scaffold(
          body: CustomScrollView(
            slivers: [
              _CustomAppBar(actor: actorInformation),
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    _PosterAndTitle(actor: actorInformation),
                    isLoaded
                        ? Container(
                            height: 50,
                            child: AdWidget(ad: bannerAd!),
                          )
                        : SizedBox(),
                    _Overview(actor: actorInformation),
                    SizedBox(height: 10),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _CustomAppBar extends StatelessWidget {
  final PeopleResponse actor;

  const _CustomAppBar({Key? key, required this.actor}) : super(key: key);

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
          color: Colors.black12,
          alignment: Alignment.bottomCenter,
          width: double.infinity,
          child: Text(this.actor.name, style: TextStyle(fontSize: 16)),
        ),
        background: FadeInImage(
          placeholder: AssetImage('assets/images/loading.gif'),
          image: NetworkImage(this.actor.getProfilePath()),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class _PosterAndTitle extends StatelessWidget {
  final PeopleResponse actor;

  const _PosterAndTitle({Key? key, required this.actor}) : super(key: key);

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
            tag: 'actor-${this.actor.id}-1',
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: FadeInImage(
                width: 110,
                height: 160,
                placeholder: AssetImage('assets/images/no-image.jpg'),
                image: NetworkImage(this.actor.getProfilePath()),
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
                  this.actor.name,
                  style: textTheme.headline5,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
                Text(
                  '${this.actor.birthday} / ${this.actor.deathday}',
                  style: textTheme.subtitle1,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
                Row(
                  children: [
                    Icon(Icons.place_outlined, size: 15, color: Colors.grey),
                    SizedBox(width: 5),
                    ConstrainedBox(
                      constraints:
                          BoxConstraints(maxWidth: sizeWidth.width - 210),
                      child: Text(
                        this.actor.placeOfBirth,
                        style: textTheme.caption,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _Overview extends StatefulWidget {
  final PeopleResponse actor;

  const _Overview({Key? key, required this.actor}) : super(key: key);

  @override
  State<_Overview> createState() => _OverviewState();
}

class _OverviewState extends State<_Overview> {
  BannerAd? bannerAdTwo;
  bool isLoadedTwo = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

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
    return this.widget.actor.biography.length > 0
        ? Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                child: Text(
                  this.widget.actor.biography,
                  style: Theme.of(context).textTheme.subtitle1,
                  textAlign: TextAlign.justify,
                ),
              ),
              isLoadedTwo
                  ? Container(
                      height: 50,
                      child: AdWidget(ad: bannerAdTwo!),
                    )
                  : SizedBox()
            ],
          )
        : SizedBox();
  }
}
