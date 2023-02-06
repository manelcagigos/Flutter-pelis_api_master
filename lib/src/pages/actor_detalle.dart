import 'package:flutter/material.dart';

import 'package:scooby_app/src/models/actores_model.dart';
import 'package:scooby_app/src/models/pelicula_model.dart';
import 'package:scooby_app/src/providers/actores_provider.dart';

// import '../widgets/card_swiper_widget.dart';
// import '../widgets/movie_horizontal.dart';

//import '../providers/peliculas_provider.dart';

class ActorDetalle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Actor actor = ModalRoute.of(context).settings.arguments;

    return Scaffold(
        body: CustomScrollView(
      slivers: <Widget>[
        _crearAppbar(actor),
        SliverList(
          delegate: SliverChildListDelegate([
            SizedBox(height: 10.0),
            _posterTitulo(context, actor),
            _getInfoActor(actor),
            _crearCasting(actor),
          ]),
        )
      ],
    ));
  }

  Widget _crearAppbar(dynamic actor) {
    return SliverAppBar(
      elevation: 2.0,
      backgroundColor: Colors.redAccent,
      expandedHeight: 200.0,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Text(
          actor.name,
          style: TextStyle(color: Colors.white, fontSize: 16.0),
        ),
        background: FadeInImage(
          image: NetworkImage(
              "https://image.tmdb.org/t/p/w500" + actor.profilePath),
          //image: NetworkImage(pelicula.getBackgroundImg()),
          placeholder: AssetImage('assets/img/loading.gif'),
          //fadeInDuration: Duration(microseconds: 150),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _posterTitulo(BuildContext context, Actor actor) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        children: <Widget>[
          Hero(
            tag: actor.id,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: Image(
                image: NetworkImage(actor.getFoto()),
                height: 150.0,
              ),
            ),
          ),
          SizedBox(width: 20.0),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(actor.name,
                    style: Theme.of(context).textTheme.bodyText1,
                    overflow: TextOverflow.ellipsis),
                Row(
                  children: <Widget>[
                    Icon(Icons.star_border),
                    Text(actor.actorRating.toString(),
                        style: Theme.of(context).textTheme.bodyText1)
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _getInfoActor(Actor actor) {
    final actorprovider = new ActoresProvider();

    return FutureBuilder(
      future: actorprovider.getActorBio(actor.id),
      builder: (context, AsyncSnapshot<String> snapshot) {
        if (snapshot.hasData) {
          return Column(
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Text(snapshot.data, textAlign: TextAlign.justify))
            ],
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _crearActoresPageView(List<Pelicula> peliculas) {
    return SizedBox(
      height: 200.0,
      child: PageView.builder(
        pageSnapping: false,
        controller: PageController(viewportFraction: 0.3, initialPage: 1),
        itemCount: peliculas.length,
        itemBuilder: (context, i) => _actorTarjeta(peliculas[i], context),
      ),
    );
  }

  Widget _actorTarjeta(Pelicula pelicula, BuildContext context) {
    return Container(
        child: Column(
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.circular(20.0),
          child: GestureDetector(
              onTap: () => {
                    pelicula.uniqueId = pelicula.id.toString() + '-tarjeta',
                    Navigator.pushNamed(context, 'pelicula',
                        arguments: pelicula)
                  },
              child: FadeInImage(
                image: NetworkImage(pelicula.getPosterImg()),
                placeholder: AssetImage('assets/img/no-image.jpg'),
                height: 150.0,
                fit: BoxFit.cover,
              )),
        ),
        Text(
          pelicula.title,
          overflow: TextOverflow.ellipsis,
        )
      ],
    ));
  }

  Widget _crearCasting(Actor actor) {
    final peliProvider = new ActoresProvider();

    return FutureBuilder(
      future: peliProvider.getCast(actor.id.toString()),
      builder: (context, AsyncSnapshot<List> snapshot) {
        if (snapshot.hasData) {
          return _crearActoresPageView(snapshot.data);
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  // Widget _footer(BuildContext context) {
  //   return Container(
  //     width: double.infinity,
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: <Widget>[
  //         Container(padding: EdgeInsets.only(left: 20.0), child: Text('Actores Populares', style: Theme.of(context).textTheme.bodyText1)),
  //         SizedBox(height: 5.0),
  //         StreamBuilder(
  //           stream: actoresProvider.popularesStream,
  //           builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
  //             if (snapshot.hasData) {
  //               return MovieHorizontal(
  //                 actores: snapshot.data,
  //                 siguientePagina: actoresProvider.getPopulares,
  //               );
  //             } else {
  //               return Center(child: CircularProgressIndicator());
  //             }
  //           },
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // Widget _swiperTarjetas() {
  //   return FutureBuilder(
  //     future: actoresProvider.getPopulares(),
  //     builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
  //       if (snapshot.hasData) {
  //         return CardSwiper(actores: snapshot.data);
  //       } else {
  //         return Container(height: 400.0, child: Center(child: CircularProgressIndicator()));
  //       }
  //     },
  //   );
  // }
}
