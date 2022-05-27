import 'package:flutter/material.dart';

/* Widgets */
import 'package:card_swiper/card_swiper.dart';

/* Models */
import 'package:movies_api_flutter/models/models.dart';

class CardSwiper extends StatelessWidget {
  final List<Movie> movies;

  const CardSwiper({Key? key, required this.movies}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final platformSize = MediaQuery.of(context).size;

    /* Aplicando Un Loading */
    if (movies.isEmpty) {
      return SizedBox(
        width: double.infinity,
        height: platformSize.height * 0.5,
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    return SizedBox(
      // color: Colors.red,
      width: double.infinity,
      // height: 480,
      height: platformSize.height * 0.5,
      child: Swiper(
        itemCount: movies.length,
        layout: SwiperLayout.STACK,
        itemWidth: platformSize.width * 0.6,
        itemHeight: platformSize.height * 0.45,
        itemBuilder: (_, int index) {
          final movie = movies[index];
          return _MovieImageMain(movieCard: movie);
        },
      ),
    );
  }
}

/* Este Widget Solo Va A Vivir Dentro De Movie Slider Y No
 Se Lo Presente Al Mundo Exterior */
class _MovieImageMain extends StatefulWidget {
  final Movie movieCard;

  const _MovieImageMain({Key? key, required this.movieCard}) : super(key: key);

  @override
  State<_MovieImageMain> createState() => _MovieImageMainState();
}

class _MovieImageMainState extends State<_MovieImageMain> {
  @override
  Widget build(BuildContext context) {
    widget.movieCard.heroAnimationID = 'swiper-${widget.movieCard.id}';

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, 'details', arguments: widget.movieCard);
      },
      child: Hero(
        tag: widget.movieCard.heroAnimationID!,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: FadeInImage(
            placeholder: const AssetImage('assets/images/loading.gif'),
            image: NetworkImage(widget.movieCard.getPosterImg()),
            fit: BoxFit.cover, // Aplica El Alto Del Contenedor Padre
          ),
        ),
      ),
    );
  }
}
