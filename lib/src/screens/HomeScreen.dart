import 'package:flutter/material.dart';
import '../dialogs/ShoppingItemDialog.dart';
import '../blocs/ShoppingItemBloc.dart';
import '../models/ShoppingItem.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('Shopping list'),
          bottom: TabBar(tabs: <Widget>[
            Text('All items'),
            Text('Completed'),
            Text('Not completed')
          ]),
        ),
        body: TabBarView(children: [
          _showShoppingList(context),
          _buildCompletedItems(),
           _buildUncompletedItems()
        ]),
        floatingActionButton: Builder(builder: (BuildContext context) {
          return FloatingActionButton(
            onPressed: () => _showPurchaseDialog(context),
            child: Icon(Icons.add_shopping_cart),
          );
        }),
      ),
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
        if (snapshot.data.length == 0) return _buildEmptyCart();
        return ListView(
          children: snapshot.data
              .map((shoppingItem) => SingleShoppingItem(shoppingItem))
              .toList(),
        );
      },
    );
  }

  Widget _buildCompletedItems() {
    return StreamBuilder(
      stream: bloc.completedShoppingItems,
      builder: (context, AsyncSnapshot<List<ShoppingItem>> snapshot) {
        if (!snapshot.hasData)
          return Center(
            child: CircularProgressIndicator(),
          );
        if (snapshot.data.length == 0) return _buildEmptyCart();
        return ListView(
          children: snapshot.data
              .map((shoppingItem) => SingleShoppingItem(shoppingItem))
              .toList(),
        );
      },
    );
  }

  Widget _buildUncompletedItems() {
    return StreamBuilder(
      stream: bloc.unCompletedShoppingItems,
      builder: (context, AsyncSnapshot<List<ShoppingItem>> snapshot) {
        if (!snapshot.hasData)
          return Center(
            child: CircularProgressIndicator(),
          );
        if (snapshot.data.length == 0) return _buildEmptyCart();
        return ListView(
          children: snapshot.data
              .map((shoppingItem) => SingleShoppingItem(shoppingItem))
              .toList(),
        );
      },
    );
  }

  Widget _buildEmptyCart(){

//    return Text('No item found');
    return Image.asset('assets/empty_cart.png');
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
