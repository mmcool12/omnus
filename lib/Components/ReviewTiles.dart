import 'package:flutter/material.dart';
import 'package:getflutter/components/rating/gf_rating.dart';
import 'package:omnus/Models/Chef.dart';
import 'package:omnus/Models/Review.dart';

class ReviewTile extends StatelessWidget {
  const ReviewTile({
    Key key,
    @required this.chef,
  }) : super(key: key);

  final Chef chef;

  @override
  Widget build(BuildContext context) {
    
    return Material(
      color: Colors.transparent,
      child: ExpansionTile(
          backgroundColor: Colors.white,
          title: Text(
            'Reviews',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
          ),
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Container(
                  child: ListView.separated(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                itemCount: chef.numReviews,
                shrinkWrap: true,
                primary: false,
                itemBuilder: (context, index) {
                  Map<dynamic, dynamic> map = chef.reviews[index];
                  Review review = Review.fromMap(null, map);
                  return Container(
                    decoration: BoxDecoration(
                      color: const Color(0xffffffff),
                      border: Border.all(
                          width: 1.0, color: const Color(0x12707070)),
                      boxShadow: [
                        BoxShadow(
                            color: const Color(0x1a000000),
                            offset: Offset(0, 3),
                            blurRadius: 6)
                      ],
                    ),
                    child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Text(
                                  review.title,
                                  style: TextStyle(
                                    fontFamily: 'Apple SD Gothic Neo',
                                    fontSize: 18,
                                    color: const Color(0xd14e4e4e),
                                    letterSpacing: 0.13,
                                    fontWeight: FontWeight.w600,
                                    height: 1.5384615384615385,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                GFRating(
                                  itemCount: 5,
                                  value: review.rating,
                                  allowHalfRating: true,
                                  size: 20,
                                  color: Colors.amber,
                                  borderColor: Colors.grey,
                                  defaultIcon: GFRating(
                                    size: 20,
                                    itemCount: 1,
                                    value: 1,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4.0),
                            Text(
                              review.description,
                              style: TextStyle(
                                fontFamily: 'Apple SD Gothic Neo',
                                fontSize: 15,
                                color: const Color(0xf24e4e4e),
                                letterSpacing: 0.09,
                                height: 1.3,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ],
                        )),
                  );
                },
                separatorBuilder: (context, index) {
                  return const SizedBox(height: 24);
                },
              )),
            ),
            if (chef.numReviews == 0)
              (Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'No Reviews',
                  style: TextStyle(fontSize: 20),
                ),
              ))
          ]),
    );
  }
}
