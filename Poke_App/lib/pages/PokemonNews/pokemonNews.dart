import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutte_pokedex/widgets/customWidget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PokemonNews extends StatefulWidget {
  PokemonNews({Key key}) : super(key: key);

  @override
  _PokemonNewsState createState() => _PokemonNewsState();
}

class _PokemonNewsState extends State<PokemonNews> {
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
        appBar: new AppBar(title: const Text('News', style: TextStyle(color: Colors.black)), iconTheme: IconThemeData(color: Colors.black), backgroundColor: Colors.white),
        body: Stack(
          children: <Widget>[
            _topRightPokeball(context),
            _build(context),
          ],
        ));
  }
}

Widget _build(BuildContext context) {
  return StreamBuilder<QuerySnapshot>(
    stream: Firestore.instance.collection('noticias').snapshots(),
    builder: (context, snapshot) {
      if (!snapshot.hasData) return LinearProgressIndicator();

      return _buildList(context, snapshot.data.documents);
    },
  );
}

Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
  return ListView(
    padding: const EdgeInsets.only(top: 20.0),
    children: snapshot.map((data) => _buildListItem(context, data)).toList(),
  );
}

Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
  final news = News.fromSnapshot(data);

  return Padding(
    key: ValueKey(news.title),
    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
    child: Container(
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        color: Colors.lightBlue[400],
        elevation: 10,
        child: Column(
          children: <Widget>[
            Text(
              '\n' + news.date + '\n',
              style: TextStyle(color: Colors.grey[800], fontSize: 18),
            ),
            FlipCard(
              direction: FlipDirection.HORIZONTAL, // default
              front: Container(
                child: ListTile(
                  trailing: Image.asset('assets/images/pokimon_25.png'),
                  title: Text(
                    news.title,
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                  subtitle: Text(
                    '\n' + news.shortDescription,
                    style: TextStyle(color: Colors.black, fontSize: 18),
                  ),
                ),
              ),
              back: Container(
                child: ListTile(
                  subtitle: Text('\nCategoria: ' + news.tag + '\n',
                      style: TextStyle(color: Colors.grey[800], fontSize: 18)),
                  title: Text(news.noticia),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _topRightPokeball(BuildContext context) {
  return Positioned(
      right: 0,
      top: 0,
      child: Align(
        heightFactor:
            fullWidth(context) <= 360 ? getDimention(context, 1.03) : .74,
        widthFactor:
            fullWidth(context) <= 360 ? getDimention(context, .98) : .69,
        alignment: Alignment.bottomLeft,
        child: Image.asset(
          'assets/images/pokeball.png',
          color: Color(0Xb3e5fc).withAlpha(100),
          height: getDimention(context, 250),
        ),
      ));
}

class News {
  final String title;
  final String date;
  final String shortDescription;
  final String tag;
  final String noticia;
  final DocumentReference reference;

  News.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['title'] != null),
        assert(map['date'] != null),
        assert(map['shortDescription'] != null),
        assert(map['tag'] != null),
        assert(map['noticia'] != null),
        title = map['title'],
        date = map['date'],
        shortDescription = map['shortDescription'],
        tag = map['tag'],
        noticia = map['noticia'];

  News.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "Record<$title:$date:$shortDescription:$tag:$noticia>";
}
