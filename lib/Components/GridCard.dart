import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:omnus/Firestore/ImageFunctions.dart';
import 'package:omnus/Models/Chef.dart';
import 'package:omnus/Models/User.dart';
import 'package:omnus/SharedScreens/ChefDetailsScreen.dart';

class GridCard extends StatelessWidget {
  const GridCard({
    Key key,
    @required this.chef,
    @required this.user
  }) : super(key: key);

  final Chef chef;
  final User user;

    String chefType(String type) {
    if (type == 'both') {
      return 'Chef & Prep';
    } else if (type == 'chef') {
      return 'Chef';
    } else {
      return 'Prep';
    }
  }

  @override
  Widget build(BuildContext context) {
    double textScale = MediaQuery.of(context).textScaleFactor;
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      color: Colors.white,
      child: InkWell(
        onTap: () => Navigator.push(context, 
         platformPageRoute(context: context, builder: (BuildContext context) => ChefDetailsScreen(chef: chef, user: user))),
        child: Stack(
          children: <Widget>[
            Container(
              height: 240,
              decoration: BoxDecoration(borderRadius:  BorderRadius.circular(10)),
              width: double.infinity,
              child: FutureBuilder<dynamic>(
                future: ImageFunctions().getImage(chef.mainImage),
                builder: (context, snapshot) {
                  if(snapshot.connectionState == ConnectionState.done && snapshot.hasData){
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                        child: CachedNetworkImage(
                              imageUrl: snapshot.data,
                              placeholder: (context, url) => Center(child: PlatformCircularProgressIndicator()),
                              fit: BoxFit.cover,
                            ),
                    );
                  } else {
                    return Center(child: PlatformCircularProgressIndicator());
                  }
                }
                ),
            ),
            Positioned(
              bottom: 0,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      chef.name,
                      style: GoogleFonts.montserrat(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 20 * textScale,
                        shadows: [
                          Shadow( 
                            offset: Offset(1.0, 1.0),
                            blurRadius: 2,
                            //color: Colors.black38.withOpacity(.5)
                          )
                        ]
                      )
                    ),
                    Text(
                      chef.tags[0],
                      style: GoogleFonts.montserrat(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18 * textScale,
                      )
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
