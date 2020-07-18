import 'package:flutter/material.dart';
import '../../widgets/customWidget.dart';
import '../../model/ArgumentsModel.dart';
import 'package:http/http.dart'  as http;

class MoveDetail extends StatefulWidget {
  MoveDetail({Key key}) : super(key: key);

  @override
  _MoveDetailState createState() => _MoveDetailState();
}

class _MoveDetailState extends State<MoveDetail>  with TickerProviderStateMixin{
  Color primary = Colors.white;
  Arguments args;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    args = ModalRoute.of(context).settings.arguments;
    primary = args.color;
    return Scaffold(
       backgroundColor: primary,
       body: SafeArea(
         child: Stack(
          children: <Widget>[
            _topRightPokeball(),
            Positioned(
              left: 10,
              top: 35,
              child: BackButton(color: Colors.black,),
            ),
            _createTitle(),
            _createInformationCard()
          ],
        ),
       )
    );
  }

  Widget  _createTitle(){
     return Padding(
       padding: EdgeInsets.all(16.0),
       child: Container(
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 50),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
             Text(args.name.toUpperCase(), style: TextStyle(color: Colors.black54,fontSize: getFontSize(context,35), fontWeight: FontWeight.w900),)
          ],
        ),
      )        
    );
  }

  Widget _createInformationCard(){
    return Center(
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
             Container(
                width: 100.0,
                height: 100.0,
                decoration: new BoxDecoration(
                    shape: BoxShape.circle,
                    image: new DecorationImage(
                        fit: BoxFit.fill,
                        image: new NetworkImage(
                            "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/items/master-ball.png")
                    )
                )
            ),
            const ListTile(
              subtitle: Text('Used in battle : Catches a wild Pokémon without fail. If used in a trainer battle, nothing happens and the ball is lost.'),
            )
          ],
        ),
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
  
}