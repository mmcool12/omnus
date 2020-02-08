
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class AuthLoading extends StatelessWidget {
  @override

  Widget build(BuildContext context) {
    MediaQueryData queryData = MediaQuery.of(context);
    var ratio = queryData.devicePixelRatio;

    return Container(
      child: Center(
        child: SpinKitRing(
          color: Colors.yellow[800],
          size: ratio*16,
        ),
      ),
    );
  }
}