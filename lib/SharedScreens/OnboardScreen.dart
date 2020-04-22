import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:omnus/Firestore/UserFunctions.dart';
import 'package:provider/provider.dart';

class OnboardScreen extends StatefulWidget {
  @override
  _OnboardScreenState createState() => _OnboardScreenState();
}

class _OnboardScreenState extends State<OnboardScreen> {

  final TextEditingController firstText = TextEditingController();
  final FocusNode firstFocus = FocusNode();
  final TextEditingController lastText = TextEditingController();
  final FocusNode lastFocus = FocusNode();
  final TextEditingController phoneText = TextEditingController();
  final FocusNode phoneFocus = FocusNode();
  final TextEditingController zipText = TextEditingController();
  final FocusNode zipFocus = FocusNode();
  FirebaseUser user;
  

  final kHintTextStyle = TextStyle(
    color: Colors.white54,
    fontFamily: 'OpenSans',
  );

  final kLabelStyle = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
    fontFamily: 'OpenSans',
  );

  final kBoxDecorationStyle = BoxDecoration(
    color: Color(0xFF6CA8F1),
    borderRadius: BorderRadius.circular(10.0),
    boxShadow: [
      BoxShadow(
        color: Colors.black12,
        blurRadius: 6.0,
        offset: Offset(0, 2),
      ),
    ],
  );

  signUp() async {
    Map data = ModalRoute.of(context).settings.arguments;
    String firstName = firstText.text.trim();
    String lastName = lastText.text.trim();
    String phoneNumber = phoneText.text.trim();
    String zipCode = zipText.text.trim();
    try{
      await UserFunctions().createFireStoreUser(user.uid, data['email'], firstName, lastName, phoneNumber, zipCode);
      await Future.delayed(Duration(milliseconds: 300));
      Navigator.popUntil(context,ModalRoute.withName('/'));
    } catch (e){
      print(e);
    }
  }

  Widget firstField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'First Name',
          style: kLabelStyle,
        ),
        SizedBox(height: 10),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60,
          child: TextField(
            controller: firstText,
            focusNode: firstFocus,
            textInputAction: TextInputAction.next,
            style: TextStyle(color: Colors.white, fontFamily: 'OpenSans'),
            decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 4, left: 8),
                hintText: 'First Name',
                hintStyle: kHintTextStyle
            ),
            onSubmitted: (term) {
              firstFocus.unfocus();
              FocusScope.of(context).requestFocus(lastFocus);
            },
          ),
        )
      ],
    );
  }

  Widget lastField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Last Name',
          style: kLabelStyle,
        ),
        SizedBox(height: 10),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60,
          child: TextField(
            controller: lastText,
            focusNode: lastFocus,
            textInputAction: TextInputAction.next,
            style: TextStyle(color: Colors.white, fontFamily: 'OpenSans'),
            decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 4, left: 8),
                hintText: 'Last Name',
                hintStyle: kHintTextStyle
            ),
            onSubmitted: (term) {
              lastFocus.unfocus();
              FocusScope.of(context).requestFocus(phoneFocus);
            },
          ),
        )
      ],
    );
  }
  
  Widget phoneField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Phone Number',
          style: kLabelStyle,
        ),
        SizedBox(height: 10),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60,
          child: TextField(
            controller: phoneText,
            focusNode: phoneFocus,
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.next,
            style: TextStyle(color: Colors.white, fontFamily: 'OpenSans'),
            decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 4, left: 8),
                hintText: 'Phone Number',
                hintStyle: kHintTextStyle
            ),
            onSubmitted: (term) {
              phoneFocus.unfocus();
              FocusScope.of(context).requestFocus(zipFocus);
            },
          ),
        )
      ],
    );
  }

  Widget zipField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Zip Code',
          style: kLabelStyle,
        ),
        SizedBox(height: 10),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60,
          child: TextField(
            controller: zipText,
            focusNode: zipFocus,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.done,
            style: TextStyle(color: Colors.white, fontFamily: 'OpenSans'),
            decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 4, left: 8),
                hintText: 'Zip Code',
                hintStyle: kHintTextStyle
            ),
            onSubmitted: (string) => signUp,
          ),
        )
      ],
    );
  }

  Widget forgotPassword() {
    return Container(
      alignment: Alignment.centerRight,
      child: FlatButton(
          onPressed: () => print('Forgot Password'),
          child: Text(
            'Forgot Password?',
            style: kLabelStyle,
          )),
    );
  }

  Widget signupButton() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5,
        onPressed: signUp,
        padding: EdgeInsets.all(15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        color: Colors.white,
        child: Text(
          'ENTER APP',
          style: TextStyle(
            color: Colors.blueAccent,
            letterSpacing: 1.5,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }


 @override
  void dispose() {
    firstText.dispose();
    firstFocus.dispose();
    lastText.dispose();
    lastFocus.dispose();
    phoneText.dispose();
    phoneFocus.dispose();
    zipText.dispose();
    zipFocus.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    user = Provider.of<FirebaseUser>(context);

    return Scaffold(
      backgroundColor: Colors.blue[400],
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(
            children: <Widget>[
              Container(
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                      Colors.blue[100],
                      Colors.blue[200],
                      Colors.blue[300],
                      Colors.blue[400],
                    ],
                        stops: [
                      0.1,
                      0.4,
                      0.7,
                      0.9
                    ])),
              ),
              Container(
                height: double.infinity,
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 120),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Onboard',
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'OpenSans',
                            fontSize: 30,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 65,
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(child: firstField()),
                          Padding(padding: EdgeInsets.symmetric(horizontal: 4.0)),
                          Expanded(child: lastField())
                        ],
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(child: phoneField()),
                          Padding(padding: EdgeInsets.symmetric(horizontal: 4.0)),
                          Expanded(child: zipField())
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: signupButton(),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
