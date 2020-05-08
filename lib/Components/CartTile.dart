import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:omnus/Components/OrderModal.dart';
import 'package:omnus/Models/Cart.dart';
import 'package:omnus/Models/Meal.dart';
import 'package:provider/provider.dart';

class CartTile extends StatelessWidget {
  const CartTile({Key key, @required this.meal}) : super(key: key);

  final List<Meal> meal;
  
  @override
  Widget build(BuildContext context) {
    Cart cart = Provider.of<Cart>(context, listen: false);
    
    Meal item = this.meal[0];
    double height = MediaQuery.of(context).size.height;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        color: Colors.transparent,
        child: Card(
          elevation: 2,
          child: Container(
            height: 80,
            child: ListTile(
              leading: Padding(
                padding: const EdgeInsets.fromLTRB(0,16,0,0),
                child: Text('${meal.length}'),
              ),
              title: Text(item.title),
              subtitle: Text(item.description, overflow: TextOverflow.ellipsis, maxLines: 2),
              isThreeLine: true,
              trailing: Padding(
                padding: const EdgeInsets.fromLTRB(0,0,0,0),
                child: PlatformIconButton(
                  icon: Icon(
                    PlatformIcons(context).delete,
                    color: Colors.grey,
                    ),
                  onPressed: () => cart.remove(meal),
                ),
              ),
              onTap: () => OrderModal().showModal(context, meal[0], true),
            ),
          ),
        ),
      ),
    );
  }

}