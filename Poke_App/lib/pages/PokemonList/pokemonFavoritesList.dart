import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutte_pokedex/model/User.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../widgets/customWidget.dart';
import 'package:provider/provider.dart';
import 'package:flutte_pokedex/scoped_model/pokemonState.dart';
import 'widget/pokemonCard3.dart';

class FavoritePokemon extends StatefulWidget {
  FavoritePokemon({Key key}) : super(key: key);
  
  @override
  _FavoritePokemonState createState() => _FavoritePokemonState();
}



class _FavoritePokemonState extends State<FavoritePokemon> {
  bool showFabButton =  false, card1 = true,card2= false, card3 = false;
  final databaseReference = Firestore.instance;
  User currentUser;  
  

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      body: Stack(
         children: <Widget>[
           _topRightPokeball(),
           Positioned(
            left: 10,
            top: 35,
            child: BackButton(color: Colors.black,),
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
                      padding: EdgeInsets.symmetric(horizontal: 0,vertical: 20),
                      alignment: Alignment.bottomLeft,
                      child: Text('Favorite pokemons', style: TextStyle(fontSize: getFontSize(context,25), fontWeight: FontWeight.w700),),
                    ),
                    expandedHeight: getDimention(context, 130),
                  ),
                  _pokemonList()
                ],
              ),
           ),
         ]
      ),
    );
  }

  Widget _topRightPokeball() {
    return Positioned(
        right: 0,
        top: 0,
        child: Align(
            heightFactor: fullWidth(context) <= 360 ?  getDimention(context, 1.03) : .74,
            widthFactor:  fullWidth(context) <= 360 ?  getDimention(context,.98) : .69,
            alignment: Alignment.bottomLeft,

            child: Image.asset(
              'assets/images/pokeball.png',
              color: Color(0xffe3e3e3).withAlpha(100),
              height: getDimention(context, 250),
                
     ),));
  }

  Widget _pokemonList(){
    final state = Provider.of<PokemonState>(context,);
    return SliverGrid.count(
        crossAxisCount: 4 ,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1,
        children: filterFavoritePokemons()
    );
  }

  // state.pokemonList == null ? [] : 
  //                state.pokemonList.map((x)=>  PokemonCard3(
  //                 model: x,
  //                 onPressed: (){ Navigator.of(context).pushNamed('/detail/${x.name}');},
  //                 )).toList()

  void getCurrentUser() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String uid = prefs.getString('uid');
    List<int> userFavorites = [];
    await databaseReference
      .collection('usuarios')
      .document(uid).get().then((DocumentSnapshot snapshot) {
        print(snapshot.data);
        List<dynamic> tempFavorites = snapshot.data['favorites'].toList();
        tempFavorites.forEach((element) {
          int temporalId = element;
          userFavorites.add(temporalId);
        });
        currentUser= User(uid: uid,fullName: snapshot.data['fullName'],
        userName:snapshot.data['userName'],favorites:userFavorites);
      });

      setState(() {});
  }

  List<Widget> filterFavoritePokemons(){
    final state = Provider.of<PokemonState>(context,);
    List<PokemonCard3> pokedexCards = [];
    if(currentUser != null){
       if (state.pokemonList == null){
          return [];
        }else{
          state.pokemonList.forEach((element) {
            if(currentUser.favorites.contains(element.orderId)){
              pokedexCards.add(
                PokemonCard3(
                      model: element,
                      onPressed: (){ Navigator.of(context).pushNamed('/detail/${element.name}');},
                )  
              );
            }
          });
        }
    }
    return pokedexCards;
  }


}