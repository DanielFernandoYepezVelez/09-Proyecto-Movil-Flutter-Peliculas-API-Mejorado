import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

/* Actor Provider */
import 'package:movies_api_flutter/providers/actor_provider.dart';

/* Actor Model */
import 'package:movies_api_flutter/models/models.dart';

class DetailsActorScreen extends StatefulWidget {
  const DetailsActorScreen({Key? key}) : super(key: key);

  @override
  State<DetailsActorScreen> createState() => _DetailsActorScreenState();
}

class _DetailsActorScreenState extends State<DetailsActorScreen> {
  NativeAd? _nativeVideoAd;
  bool _isLoadedVideoNative = false;

  @override
  void initState() {
    super.initState();
    _loadVideoNativeAd();
  }

  void _loadVideoNativeAd() {
    _nativeVideoAd = NativeAd(
      // adUnitId: 'ca-app-pub-3940256099942544/1044960115',
      adUnitId: 'ca-app-pub-8702651755109746/9836788926',
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
              title: const Text(
                'Información No Disponible',
                style: TextStyle(
                  color: Colors.white38,
                ),
              ),
            ),
            body: Container(
              alignment: Alignment.center,
              child: const CupertinoActivityIndicator(),
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
                    Container(
                      height: 300,
                      child: !_isLoadedVideoNative
                          ? FadeInImage(
                              placeholder:
                                  AssetImage('assets/images/giphy.gif'),
                              image: AssetImage('assets/images/giphy.gif'),
                            )
                          : AdWidget(ad: _nativeVideoAd!),
                    ),
                    _Overview(actor: actorInformation),
                    const SizedBox(height: 10),
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
        titlePadding: const EdgeInsets.all(0),
        title: Container(
          color: Colors.black12,
          alignment: Alignment.bottomCenter,
          width: double.infinity,
          child: Text(actor.name, style: const TextStyle(fontSize: 16)),
        ),
        background: FadeInImage(
          placeholder: const AssetImage('assets/images/loading.gif'),
          image: NetworkImage(actor.getProfilePath()),
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
      margin: const EdgeInsets.only(top: 20, bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Hero(
            tag: 'actor-${actor.id}-1',
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: FadeInImage(
                width: 110,
                height: 160,
                placeholder: const AssetImage('assets/images/no-image.jpg'),
                image: NetworkImage(actor.getProfilePath()),
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
                  actor.name,
                  style: textTheme.headline5,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
                Text(
                  '${actor.birthday} / ${actor.deathday}',
                  style: textTheme.subtitle1,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
                Row(
                  children: [
                    const Icon(Icons.place_outlined,
                        size: 15, color: Colors.grey),
                    const SizedBox(width: 5),
                    ConstrainedBox(
                      constraints:
                          BoxConstraints(maxWidth: sizeWidth.width - 210),
                      child: Text(
                        actor.placeOfBirth,
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
  @override
  Widget build(BuildContext context) {
    return widget.actor.biography.isNotEmpty
        ? Column(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                child: Text(
                  widget.actor.biography,
                  style: Theme.of(context).textTheme.subtitle1,
                  textAlign: TextAlign.justify,
                ),
              ),
              /* isLoadedTwo
                  ? SizedBox(
                      height: 50,
                      child: AdWidget(ad: bannerAdTwo!),
                    )
                  : const SizedBox() */
            ],
          )
        : const SizedBox();
  }
}
