import 'package:flutter/material.dart';
import 'package:omnus/Models/Chef.dart';

class ReviewTile extends StatelessWidget {
  const ReviewTile({
    Key key,
    @required this.chef,
  }) : super(key: key);

  final Chef chef;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return Material(
                color: Colors.transparent,
                child: ExpansionTile(
                    backgroundColor: Colors.white,
                    title: Text(
                      'Reviews',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                    ),
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Container(
                          child: ListView.separated(
                            padding: EdgeInsets.all(0),
                            itemCount: chef.numReviews,
                            shrinkWrap: true,
                            primary: false,
                            itemBuilder: (context, index) {
                              Map<dynamic, dynamic> review = chef.reviews[index];
                              return Container(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      Expanded(
                                          flex: 3,
                                          child: Container(
                                            height: height * .12,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                      Text(
                                                        review['title'],
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 22),
                                                      ),
                                                      Text(
                                                        review['description'],
                                                        style: TextStyle(
                                                            color: Colors.grey,
                                                            fontSize: 15),
                                                          maxLines: 3,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )),
                                      Expanded(
                                          flex: 1,
                                          child: Container(
                                            height: height*.1,
                                            child: Stack(
                                              alignment: Alignment.center,
                                              children: <Widget>[
                                                Center(
                                                  child: Icon(
                                                    Icons.star,
                                                    color: Colors.amber,
                                                    size: 90,
                                                  ),
                                                ),
                                                Text(
                                                  '${review['rating']}',
                                                  style: TextStyle(
                                                    fontSize: 25
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                            separatorBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 25),
                              );
                            },
                          )
                        ),
                      ),
                    if(chef.numReviews == 0) (
                      Padding(
                       padding: const EdgeInsets.all(8.0),
                       child: Text(
                         'No Reviews',
                         style: TextStyle(
                           fontSize: 20
                         ),
                        ),
                     )
                    )
                    ]
                    ),
              );
  }
}
