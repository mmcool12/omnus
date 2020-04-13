import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:omnus/Auth/AuthFunctions.dart';
import 'package:omnus/Auth/AuthLoading.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final TextEditingController emailText = TextEditingController();
  final FocusNode emailFocus = FocusNode();
  final TextEditingController passwordText = TextEditingController();
  final FocusNode passwordFocus = FocusNode();
  bool loading = false;

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

  signIn() async {
    //Validate email and password
    String email = emailText.text.trim();
    String password = passwordText.text.trim();
    if(password.length > 6) {
      setState(() => loading = true);
      dynamic result = await AuthFunctions().signIn(email, password);
      if(result == null) {
        setState(() => loading = false);
        print('error:');
      } else {
        setState(() => loading = false);
        Navigator.popUntil(context, ModalRoute.withName('/'));
      }
    } else {
      print('Password too short');
    }
  }

  Widget emailField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Email',
          style: kLabelStyle,
        ),
        SizedBox(height: 10),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60,
          child: TextField(
            controller: emailText,
            focusNode: emailFocus,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            style: TextStyle(color: Colors.white, fontFamily: 'OpenSans'),
            decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 14),
                prefixIcon: Icon(Icons.email, color: Colors.white),
                hintText: 'Enter your Email',
                hintStyle: kHintTextStyle
            ),
            onSubmitted: (term) {
              emailFocus.unfocus();
              FocusScope.of(context).requestFocus(passwordFocus);
            },
          ),
        )
      ],
    );
  }

  Widget passwordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Password',
          style: kLabelStyle,
        ),
        SizedBox(height: 10),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60,
          child: TextField(
            controller: passwordText,
            obscureText: true,
            textInputAction: TextInputAction.done,
            style: TextStyle(color: Colors.white, fontFamily: 'OpenSans'),
            decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 14),
                prefixIcon: Icon(Icons.lock, color: Colors.white),
                hintText: 'Enter your Password',
                hintStyle: kHintTextStyle
            ),
            onSubmitted: (string) => signIn,
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

  Widget loginButton() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5,
        onPressed: () async {signIn();},
        padding: EdgeInsets.all(15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        color: Colors.white,
        child: Text(
          'LOGIN',
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

  Widget signUp() {
    return GestureDetector(
      onTap: () => Navigator.pushReplacementNamed(context, '/Auth/Signup'),
      child: RichText(
        text: TextSpan(children: [
          TextSpan(
              text: 'Don\'t have an Account? ',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                  fontWeight: FontWeight.w400)),
          TextSpan(
              text: 'Sign up',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                  fontWeight: FontWeight.w400))
        ]),
      ),
    );
  }

 @override
  void dispose() {
    emailText.dispose();
    emailFocus.dispose();
    passwordText.dispose();
    passwordFocus.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
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
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 120),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Sign In',
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'OpenSans',
                            fontSize: 30,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      (loading ? 
                        Padding(padding: EdgeInsets.only(bottom: 15), child: AuthLoading()) 
                        : Padding(padding: EdgeInsets.all(0))),
                      Material(color: Colors.transparent, child: emailField()),
                      SizedBox(
                        height: 30,
                      ),
                      Material(color: Colors.transparent, child: passwordField()),
                      //forgotPassword(),
                      loginButton(),
                      signUp()
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
