import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/* Provider */
import 'package:movies_api_flutter/providers/movies_provider.dart';

/* Models */
import 'package:movies_api_flutter/models/models.dart';

class MovieSearchDelegate extends SearchDelegate {
  /* Propiedad Para Cambiar El Nombre Del Buscador */
  @override
  String get searchFieldLabel => 'Buscar';

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () => query = '',
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return const Text('BuildResults');
  }

  Widget _emptyContainer() {
    return const Center(
      child: Icon(
        Icons.movie_creation_outlined,
        color: Colors.black38,
        size: 130,
      ),
    );
  }

  /* Este Método Se Dispara Cada Vez Que Una Persona Dispara Una Tecla */
  @override
  Widget buildSuggestions(BuildContext context) {
    /* this.query Ya Viene Implicito De La Clase SearchDelegate */
    if (query.isEmpty) {
      return _emptyContainer();
    }

    final moviesProvider = Provider.of<MoviesProvider>(context, listen: false);
    /* Cada Vez Que Se Toque Una Tecla, Se LLama Este Método */
    moviesProvider.getSuggetionsByQuery(query);

    /* Este StreamBuilder() Solo Se Va A Redibujar Unicamente Cuando El suggestionStream Emite Un Valor */
    return StreamBuilder(
      stream: moviesProvider.suggestionStream,
      builder: (_, AsyncSnapshot<List<Movie>> snapshot) {
        if (!snapshot.hasData) {
          return _emptyContainer();
        }

        final movies = snapshot.data!;

        return ListView.builder(
          itemCount: movies.length,
          itemBuilder: (_, int index) => _MovieItem(movie: movies[index]),
        );
      },
    );

    // Implementanción Sin El StreamController, Funciona Correctamente!
    /* return FutureBuilder(
      future: moviesProvider.searchMovies(this.query),
      builder: (_, AsyncSnapshot<List<Movie>> snapshot) {
        if (!snapshot.hasData) {
          return this._emptyContainer();
        }

        final movies = snapshot.data!;

        return ListView.builder(
          itemCount: movies.length,
          itemBuilder: (_, int index) => _MovieItem(movie: movies[index]),
        );
      },
    ); */
  }
}

class _MovieItem extends StatelessWidget {
  final Movie movie;

  const _MovieItem({Key? key, required this.movie}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    movie.heroAnimationID = 'search-${movie.id}';

    return ListTile(
      leading: Hero(
        tag: movie.heroAnimationID!,
        child: FadeInImage(
          placeholder: const AssetImage('assets/images/no-image.jpg'),
          image: NetworkImage(movie.getPosterImg()),
          width: 50,
          fit: BoxFit.contain,
        ),
      ),
      title: Text(movie.title),
      subtitle: Text(movie.originalTitle),
      onTap: () {
        Navigator.pushNamed(context, 'details', arguments: movie);
      },
    );
  }
}