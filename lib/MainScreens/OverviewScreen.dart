import 'package:flutter/material.dart';
import 'package:amazon_cognito_identity_dart/cognito.dart';
import 'package:omnus/Auth/AuthFunctions.dart';
import 'package:omnus/Models/User.dart';
import 'package:omnus/Plaid/BankScreen.dart';
import 'package:omnus/Plaid/PlaidServiceFunctions.dart';
import 'package:provider/provider.dart';


class OverviewScreen extends StatelessWidget {

  final AuthFunctions _auth = AuthFunctions();
  
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow[800],
        title: Text('Overview'),
        actions: <Widget>[
          FlatButton.icon(
            icon: Icon(Icons.monetization_on),
            label: Text(''),
            onPressed: () => Navigator.pushReplacementNamed(context, '/Plaid/Bank'),
          ),
          FlatButton.icon(
            icon: Icon(Icons.person),
            label: Text('logout'),
            onPressed: () async {await _auth.signOut();},
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(20),
          child: Column(
            children: <Widget>[
              Card(
                color: Colors.white,
                elevation: 2,
                child: Column(
                  children: <Widget>[
                    Container(
                      width: double.infinity,
                      child: Text('Spending overview ${user.accounts.length}'),
                    )
                  ],
                ),
              ),
              Padding(padding: EdgeInsets.symmetric(vertical: 8)),
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                color: Colors.white,
                elevation: 2,
                child: Column(
                  children: <Widget>[
                    Container(
                      width: double.infinity,
                      child: Text('All your cards'),
                    )
                  ],
                ),
              ),
              Padding(padding: EdgeInsets.symmetric(vertical: 8)),
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                color: Colors.white,
                elevation: 3,
                child: Column(
                  children: <Widget>[
                    Container(
                      height: 4000,
                      width: double.infinity,
                      child: Text('Transactions', textAlign: TextAlign.center,),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
