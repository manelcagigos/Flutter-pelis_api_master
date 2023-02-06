import 'package:flutter/material.dart';

import 'package:flutter_swiper/flutter_swiper.dart';
//import 'package:scooby_app/src/models/pelicula_model.dart';
import 'package:scooby_app/src/models/actores_model.dart';

class CardSwiper extends StatelessWidget {
  final List<Actor> actores;

  CardSwiper({@required this.actores});

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;

    return Container(
      padding: EdgeInsets.only(top: 10.0),
      child: Swiper(
        layout: SwiperLayout.STACK,
        itemWidth: _screenSize.width * 0.7,
        itemHeight: _screenSize.height * 0.5,
        itemBuilder: (BuildContext context, int index) {
          actores[index].id = actores[index].id;

          return Hero(
            tag: actores[index].id,
            child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: GestureDetector(
                  onTap: () => Navigator.pushNamed(context, 'detalle', arguments: actores[index]),
                  child: FadeInImage(
                    image: NetworkImage(actores[index].getFoto()),
                    placeholder: AssetImage('assets/img/no-image.jpg'),
                    fit: BoxFit.cover,
                  ),
                )),
          );
        },
        itemCount: actores.length,
        // pagination: new SwiperPagination(),
        // control: new SwiperControl(),
      ),
    );
  }
}
