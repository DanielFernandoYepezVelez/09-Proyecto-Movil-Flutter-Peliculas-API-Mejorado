import 'package:flutter/material.dart';

/* Models */
import 'package:peliculas_app/models/models.dart';

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
  final scrollController = new ScrollController();

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
        this.widget.onNextPage();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 270,
      /* 262 */
      width: double.infinity,
      // color: Colors.blueAccent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 5),

          /* Aqui Yo Ya Estoy Seguro Que No Va A Ser Nulo, Por Ende Agrego El Operador (!) */
          if (this.widget.categoryTitle != null)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                this.widget.categoryTitle!,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          /* -------------------------------------------------------------- */

          SizedBox(height: 5),
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              scrollDirection: Axis.horizontal,
              itemCount: this.widget.movies.length,
              itemBuilder: (_, int index) => _MoviePoster(
                movie: this.widget.movies[index],
                heroID:
                    '${this.widget.categoryTitle}-${index}-${this.widget.movies[index].id}',
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
class _MoviePoster extends StatelessWidget {
  final Movie movie;
  final String heroID;

  const _MoviePoster({Key? key, required this.movie, required this.heroID})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    movie.heroAnimationID = this.heroID;

    return Container(
      width: 130,
      height: 190,
      // color: Colors.green,
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          GestureDetector(
            onTap: () =>
                Navigator.pushNamed(context, 'details', arguments: this.movie),
            child: Hero(
              tag: this.movie.heroAnimationID!,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: FadeInImage(
                  placeholder: AssetImage('assets/images/no-image.jpg'),
                  image: NetworkImage(this.movie.getPosterImg()),
                  width: 130,
                  height: 190,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SizedBox(height: 5),
          Text(
            this.movie.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
