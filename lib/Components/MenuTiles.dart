import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:omnus/Components/AddMenuItemModal.dart';
import 'package:omnus/Components/OrderModal.dart';
import 'package:omnus/Firestore/ImageFunctions.dart';
import 'package:omnus/Models/Chef.dart';
import 'package:omnus/Models/Meal.dart';

class MenuTiles extends StatelessWidget {
  const MenuTiles({Key key, @required this.chef, this.edit}) : super(key: key);

  final Chef chef;
  final bool edit;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return Material(
      color: Colors.transparent,
      child: ExpansionTile(
        initiallyExpanded: true,
        leading: (!edit ? null : 
          IconButton(
            icon: Icon(PlatformIcons(context).addCircledOutline), 
            onPressed: () async => AddMenuItemModal().showModal(context, chef)
          )
        ),
          backgroundColor: Colors.white,
          title: Text(
            'Menu',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
          ),
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 0),
              child: Container(
                child: ListView.separated(
                  padding: EdgeInsets.all(0),
                  itemCount: chef.menu.length,
                  shrinkWrap: true,
                  primary: false,
                  itemBuilder: (context, index) {
                    Map<dynamic, dynamic> item = chef.menu[index];
                    item['chefId'] = chef.id;
                    item['chefName'] = chef.name;

                    return GestureDetector(
                      onTap: () =>  OrderModal().showModal(context, Meal.fromMap(item), false),
                      child: Container(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Expanded(
                                  flex: 3,
                                  child: Container(
                                    height: 100,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                item['title'],
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 22),
                                              ),
                                              Text(
                                                item['description'],
                                                style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 15),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                          Text(
                                            '\$${(item['price'] == item['price'].roundToDouble() ? item['price'].round() : item['price'])}',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 17,
                                                color: Colors.teal),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )),
                              Expanded(
                                  flex: 1,
                                  child: (item['image'] == ""
                                      ? Container()
                                      : Center(
                                          child: Container(
                                            height: 80,
                                            child: FutureBuilder<dynamic>(
                                                future: ImageFunctions()
                                                    .getImage(item['image']),
                                                builder: (context, snapshot) {
                                                  if (snapshot.hasData) {
                                                    item['fireImage'] = snapshot.data;
                                                    return CachedNetworkImage(
                                                      imageUrl: snapshot.data,
                                                      fit: BoxFit.cover,
                                                      placeholder: (context,
                                                              url) =>
                                                          Center(
                                                              child:
                                                                  PlatformCircularProgressIndicator()),
                                                    );
                                                  } else {
                                                    return Container();
                                                  }
                                                }),
                                          ),
                                        )))
                            ],
                          ),
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
                ),
              ),
            ),
            if(chef.menu.length == 0) (
                      Padding(
                       padding: const EdgeInsets.all(8.0),
                       child: Text(
                         'No Menu Items',
                         style: TextStyle(
                           fontSize: 20
                         ),
                        ),
                     )
                    )
          ]),
    );
  }
}
