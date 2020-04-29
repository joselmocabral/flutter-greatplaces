import 'package:flutter/material.dart';
import 'dart:math';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

import './places_list_screen.dart';
import './add_place_screen.dart';
import '../models/frases.dart';
import '../providers/great_places.dart';
import '../models/place.dart';

class MomentsGenerator extends StatefulWidget {
  @override
  _MomentsGeneratorState createState() => _MomentsGeneratorState();
}

class _MomentsGeneratorState extends State<MomentsGenerator> {
  //Place photo;
  String frase;

  T getRandomElement<T>(List<T> list) {
    if (list.length == 0) {
      return null;
    }
    final random = new Random();
    var i = random.nextInt(list.length);

    return list[i];
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    frase = getRandomElement(frases);
    initializeDateFormatting('pt_BR');

    Place photo = getRandomElement(
        Provider.of<GreatPlaces>(context, listen: false).items);

    final mediaQuery = MediaQuery.of(context);
    final PreferredSizeWidget appBar = AppBar(
      backgroundColor: Colors.purple,
      title: photo == null
          ? Text('')
          : Text(
              '${DateFormat('MM/yyyy', 'pt_BR').format(photo.date)}: ${photo.title}'),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.favorite),
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("Contando:"),
                    content: photo == null
                        ? Text('')
                        : Text(
                            '${photo.date.difference(DateTime(2014, 06, 06)).inDays.toString()} dias juntinhos'),
                  );
                });
          },
        ),
      ],
    );

    return Scaffold(
      appBar: appBar,
      body: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            height: (mediaQuery.size.height -
                    appBar.preferredSize.height -
                    mediaQuery.padding.top) *
                0.85,

            //Image(image: ,),
            child: GestureDetector(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Lembrança"),
                        content:
                            photo == null ? Text('') : Text('${photo.memory}'),
                      );
                    });
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: GridTile(
                  child: photo == null
                      ? Center(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {});
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  width: 300,
                                  child: Text(
                                    'CLIQUE PARA GERAR UMA NOVA LEMBRANÇA',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 30,
                                    
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Icon(Icons.favorite, color: Colors.red),
                              ],
                            ),
                          ),
                        )
                      : Image.file(
                          photo.image,
                          fit: BoxFit.cover,
                        ),
                  footer: GridTileBar(
                    backgroundColor: Colors.black87,
                    title: Text(
                      frase,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 5,
                    ),
                  ),
                ),
              ),
            ),
          ),
          // FloatingActionButton(

          //   child: Icon(Icons.refresh),
          //   onPressed: () {
          //     setState(() {});
          //   },
          // ),
          Container(
            height: (mediaQuery.size.height -
                    appBar.preferredSize.height -
                    mediaQuery.padding.top) *
                0.15,
            child: BottomNavigationBar(
              //type: BottomNavigationBarType.shifting,
              items: [
                BottomNavigationBarItem(
                  backgroundColor: Colors.purple,
                  icon: Icon(
                    Icons.add_a_photo,
                  ),
                  title: Text('Adicionar'),
                ),
                BottomNavigationBarItem(
                  backgroundColor: Colors.purple,
                  icon: Icon(
                    Icons.refresh,
                  ),
                  title: Text('Nova'),
                ),
                BottomNavigationBarItem(
                  backgroundColor: Colors.purple,
                  icon: Icon(
                    Icons.edit,
                  ),
                  title: Text('Editar'),
                ),
              ],
              onTap: (index) {
                if (index == 1) {
                  //print("1");
                  setState(() {});
                } else if (index == 2) {
                  //print("2");
                  Navigator.of(context).pushNamed(PlacesListScreen.routeName);
                } else {
                  Navigator.of(context).pushNamed(AddPlaceScreen.routeName);
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
