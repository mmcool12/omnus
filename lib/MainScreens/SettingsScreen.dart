import 'package:flutter/material.dart';
import 'package:omnus/Auth/AuthFunctions.dart';
import 'package:omnus/Plaid/PlaidServiceFunctions.dart';
import 'package:page_view_indicators/circle_page_indicator.dart';


class SettingsScreen extends StatelessWidget {

  final AuthFunctions _auth = AuthFunctions();

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
    );
  }
}
