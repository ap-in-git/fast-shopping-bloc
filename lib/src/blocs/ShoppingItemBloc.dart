import 'package:rxdart/rxdart.dart';
import '../models/ShoppingItem.dart';
import '../db/db_provider.dart';

class ShoppingItemBloc {
  final _shoppingItems = BehaviorSubject<List<ShoppingItem>>(seedValue: []);

  Observable<List<ShoppingItem>> get allShoppingItems => _shoppingItems.stream;

  int get totalShoppingItems => _shoppingItems.value.length;

  ShoppingItemBloc() {
    _loadInitialData();
  }

  void _loadInitialData() async {
    _shoppingItems.add(await DBProvider.db.getShoppingItems());
  }

  void addItemToShoppingList(ShoppingItem shoppingItem) async {
    List<ShoppingItem> shoppingItems = _shoppingItems.value;
    shoppingItem.id = await DBProvider.db.insertShoppingItem(shoppingItem);
    shoppingItems.add(shoppingItem);
    _shoppingItems.add(shoppingItems);
  }

  void alterShoppingStatus(ShoppingItem shoppingItem) {
    shoppingItem.completed = !shoppingItem.completed;
    //Update the db
    DBProvider.db.alterShoppingItem(shoppingItem);

    //Update the list
    List<ShoppingItem> tempShoppingItems =
        _shoppingItems.value.map((singleItem) {
      return shoppingItem.id == singleItem.id ? shoppingItem : singleItem;
    }).toList();
    _shoppingItems.add(tempShoppingItems);
  }

  void deleteShoppingItem(int id) {
    List<ShoppingItem> tempShoppingItems = _shoppingItems.value;
    DBProvider.db.deleteShoppingItem(id);
    tempShoppingItems.removeWhere((item) => item.id == id);
    _shoppingItems.add(tempShoppingItems);
  }

  dispose() {
    _shoppingItems.close();
  }
}

final bloc = ShoppingItemBloc();
