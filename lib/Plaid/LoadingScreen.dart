// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

import 'package:omnus/Models/User.dart';
import 'package:provider/provider.dart';


class LoadingScreen extends StatelessWidget {
  @override

  // String url = 'plaidlink://connected?account_id&account_mask&account_name&account_subtype&account_type&accounts=%5B%7B%22_id%22%3A%2248rNXY3eMVSq9DXzn1wesYxkrAVLyYCk5Xq6N%22%2C%22balance%22%3A%7B%22available%22%3A464.34%2C%22currency%22%3A%22USD%22%2C%22current%22%3A35.66%2C%22localized%22%3A%7B%22available%22%3A%22%24464.34%22%2C%22current%22%3A%22%2435.66%22%7D%7D%2C%22meta%22%3A%7B%22name%22%3A%22Bank%20of%20America%20Cash%20Rewards%20World%20Mastercard%20Card%22%2C%22number%22%3A%226384%22%7D%2C%22type%22%3A%22credit%22%2C%22subtype%22%3A%22credit%20card%22%7D%2C%7B%22_id%22%3A%22ryJXbN8dm1sM1LRDvA0JT96g1JdXN9FB4vb71%22%2C%22balance%22%3A%7B%22available%22%3A1500.04%2C%22currency%22%3A%22USD%22%2C%22current%22%3A1500.04%2C%22localized%22%3A%7B%22available%22%3A%22%241%2C500.04%22%2C%22current%22%3A%22%241%2C500.04%22%7D%7D%2C%22meta%22%3A%7B%22name%22%3A%22Advantage%20Savings%22%2C%22number%22%3A%227756%22%7D%2C%22type%22%3A%22depository%22%2C%22subtype%22%3A%22savings%22%7D%2C%7B%22_id%22%3A%22j6bAO4kn15srvJdD1A83CEe95gB3xEiRPL3BA%22%2C%22balance%22%3A%7B%22available%22%3A2259.17%2C%22currency%22%3A%22USD%22%2C%22current%22%3A2304.33%2C%22localized%22%3A%7B%22available%22%3A%22%242%2C259.17%22%2C%22current%22%3A%22%242%2C304.33%22%7D%7D%2C%22meta%22%3A%7B%22name%22%3A%22Adv%20Plus%20Banking%22%2C%22number%22%3A%228004%22%7D%2C%22type%22%3A%22depository%22%2C%22subtype%22%3A%22checking%22%7D%5D&institution_id=ins_1&institution_name=Bank%20of%20America&link_session_id=07fc7215-defa-4a98-90b4-981d8356ea08&public_token=public-development-a330a901-e386-47ca-aa13-b18b08ada7da';



  Widget build(BuildContext context) {
      //String url = 'plaidlink://connected?account_id&account_mask&account_name&account_subtype&account_type&accounts=%5B%7B%22_id%22%3A%2248rNXY3eMVSq9DXzn1wesYxkrAVLyYCk5Xq6N%22%2C%22balance%22%3A%7B%22available%22%3A464.34%2C%22currency%22%3A%22USD%22%2C%22current%22%3A35.66%2C%22localized%22%3A%7B%22available%22%3A%22%24464.34%22%2C%22current%22%3A%22%2435.66%22%7D%7D%2C%22meta%22%3A%7B%22name%22%3A%22Bank%20of%20America%20Cash%20Rewards%20World%20Mastercard%20Card%22%2C%22number%22%3A%226384%22%7D%2C%22type%22%3A%22credit%22%2C%22subtype%22%3A%22credit%20card%22%7D%2C%7B%22_id%22%3A%22ryJXbN8dm1sM1LRDvA0JT96g1JdXN9FB4vb71%22%2C%22balance%22%3A%7B%22available%22%3A1500.04%2C%22currency%22%3A%22USD%22%2C%22current%22%3A1500.04%2C%22localized%22%3A%7B%22available%22%3A%22%241%2C500.04%22%2C%22current%22%3A%22%241%2C500.04%22%7D%7D%2C%22meta%22%3A%7B%22name%22%3A%22Advantage%20Savings%22%2C%22number%22%3A%227756%22%7D%2C%22type%22%3A%22depository%22%2C%22subtype%22%3A%22savings%22%7D%2C%7B%22_id%22%3A%22j6bAO4kn15srvJdD1A83CEe95gB3xEiRPL3BA%22%2C%22balance%22%3A%7B%22available%22%3A2259.17%2C%22currency%22%3A%22USD%22%2C%22current%22%3A2304.33%2C%22localized%22%3A%7B%22available%22%3A%22%242%2C259.17%22%2C%22current%22%3A%22%242%2C304.33%22%7D%7D%2C%22meta%22%3A%7B%22name%22%3A%22Adv%20Plus%20Banking%22%2C%22number%22%3A%228004%22%7D%2C%22type%22%3A%22depository%22%2C%22subtype%22%3A%22checking%22%7D%5D&institution_id=ins_1&institution_name=Bank%20of%20America&link_session_id=07fc7215-defa-4a98-90b4-981d8356ea08&public_token=public-development-a330a901-e386-47ca-aa13-b18b08ada7da';


    final user = Provider.of<User>(context);
    
    //MediaQueryData queryData = MediaQuery.of(context);
    //var ratio = queryData.devicePixelRatio;
    //Map data = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text('loading', style: TextStyle(fontSize: 20),),
      ),
      body: Text('Balance ${user.accounts.length}'), 
    );
  }
}
