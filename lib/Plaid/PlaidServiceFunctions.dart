
import 'dart:convert';

import 'package:http/http.dart';

class PlaidSerivceFunctions{

  Future getInstitutions () async {
    String url = 'https://development.plaid.com/institutions/get';
    Map<String, String> header = {
        'Content-type': 'application/json',
        'User-Agent': 'Plaid Postman'
    };
    try {
      Response response = await post(url, 
        headers: header,
        body: '{"client_id": "5e21ec08dad2b80015cc8cdd", "secret": "6f7d6f9da36d6fe4aa654ddc2d70aa", "count": 100, "offset": 0}');
        print(response.body);
        return response;
    } catch (error){ 
      print(error);
      return error;
    }
  }

  dynamic getAccessToken(String publicToken) async {
    String url = 'https://development.plaid.com/item/public_token/exchange';
    Map<String, String> header = {
        'Content-type': 'application/json',
        'User-Agent': 'Plaid Postman'
    };
    try{
      Response response = await post(url,
      headers: header,
      body:'{"client_id": "5e21ec08dad2b80015cc8cdd", "secret": "6f7d6f9da36d6fe4aa654ddc2d70aa", "public_token": "$publicToken"}'
      );
      print(response.body);
      return json.decode(response.body);
    } catch (error){
      print(error);
      return null;
    }
  }

  String linkInit = '{'+
    '"key" : "9422ca3c1450bb04842b93f741d0d7",'+
    '"product" : "auth",'+
    '"apiVersion" : "v2",'+
    '"env" : "development",'+
    '"clientName" : "Koalemos",'+
    '"selectAccount" : "true",'+
    '"webhook": "http://requestb.in",'+
  '}';
  String linkInittwo ="?isWebview=true&key=9422ca3c1450bb04842b93f741d0d7"+
    "&product=auth,transactions&apiVersion=v2&env=development&clientName=Koalemos"+
    "&";

  List extractAccounts(String url){
    String decodedUrl = Uri.decodeFull(url);
    String list = decodedUrl.substring(decodedUrl.indexOf("["));
    list = list.substring(0, list.indexOf("&"));
    return json.decode(list);
  }


  String extractToken(String url){
    return url.substring(url.lastIndexOf("=")+1);
  }

 }