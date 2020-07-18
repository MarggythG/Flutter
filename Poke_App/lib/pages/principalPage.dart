import 'package:flutte_pokedex/pages/homePageBody.dart';
import 'package:flutter/material.dart';
 


class PrincipalPage extends StatefulWidget {
  PrincipalPage({Key key}) : super(key: key);

  @override
  _PrincipalPageState createState() => _PrincipalPageState();
}

class _PrincipalPageState extends State<PrincipalPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       body: HomePageBody(),
    );
  }
}
