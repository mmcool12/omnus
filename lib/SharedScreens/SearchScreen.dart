import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:omnus/Models/User.dart';
import 'package:omnus/SharedScreens/SearchResultsScreen.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatelessWidget {
  final searchTerms = <String>['American', 'Italian', 'Thai'];

  @override
  Widget build(BuildContext context) {
    User user;
    DocumentSnapshot snapshot = Provider.of<DocumentSnapshot>(context);
    if (snapshot != null) {
      if (snapshot.data != null) {
        user = User.fromFirestore(snapshot);
      }
    }

    if (user != null) {
      return PlatformScaffold(
          appBar: PlatformAppBar(
            title: Text('Search'),
            ios: (_) =>
                CupertinoNavigationBarData(transitionBetweenRoutes: false),
          ),
          body: ListView.separated(
            itemBuilder: (BuildContext context, int index) {
              String term = searchTerms[index];
              return GestureDetector(
                onTap: () => Navigator.push(
                    context,
                    platformPageRoute(
                        context: context,
                        builder: (BuildContext context) =>
                            SearchResultsScreen(tag: term, user: user))),
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 12.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.fastfood,
                          size: 32,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          term,
                          style: TextStyle(
                            fontFamily: 'Apple SD Gothic Neo',
                            fontSize: 22,
                            color: Colors.black,
                            letterSpacing: 0.17,
                            fontWeight: FontWeight.w600,
                            height: 1.5,
                          ),
                        ),
                        const Spacer(),
                        Icon(Icons.arrow_forward_ios)
                      ],
                    ),
                  ),
                ),
              );
            },
            itemCount: searchTerms.length,
            separatorBuilder: (context, index) =>
                Divider(thickness: 1, height: 0),
          ));
    } else {
      return Center(child: PlatformCircularProgressIndicator());
    }
  }
}
