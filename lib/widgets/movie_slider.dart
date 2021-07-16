import 'package:flutter/material.dart';

/* Models */
import 'package:peliculas_app/models/models.dart';

class MovieSlider extends StatelessWidget {
  final List<Movie> movies;
  final String? categoryTitle;

  const MovieSlider({Key? key, this.categoryTitle, required this.movies})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 262,
      width: double.infinity,
      color: Colors.blueAccent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 5),

          /* Aqui Yo Ya Estoy Seguro Que No Va A Ser Nulo, Por Ende Agrego El Operador (!) */
          if (this.categoryTitle != null)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                this.categoryTitle!,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          /* -------------------------------------------------------------- */

          SizedBox(height: 5),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: this.movies.length,
              itemBuilder: (_, int index) =>
                  _MoviePoster(movie: this.movies[index]),
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

  const _MoviePoster({Key? key, required this.movie}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 130,
      height: 190,
      color: Colors.green,
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, 'details',
                arguments: 'movie-instance'),
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
