import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

/* Movies Provider */
import 'package:movies_api_flutter/providers/movies_provider.dart';

/* Actor Provider */
// import 'package:peliculas_app/providers/actor_provider.dart';

/* Models */
import 'package:movies_api_flutter/models/models.dart';

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
          return const SizedBox(
            height: 180,
            child: CupertinoActivityIndicator(),
          );
        }

        /* Aqui Siempre Me Va A LLegar Información */
        final List<Cast> cast = snapshot.data!;

        return Container(
          margin: const EdgeInsets.only(bottom: 30, top: 10),
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
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      width: 110,
      height: 100,
      // color: Colors.deepPurple,
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(
                context,
                'actor',
                arguments: widget.actor.id,
              );
            },
            child: Hero(
              tag: 'actor-${widget.actor.id}-1',
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: FadeInImage(
                  width: 100,
                  height: 140,
                  fit: BoxFit.cover,
                  placeholder: const AssetImage('assets/images/no-image.jpg'),
                  image: NetworkImage(widget.actor.getProfilePath()),
                ),
              ),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            widget.actor.name,
            maxLines: 2,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
