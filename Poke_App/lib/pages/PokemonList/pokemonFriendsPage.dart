import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutte_pokedex/model/User.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../widgets/customWidget.dart';

class PokemonFriendsPage extends StatefulWidget {
  PokemonFriendsPage({Key key}) : super(key: key);

  @override
  _PokeFriendsPageState createState() => _PokeFriendsPageState();
}

class _PokeFriendsPageState extends State<PokemonFriendsPage> {
  final databaseReference = Firestore.instance;
  User currentUser;
  List<User> friendsFavorites = [];
  List<User> userFriends = [];

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _topRightPokeball(),
          Positioned(
            left: 10,
            top: 35,
            child: BackButton(
              color: Colors.black,
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 25),
            child: CustomScrollView(
              slivers: <Widget>[
                SliverAppBar(
                  automaticallyImplyLeading: true,
                  leading: SizedBox(),
                  backgroundColor: Colors.transparent,
                  brightness: Brightness.dark,
                  floating: false,
                  flexibleSpace: Container(
                    padding: EdgeInsets.symmetric(horizontal: 0, vertical: 20),
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      'Lista de amigos',
                      style: TextStyle(
                          fontSize: getFontSize(context, 25),
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                  expandedHeight: getDimention(context, 130),
                ),
              ],
            ),
          ),
          Column(children: <Widget>[
            SizedBox(
              height: 100.0,
            ),
            Expanded(
              child: new Container(
                child: _friendList()
            ))
          ])
        ],
      ),
    );
  }

  Widget _topRightPokeball() {
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
            color: Color(0xffe3e3e3).withAlpha(100),
            height: getDimention(context, 250),
          ),
        ));
  }

  Widget _friendList() {
    return ListView.builder(
      itemCount: friendsFavorites.length,
      itemBuilder: (context, i) {
        return GestureDetector(
          onTap: () {
            print('ejecuto');
          },
          child: Column(
            children: <Widget>[
              Divider(
                height: 10,
              ),
              ListTile(
                leading: new CircleAvatar(
                  backgroundImage: AssetImage('assets/images/pokimon_25.png'),
                ),
                title: new Text(friendsFavorites[i].fullName),
                subtitle: new Text(friendsFavorites[i].userName),
              )
            ],
          ),
        );
      },
    );
  }

  void getCurrentUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String uid = prefs.getString('uid');
    List<int> userFavorites = [];
    List<String> userFriends = [];

    await databaseReference
        .collection('usuarios')
        .document(uid)
        .get()
        .then((DocumentSnapshot snapshot) {
      List<dynamic> tempFavorites = snapshot.data['favorites'].toList();
      tempFavorites.forEach((element) {
        int temporalId = element;
        userFavorites.add(temporalId);
      });

      List<dynamic> tempFriends = snapshot.data['friends'].toList();
      tempFriends.forEach((element) {
        String temporalUser = element;
        userFriends.add(temporalUser);
      });

      currentUser = User(
          uid: uid,
          fullName: snapshot.data['fullName'],
          userName: snapshot.data['userName'],
          favorites: userFavorites,
          friends: userFriends);
    });
    getFriendsData();
  }

  void getFriendsData() {
    List<int> friendFavorites = [];
    if (currentUser != null) {
      currentUser.friends.forEach((element) async {
        await databaseReference
            .collection('usuarios')
            .document(element)
            .get()
            .then((DocumentSnapshot snapshot) {
          List<dynamic> tempFavorites = snapshot.data['favorites'].toList();
          tempFavorites.forEach((element) {
            int temporalId = element;
            friendFavorites.add(temporalId);
          });
          User friends = User(
              uid: element,
              favorites: friendFavorites,
              userName: snapshot.data['userName'],
              fullName: snapshot.data['fullName']);
          friendsFavorites.add(friends);
          setState(() {
            
          });
        });
      });
    }
  }
}
