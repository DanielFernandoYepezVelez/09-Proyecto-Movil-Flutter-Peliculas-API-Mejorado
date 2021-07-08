import 'package:flutter/material.dart';
import 'package:card_swiper/card_swiper.dart';

class CardSwiper extends StatelessWidget {
  const CardSwiper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final platformSize = MediaQuery.of(context).size;

    return Container(
      color: Colors.red,
      width: double.infinity,
      // height: 480,
      height: platformSize.height * 0.5,
      child: Swiper(
        itemCount: 10,
        layout: SwiperLayout.STACK,
        itemWidth: platformSize.width * 0.6,
        itemHeight: platformSize.height * 0.4,
        itemBuilder: (_, int index) {
          return GestureDetector(
            onTap: () => Navigator.pushNamed(context, 'details',
                arguments: 'move-instance'),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: FadeInImage(
                placeholder: AssetImage('assets/images/loading.gif'),
                image: NetworkImage('https://via.placeholder.com/300x400'),
                fit: BoxFit.cover, // Aplica El Alto Del Contenedor Padre
              ),
            ),
          );
        },
      ),
    );
  }
}
