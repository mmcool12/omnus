import 'package:flutter/material.dart';
import 'package:omnus/Models/Chef.dart';



class ChefDetailsScreen extends StatelessWidget {
  final Chef chef;

  @override
  const ChefDetailsScreen({
      Key key,
      @required this.chef
    }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text('Chef ${chef.name}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              height: height*.2,
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                                          child: CircleAvatar(
                          backgroundColor: Colors.blueAccent,
                          radius: 56,
                        ),
                      ),
                      Expanded(
                        flex: 2,
                                          child: Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Text(
                                chef.name,
                                style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1,
                                ),
                                textAlign: TextAlign.right,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    '4.3',
                                    style: TextStyle(
                                      color: Colors.amber,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22,
                                    ),
                                  ),
                                  Padding(padding: EdgeInsets.symmetric(horizontal: 2)),
                                  Container(
                                    height: 30,
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      reverse: true,
                                      scrollDirection: Axis.horizontal,
                                      itemCount: 5,
                                      itemBuilder: (context, index){
                                        int rating = 4;
                                        return Icon(
                                          rating > index ? Icons.star : Icons.star_border,
                                          color: Colors.amber,
                                          size: 22,
                                        );
                                      }
                                    ),
                                  ),
                                ],
                              ),
                              FlatButton(
                                onPressed: () => null,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(3),
                                    color: Colors.blue,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical:  12.0, horizontal: 24.0),
                                    child: Text('Message ${chef.firstName}'),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
            Container(
              height: height*.2,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 5,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Container(
                      width: height*.2,
                      color: Colors.blueAccent,
                      child: Center(
                        child: Text('Image'),
                      ),
                    ),
                  );
                }),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
              child: Text(
                'Menu',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
