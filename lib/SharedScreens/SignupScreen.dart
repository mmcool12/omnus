import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:omnus/Auth/AuthFunctions.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {

  final TextEditingController emailText = TextEditingController();
  final FocusNode emailFocus = FocusNode();
  final TextEditingController passwordText = TextEditingController();
  final FocusNode passwordFocus = FocusNode();
  final TextEditingController confirmText = TextEditingController();
  final FocusNode confirmFocus = FocusNode();

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
    String email = emailText.text.trim();
    String password = passwordText.text.trim();
    String confirm = confirmText.text.trim();
    if(password.length > 6 && confirm == password) {
      await AuthFunctions().signUp(email, password);
      Navigator.pushNamed(context, '/Auth/Onboard' , arguments: {'email' : email});
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
            focusNode: passwordFocus,
            obscureText: true,
            textInputAction: TextInputAction.next,
            style: TextStyle(color: Colors.white, fontFamily: 'OpenSans'),
            decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 14),
                prefixIcon: Icon(Icons.lock, color: Colors.white),
                hintText: 'Enter your Password',
                hintStyle: kHintTextStyle
            ),
            onSubmitted: (term) {
              passwordFocus.unfocus();
              FocusScope.of(context).requestFocus(confirmFocus);
            },
          ),
        )
      ],
    );
  }
  
  Widget confirmField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Confirm Password',
          style: kLabelStyle,
        ),
        SizedBox(height: 10),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60,
          child: TextField(
            controller: confirmText,
            focusNode: confirmFocus,
            obscureText: true,
            textInputAction: TextInputAction.done,
            style: TextStyle(color: Colors.white, fontFamily: 'OpenSans'),
            decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 14),
                prefixIcon: Icon(Icons.lock, color: Colors.white),
                hintText: 'Confirm your Password',
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
          'SIGNUP',
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

  Widget signIn() {
    return GestureDetector(
      onTap: () => Navigator.pushReplacementNamed(context, '/Auth/Login'),
      child: RichText(
        text: TextSpan(children: [
          TextSpan(
              text: 'Already have an account? ',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                  fontWeight: FontWeight.w400)),
          TextSpan(
              text: 'Sign in',
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
    confirmText.dispose();
    confirmFocus.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
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
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 120),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Sign Up',
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'OpenSans',
                            fontSize: 30,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      emailField(),
                      SizedBox(
                        height: 30,
                      ),
                      passwordField(),
                      SizedBox(
                        height: 30,
                      ),
                      confirmField(),
                      signupButton(),
                      signIn(),
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
