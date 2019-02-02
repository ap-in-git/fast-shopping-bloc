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
      floatingActionButton: Builder(builder: (BuildContext context) {
        return FloatingActionButton(
          onPressed: () => _showPurchaseDialog(context),
          child: Icon(Icons.add_shopping_cart),
        );
      }),
    );
  }

  void _showPurchaseDialog(context) async {
    showDialog(
        context: context,
        builder: (BuildContext dialogContext) => ShoppingItemDialog(context));
  }

  Widget _showShoppingList(context) {
    return StreamBuilder(
      stream: bloc.allShoppingItems,
      builder: (context, AsyncSnapshot<List<ShoppingItem>> snapshot) {
        if (!snapshot.hasData)
          return Center(
            child: CircularProgressIndicator(),
          );
        if (snapshot.data.length == 0) return Text('No items in the list');
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
      onTap: () {
        bloc.alterShoppingStatus(shoppingItem);
      },
      leading: Checkbox(
          value: shoppingItem.completed,
          onChanged: (bool) {
            bloc.alterShoppingStatus(shoppingItem);
          }),
      title: Text(shoppingItem.name),
      trailing: IconButton(
          icon: Icon(Icons.delete),
          onPressed: () {
            bloc.deleteShoppingItem(shoppingItem.id);
            Scaffold.of(context)
                .showSnackBar(SnackBar(content: Text('Deleted ')));
          }),
    );
  }
}
