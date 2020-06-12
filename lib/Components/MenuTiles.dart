import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:omnus/Components/AddMenuItemModal.dart';
import 'package:omnus/Components/EditMenuItemModal.dart';
import 'package:omnus/Components/OrderModal.dart';
import 'package:omnus/Models/Chef.dart';
import 'package:omnus/Models/Meal.dart';

class MenuTiles extends StatelessWidget {
  const MenuTiles({Key key, @required this.chef, this.edit}) : super(key: key);

  final Chef chef;
  final bool edit;
  //'\$${(item['price'] == item['price'].roundToDouble() ? item['price'].round() : item['price'])}'

  @override
  Widget build(BuildContext context) {

    return Material(
      color: Colors.transparent,
      child: ExpansionTile(
          initiallyExpanded: true,
          backgroundColor: Colors.white,
          title: Text(
            'Menu',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
          ),
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 0),
              child: Container(
                child: GridView.count(
                    crossAxisCount: 2,
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    mainAxisSpacing: 24,
                    crossAxisSpacing: 24,
                    shrinkWrap: true,
                    primary: false,
                    children: List.generate(
                      edit ? chef.menu.length + 1 : chef.menu.length,
                      (index) {
                        if (index == chef.menu.length) {
                          return GestureDetector(
                            onTap: () async =>
                            AddMenuItemModal()
                                .showModal(context, chef),
                            child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  boxShadow: [
                                    BoxShadow(
                                        color: const Color(0x36000000),
                                        offset: Offset(0, 3),
                                        blurRadius: 6)
                                  ],
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.add,
                                    color: Colors.white,
                                    size: 50,
                                  )
                                )),
                          );
                        } else {
                          Map<dynamic, dynamic> item = chef.menu[index];
                          item['chefId'] = chef.id;
                          item['chefName'] = chef.name;
                          Meal meal = Meal.fromMap(item);

                          return GestureDetector(
                            onTap: () async =>  edit ? EditMenuItemModal().showModal(context, meal) :
                            OrderModal()
                                .showModal(context, meal, false),
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color(0xffffffff),
                                boxShadow: [
                                  BoxShadow(
                                      color: const Color(0x36000000),
                                      offset: Offset(0, 3),
                                      blurRadius: 6)
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Expanded(
                                          flex: 6,
                                          child: Container(
                                            child: AutoSizeText(
                                              meal.title,
                                              maxLines: 2,
                                              style: TextStyle(
                                                fontFamily: 'Apple SD Gothic Neo',
                                                fontSize: 22,
                                                color: const Color(0xff4e4e4e),
                                                letterSpacing: 0.17,
                                                fontWeight: FontWeight.w600,
                                                height: 1.15,
                                              ),
                                              textAlign: TextAlign.left,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 3,
                                          child: AutoSizeText(
                                            '\$${meal.price.round()}',
                                            maxLines: 1,
                                            style: TextStyle(
                                              fontFamily: 'Apple SD Gothic Neo',
                                              fontSize: 32,
                                              color: const Color(0xff4e4e4e),
                                              letterSpacing: 0.2,
                                              fontWeight: FontWeight.w700,
                                              height: 1,
                                            ),
                                            textAlign: TextAlign.left,
                                          ),
                                        )
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    AutoSizeText(
                                      meal.description,
                                      maxLines: 4,
                                      minFontSize: 10,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontFamily: 'Apple SD Gothic Neo',
                                        fontSize: 16,
                                        color: const Color(0xff4e4e4e),
                                        letterSpacing: 0.12,
                                        height: 1.5,
                                      ),
                                      textAlign: TextAlign.left,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        }
                      },
                    )
                    // separatorBuilder: (context, index) {
                    //   return Padding(
                    //     padding: const EdgeInsets.symmetric(
                    //         vertical: 8.0, horizontal: 25),
                    //   );
                    // },
                    ),
              ),
            ),
            if (chef.menu.length == 0)
              (Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'No Menu Items',
                  style: TextStyle(fontSize: 20),
                ),
              ))
          ]),
    );
  }
}
