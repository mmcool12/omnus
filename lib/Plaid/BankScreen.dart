// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:omnus/Database/DataFunctions.dart';
import 'package:omnus/Models/Account.dart';
import 'package:omnus/Models/User.dart';
import 'package:omnus/Plaid/PlaidServiceFunctions.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';


class BankScreen extends StatelessWidget {
  @override


  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    //MediaQueryData queryData = MediaQuery.of(context);

    final _key = UniqueKey();
    //print(PlaidSerivceFunctions().linkInittwo);

    return Scaffold(
      body: WebView(
          key: _key,
          initialUrl: "https://cdn.plaid.com/link/v2/stable/link.html" + PlaidSerivceFunctions().linkInittwo,
          javascriptMode: JavascriptMode.unrestricted,
          navigationDelegate: (NavigationRequest nav) async {
            debugPrint(nav.url);
            if(nav.url.startsWith('plaidlink://exit')){
              Navigator.popUntil(context, ModalRoute.withName('/Auth'));
              return NavigationDecision.prevent;
            }
            if(nav.url.startsWith('plaidlink://connected')){
              String _publicToken = PlaidSerivceFunctions().extractToken(nav.url);
              Map response = await PlaidSerivceFunctions().getAccessToken(_publicToken);
              String accessToken = response['access_token'];
              String itemId = response['item_id'];
              print(accessToken);
              List _accounts = PlaidSerivceFunctions().extractAccounts(nav.url);
              for (dynamic account in _accounts) {
                try {
                  await DataFunctions().saveAccount(Account.fromMap(account, accessToken, itemId));
                  print('SAVED');
                } catch (error) {
                  print(error);
                }
              }
              Navigator.pushReplacementNamed(context, '/Home');
            }
            if(nav.url.startsWith('http')){
              return NavigationDecision.navigate;
            } else {
              return NavigationDecision.prevent;
            }
            
          },
      ),
    );
  }
}
      // appBar: AppBar(
      //   backgroundColor: Colors.white,
      //   title: Text(
      //           'Add a bank Account',
      //           style: TextStyle(
      //             color: Colors.black,
      //             fontWeight: FontWeight.bold,
      //             fontSize: ratio*8
      //           ),
      //         ),
      //   centerTitle: true,
      // ),