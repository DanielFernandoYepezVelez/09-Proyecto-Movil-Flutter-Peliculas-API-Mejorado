import 'package:flutter/material.dart';

/* Screens */
import 'package:movies_api_flutter/screens/screens.dart';

final Map<String, Widget Function(BuildContext)> appRoutes = {
  'home': (_) => const HomeScreen(),
  'details': (_) => const DetailsScreen(),
  'actor': (_) => const DetailsActorScreen(),
};
