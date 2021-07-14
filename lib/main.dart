import 'package:flutter/material.dart';
import 'package:peliculas_app/providers/movies_provider.dart';

/* Routes */
import 'package:peliculas_app/routes/routes.dart';

/* Providers */
import 'package:provider/provider.dart';

void main() => runApp(AppState());

/* Este Es El Primer Widget Que Se va A Crear, Es Decir,
Después De Este Widget En Adelante, En Todos Los Widgets 
Que Yo Quiera Tengo Acceso A Esta Misma Instancia De 
MoviesProvider */
class AppState extends StatelessWidget {
  const AppState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MoviesProvider(), lazy: false),
      ],
      child: MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Peliculas App',
      initialRoute: 'home',
      routes: appRoutes,
      theme: ThemeData.dark().copyWith(
        appBarTheme: AppBarTheme(
          color: Colors.indigo,
        ),
      ),
    );
  }
}
