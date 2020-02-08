import 'package:flutter/material.dart';
import 'package:omnus/Auth/AuthFunctions.dart';
import 'package:omnus/MainScreens/OverviewScreen.dart';
import 'package:omnus/MainScreens/SettingsScreen.dart';
import 'package:omnus/MainScreens/CardsScreen.dart';
import 'package:page_view_indicators/circle_page_indicator.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthFunctions _auth = AuthFunctions();
  
  final _controller = PageController(initialPage: 1);
  final _currentPageNotifier = ValueNotifier<int>(1);
  int currentPage = 1;
  String info;

  void printWrapped(String text) {
  final pattern = new RegExp('.{1,800}'); // 800 is the size of each chunk
  pattern.allMatches(text).forEach((match) => print(match.group(0)));
}


  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        PageView(
          controller: _controller,
          children: <Widget>[SettingsScreen(), OverviewScreen(), CardsScreen()],
          onPageChanged: (int page) => _currentPageNotifier.value = page,
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Padding(
            padding: EdgeInsets.all(16),
            child: CirclePageIndicator(
              itemCount: 3,
              currentPageNotifier: _currentPageNotifier,
            ),
          ),
        )
      ],
    );
  }
}
