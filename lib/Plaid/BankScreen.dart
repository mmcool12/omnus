// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:omnus/MainScreens/HomeScreen.dart';
import 'package:omnus/Models/User.dart';
import 'package:omnus/Plaid/PlaidServiceFunctions.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';


class BankScreen extends StatelessWidget {
  @override


  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    MediaQueryData queryData = MediaQuery.of(context);
    WebViewController _controller;

    final _key = UniqueKey();
    //print(PlaidSerivceFunctions().linkInittwo);

    return Scaffold(
      body: WebView(
          key: _key,
          initialUrl: "https://cdn.plaid.com/link/v2/stable/link.html" + PlaidSerivceFunctions().linkInittwo,
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webViewController) {
            _controller = webViewController;
          },
          navigationDelegate: (NavigationRequest nav){
            debugPrint(nav.url);
            if(nav.url.startsWith('plaidlink://exit')){
              Navigator.popUntil(context, ModalRoute.withName('/Auth'));
              return null;
            }
            if(nav.url.startsWith('plaidlink://connected')){
              String _publicToken = PlaidSerivceFunctions().extractToken(nav.url);
              List _accounts = PlaidSerivceFunctions().extractAccounts(nav.url);
              user.publicToken = _publicToken;
              for (Map account in _accounts) user.addAccount(account);

              Navigator.pushReplacementNamed(context, '/Home');
              return null;
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