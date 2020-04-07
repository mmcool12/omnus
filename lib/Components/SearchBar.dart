
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:omnus/Firestore/SearchFunctions.dart';
import 'package:omnus/Models/Chef.dart';

class SearchBar extends SearchDelegate<Chef>{

  final recentSearches = [];

  @override
  List<Widget> buildActions(BuildContext context){
    return [
      IconButton(icon: Icon(Icons.clear), onPressed: () => query = "")
    ];
  }

  @override
  Widget buildLeading(BuildContext context){
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation), 
        onPressed: () => close(context, null)
    );
  }

  @override
  Widget buildResults(BuildContext context){
    
  }

  @override
  Widget buildSuggestions(BuildContext context){
    List<Chef> results = [];
    if(query == ""){
      return ListView.builder(
        itemCount: recentSearches.length ?? 0,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(recentSearches[index].name ?? 'No results'),
          );
        });
    } else{
    return FutureBuilder<QuerySnapshot>(
      future: SearchFunctions().getChefbyName(query),
      builder: (context,  snapshot) {
        if(snapshot.hasData){
          if(snapshot.data.documents == null || snapshot.data.documents.isEmpty){
            return Center(child: Text('No Results'));
          } else {
            List<Chef> temp = [];
            for (DocumentSnapshot snapshot in snapshot.data.documents) {
              temp.add(Chef.fromFirestore(snapshot));
            }
            results = temp;
            return ListView.builder(
              itemCount: results.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(results[index].name),
                );
              });
          }
        } else {
          return Center(child: Text('Loading'));
        }
      },
    );
    }
  }
   
}