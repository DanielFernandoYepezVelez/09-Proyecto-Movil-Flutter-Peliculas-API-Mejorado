import 'package:flutter/material.dart';

/* Screens */
import 'package:peliculas_app/screens/screens.dart';

final Map<String, Widget Function(BuildContext)> appRoutes = {
  'home': (_) => HomeScreen(),
  'details': (_) => DetailsScreen(),
};
