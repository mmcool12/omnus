import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:omnus/Auth/AuthFunctions.dart';
import 'package:omnus/Database/DataFunctions.dart';
import 'package:omnus/Database/DataModels.dart';
import 'package:omnus/Models/Account.dart';
import 'package:omnus/Models/User.dart';
import 'package:omnus/Plaid/PlaidServiceFunctions.dart';
import 'package:provider/provider.dart';


class OverviewScreen extends StatelessWidget {

  final AuthFunctions _auth = AuthFunctions();
  List<StoredAccount> allAccounts = [];
  
  printAccounts() async {
    //await DataFunctions().updateTable('pkey');
    List<StoredAccount> allAccounts = [];
    await DataFunctions().getAllAccounts()
    .then((list) => allAccounts = list)
    .catchError((error) => print(error));
    if (allAccounts != null){
      for (StoredAccount account in allAccounts) print(account.toMap()); 
    } else {
      print('No Accounts');
    }
  }

  deleteAccount(Account account) async {
    await DataFunctions().deleteAccount(account)
    .then(print('Deleted account ${account.number}'))
    .catchError((error) => print(error));
  }

  Future<List<StoredAccount>> getAccountByType(String type) async{
    List<StoredAccount> accounts = [];
    await DataFunctions().getAccountsByType(type)
    .then((list) => accounts = list)
    .catchError((error) => print(error));
    return accounts;
  }
  
  Future<double> getTotalBalance(String type) async {
    double amount = 0;
    await DataFunctions().getAccountsByType(type)
    .then((list) {for(StoredAccount a in list) amount += double.parse(a.currentBalance);})
    .catchError((error) => print(error));
    return amount;
  }

  double balance = 0;

  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData = MediaQuery.of(context);
    var ratio = queryData.devicePixelRatio;
    //String url = 'plaidlink://connected?account_id&account_mask&account_name&account_subtype&account_type&accounts=%5B%7B%22_id%22%3A%2248rNXY3eMVSq9DXzn1wesYxkrAVLyYCk5Xq6N%22%2C%22balance%22%3A%7B%22available%22%3A464.34%2C%22currency%22%3A%22USD%22%2C%22current%22%3A35.66%2C%22localized%22%3A%7B%22available%22%3A%22%24464.34%22%2C%22current%22%3A%22%2435.66%22%7D%7D%2C%22meta%22%3A%7B%22name%22%3A%22Bank%20of%20America%20Cash%20Rewards%20World%20Mastercard%20Card%22%2C%22number%22%3A%226384%22%7D%2C%22type%22%3A%22credit%22%2C%22subtype%22%3A%22credit%20card%22%7D%2C%7B%22_id%22%3A%22ryJXbN8dm1sM1LRDvA0JT96g1JdXN9FB4vb71%22%2C%22balance%22%3A%7B%22available%22%3A1500.04%2C%22currency%22%3A%22USD%22%2C%22current%22%3A1500.04%2C%22localized%22%3A%7B%22available%22%3A%22%241%2C500.04%22%2C%22current%22%3A%22%241%2C500.04%22%7D%7D%2C%22meta%22%3A%7B%22name%22%3A%22Advantage%20Savings%22%2C%22number%22%3A%227756%22%7D%2C%22type%22%3A%22depository%22%2C%22subtype%22%3A%22savings%22%7D%2C%7B%22_id%22%3A%22j6bAO4kn15srvJdD1A83CEe95gB3xEiRPL3BA%22%2C%22balance%22%3A%7B%22available%22%3A2259.17%2C%22currency%22%3A%22USD%22%2C%22current%22%3A2304.33%2C%22localized%22%3A%7B%22available%22%3A%22%242%2C259.17%22%2C%22current%22%3A%22%242%2C304.33%22%7D%7D%2C%22meta%22%3A%7B%22name%22%3A%22Adv%20Plus%20Banking%22%2C%22number%22%3A%228004%22%7D%2C%22type%22%3A%22depository%22%2C%22subtype%22%3A%22checking%22%7D%5D&institution_id=ins_1&institution_name=Bank%20of%20America&link_session_id=07fc7215-defa-4a98-90b4-981d8356ea08&public_token=public-development-a330a901-e386-47ca-aa13-b18b08ada7da';
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow[800],
        title: Text('Overview'),
        actions: <Widget>[
          FlatButton.icon(
            icon: Icon(Icons.credit_card),
            label: Text(''),
            onPressed: () => Navigator.pushNamed(context, '/Plaid/Bank'),
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          FutureBuilder(
                            future: getTotalBalance('credit'),
                            builder: (BuildContext context, AsyncSnapshot<double> snapshot){
                                return Text("\$${(snapshot.data == null ? 0 : snapshot.data *-1)} ", 
                                style: TextStyle(
                                  fontSize: ratio * 10,
                                  color: ((snapshot.data == null ? 0.0 : snapshot.data).isNegative ? Colors.green : Colors.red),
                                  fontWeight: FontWeight.bold
                                  )
                                );
                            },
                          ),
                          Text("total debt",
                          style: TextStyle(
                            fontSize: ratio * 6,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text("1/16",
                              style: TextStyle(
                                fontSize: ratio * 6
                                ),
                              ),
                              Text("\$-200",
                              style: TextStyle(
                                fontSize: ratio * 6
                                ),
                              ),
                              Text("BOFA 3653",
                              style: TextStyle(
                                fontSize: ratio * 6
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Padding(padding: EdgeInsets.symmetric(vertical: 8)),

              FutureBuilder(
                future: getAccountByType('credit'),
                builder: (BuildContext context, AsyncSnapshot<List<StoredAccount>> snapshot) {
                  final children = <Widget>[];
                  double amount = 0;
                  if (snapshot.hasData && snapshot.connectionState == ConnectionState.done){
                     for( StoredAccount a in snapshot.data) children.add(CardOverview(ratio: ratio, account: a));
                  }
                  return Column(
                    children: children,
                  );
                }
                ),


              Padding(padding: EdgeInsets.symmetric(vertical: 8)),
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                color: Colors.white,
                elevation: 3,
                child: Column(
                  children: <Widget>[
                    TransactionView(ratio: ratio, cardNumber: 3030),
                    TransactionView(ratio: ratio, cardNumber: 3030),
                    TransactionView(ratio: ratio, cardNumber: 3030),
                    TransactionView(ratio: ratio, cardNumber: 3030),
                    TransactionView(ratio: ratio, cardNumber: 3030),
                    TransactionView(ratio: ratio, cardNumber: 3030),
                    TransactionView(ratio: ratio, cardNumber: 3030),
                    TransactionView(ratio: ratio, cardNumber: 3030),
                    TransactionView(ratio: ratio, cardNumber: 3030),
                    TransactionView(ratio: ratio, cardNumber: 3030),
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

class CardOverview extends StatelessWidget {
  const CardOverview({
    Key key,
    @required this.ratio,
    @required this.account
  }) : super(key: key);

  final double ratio;
  final StoredAccount account;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      color: Colors.white,
      elevation: 2,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("${account.number}",
                  style: TextStyle(
                    fontSize: ratio * 6,
                    fontWeight: FontWeight.bold,
                    ),
                  ),
                  Padding(padding: EdgeInsets.symmetric(vertical: 4)),
                  Container(
                    color: Colors.red,
                    child: Padding(padding: EdgeInsets.symmetric(vertical: ratio* 4, horizontal: ratio * 6))
                  )
                ],
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("Balance",
                  style: TextStyle(
                    fontSize: ratio * 6
                    ),
                  ),
                  Padding(padding: EdgeInsets.symmetric(vertical: 4)),
                  Text("\$${account.currentBalance}",
                  style: TextStyle(
                    fontSize: ratio * 6 + 1
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("Remaining",
                  style: TextStyle(
                    fontSize: ratio * 6
                    ),
                  ),
                  Padding(padding: EdgeInsets.symmetric(vertical: 4)),
                  Text("\$${account.availableBalance}",
                  style: TextStyle(
                    fontSize: ratio * 6 + 1
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TransactionView extends StatelessWidget {
  const TransactionView({
    Key key,
    @required this.ratio,
    @required this.cardNumber
  }) : super(key: key);

  final double ratio;
  final int cardNumber;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("$cardNumber",
                style: TextStyle(
                  fontSize: ratio * 6,
                  fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(padding: EdgeInsets.symmetric(vertical: 2)),
                Container(
                  color: Colors.red,
                  child: Padding(padding: EdgeInsets.symmetric(vertical: ratio* 4, horizontal: ratio * 6))
                )
              ],
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("Place",
                style: TextStyle(
                  fontSize: ratio * 6
                  ),
                ),
                Padding(padding: EdgeInsets.symmetric(vertical: 2)),
                Text("Chick-Fil-A",
                style: TextStyle(
                  fontSize: ratio * 6 + 1
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("Cost",
                style: TextStyle(
                  fontSize: ratio * 6
                  ),
                ),
                Padding(padding: EdgeInsets.symmetric(vertical: 4)),
                Text("\$25.06",
                style: TextStyle(
                  fontSize: ratio * 6 + 1
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
