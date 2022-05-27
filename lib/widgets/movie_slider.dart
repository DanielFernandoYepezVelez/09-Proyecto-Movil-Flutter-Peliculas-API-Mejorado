import 'package:flutter/material.dart';

/* Models */
import 'package:movies_api_flutter/models/models.dart';

class MovieSlider extends StatefulWidget {
  final List<Movie> movies;
  final Function onNextPage;
  final String? categoryTitle;

  const MovieSlider({
    Key? key,
    this.categoryTitle,
    required this.onNextPage,
    required this.movies,
  }) : super(key: key);

  @override
  _MovieSliderState createState() => _MovieSliderState();
}

class _MovieSliderState extends State<MovieSlider> {
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      /* Posición Actual En Pixeles Del Scroll */
      // print(scrollController.position.pixels);

      /* Posición Final En Pixeles Del Scroll */
      // print(scrollController.position.maxScrollExtent);

      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 500) {
        /* TODO: LLamar Provider */
        // print('Obtener La Siguiente Página');
        widget.onNextPage();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 270,
      /* 262 */
      width: double.infinity,
      // color: Colors.blueAccent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 5),

          /* Aqui Yo Ya Estoy Seguro Que No Va A Ser Nulo, Por Ende Agrego El Operador (!) */
          if (widget.categoryTitle != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                widget.categoryTitle!,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          /* -------------------------------------------------------------- */

          const SizedBox(height: 5),
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              scrollDirection: Axis.horizontal,
              itemCount: widget.movies.length,
              itemBuilder: (_, int index) => _MoviePoster(
                movie: widget.movies[index],
                heroID:
                    '${widget.categoryTitle}-$index-${widget.movies[index].id}',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/* Este Widget Solo Va A Vivir Dentro De Movie Slider Y No
 Se Lo Presente Al Mundo Exterior */
class _MoviePoster extends StatefulWidget {
  final Movie movie;
  final String heroID;

  const _MoviePoster({Key? key, required this.movie, required this.heroID})
      : super(key: key);

  @override
  State<_MoviePoster> createState() => _MoviePosterState();
}

class _MoviePosterState extends State<_MoviePoster> {
  @override
  Widget build(BuildContext context) {
    widget.movie.heroAnimationID = widget.heroID;

    return Container(
      width: 130,
      height: 190,
      // color: Colors.green,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, 'details', arguments: widget.movie);
            },
            child: Hero(
              tag: widget.movie.heroAnimationID!,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: FadeInImage(
                  placeholder: const AssetImage('assets/images/no-image.jpg'),
                  image: NetworkImage(widget.movie.getPosterImg()),
                  width: 130,
                  height: 190,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            widget.movie.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
