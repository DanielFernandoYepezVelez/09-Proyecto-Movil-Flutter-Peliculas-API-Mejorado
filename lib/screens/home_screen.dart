import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/* Movies Provider */
import 'package:peliculas_app/providers/movies_provider.dart';

/* Widgets */
import 'package:peliculas_app/widgets/widgets.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final moviesProvider = Provider.of<MoviesProvider>(context);

    print(moviesProvider.onDisplayMovies);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text('Peliculas En Cine'),
        actions: [
          IconButton(
            icon: Icon(Icons.search_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CardSwiper(movies: moviesProvider.onDisplayMovies),
            MovieSlider(
              categoryTitle: 'Populares',
              movies: moviesProvider.popularMovies,
            ),
            // MovieSlider(categoryTitle: 'Terror'),
            // MovieSlider(categoryTitle: 'Comedia'),
          ],
        ),
      ),
    );
  }
}
