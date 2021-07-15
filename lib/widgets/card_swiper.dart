import 'package:flutter/material.dart';

/* Widgets */
import 'package:card_swiper/card_swiper.dart';

/* Models */
import 'package:peliculas_app/models/models.dart';

class CardSwiper extends StatelessWidget {
  final List<Movie> movies;

  const CardSwiper({Key? key, required this.movies}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final platformSize = MediaQuery.of(context).size;

    /* Aplicando Un Loading */
    if (this.movies.length == 0) {
      return Container(
        width: double.infinity,
        height: platformSize.height * 0.5,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    return Container(
      color: Colors.red,
      width: double.infinity,
      // height: 480,
      height: platformSize.height * 0.5,
      child: Swiper(
        itemCount: this.movies.length,
        layout: SwiperLayout.STACK,
        itemWidth: platformSize.width * 0.6,
        itemHeight: platformSize.height * 0.4,
        itemBuilder: (_, int index) {
          final movie = this.movies[index];
          return _MovieImageMain(posterImage: movie.getPosterImg());
        },
      ),
    );
  }
}

/* Este Widget Solo Va A Vivir Dentro De Movie Slider Y No
 Se Lo Presente Al Mundo Exterior */
class _MovieImageMain extends StatelessWidget {
  final String posterImage;

  const _MovieImageMain({Key? key, required this.posterImage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          Navigator.pushNamed(context, 'details', arguments: 'move-instance'),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: FadeInImage(
          placeholder: AssetImage('assets/images/loading.gif'),
          image: NetworkImage(this.posterImage),
          fit: BoxFit.cover, // Aplica El Alto Del Contenedor Padre
        ),
      ),
    );
  }
}
