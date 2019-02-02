import 'package:flutter/material.dart';
import '../dialogs/ShoppingItemDialog.dart';
import '../blocs/ShoppingItemBloc.dart';
import '../models/ShoppingItem.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shopping list'),
      ),
      body: _showShoppingList(context),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showPurchaseDialog(context),
        child: Icon(Icons.add_shopping_cart),
      ),
    );
  }

  void _showPurchaseDialog(context) async {
    showDialog(
        context: context,
        builder: (BuildContext context) => ShoppingItemDialog());
  }

  Widget _showShoppingList(context) {
    return StreamBuilder(
      stream: bloc.allShoppingItems,
      builder: (context, AsyncSnapshot<List<ShoppingItem>> snapshot) {
        if (!snapshot.hasData || snapshot.data.length == 0)
          return Text('No items in the list');

        return ListView(
          children: snapshot.data
              .map((shoppingItem) => SingleShoppingItem(shoppingItem))
              .toList(),
        );
      },
    );
  }
}

class SingleShoppingItem extends StatelessWidget {
  SingleShoppingItem(this.shoppingItem);

  final ShoppingItem shoppingItem;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Checkbox(value: shoppingItem.completed, onChanged: (bool itemChecked){
        bloc.alterShoppingStatus(shoppingItem, itemChecked);
      }),
      title: Text(shoppingItem.name),
      trailing: IconButton(icon:Icon(Icons.delete), onPressed: (){
        bloc.deleteShoppingItem(shoppingItem.id);
      }),
    );
  }
}
