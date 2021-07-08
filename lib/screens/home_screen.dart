import 'package:flutter/material.dart';

/* Widgets */
import 'package:peliculas_app/widgets/widgets.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
            CardSwiper(),
            MovieSlider(categoryTitle: 'Populares'),
            MovieSlider(categoryTitle: 'Terror'),
            MovieSlider(categoryTitle: 'Comedia'),
          ],
        ),
      ),
    );
  }
}
