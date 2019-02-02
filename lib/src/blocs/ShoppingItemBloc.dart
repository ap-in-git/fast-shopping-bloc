import 'package:rxdart/rxdart.dart';
import '../models/ShoppingItem.dart';
import 'package:faker/faker.dart';

class ShoppingItemBloc {
  final _shoppingItems = BehaviorSubject<List<ShoppingItem>>(seedValue: []);

  Observable<List<ShoppingItem>> get allShoppingItems => _shoppingItems.stream;

  int get totalShoppingItems => _shoppingItems.value.length;

  ShoppingItemBloc() {
    _loadDummyData();
  }

  void _loadDummyData() {
    var faker = new Faker();
    List<ShoppingItem> tempShoppingItems = [];
    for (int i = 0; i < 20; i++) {
      tempShoppingItems.add(ShoppingItem(
          id: i.toString(),
          name: faker.food.dish(),
          completed: i % 2 == 0 ? true : false));
    }
    _shoppingItems.add(tempShoppingItems);
  }

  void addItemToShoppingList(ShoppingItem shoppingItem) {
    List<ShoppingItem> shoppingItems = _shoppingItems.value;

    shoppingItems.insert(0, shoppingItem);
    _shoppingItems.add(shoppingItems);
  }

  void alterShoppingStatus(ShoppingItem shoppingItem, bool status) {
    shoppingItem.completed = status;
    List<ShoppingItem> tempShoppingItems =
        _shoppingItems.value.map((singleItem) {
      return shoppingItem.id == singleItem.id ? shoppingItem : singleItem;
    }).toList();
    _shoppingItems.add(tempShoppingItems);
  }

  void deleteShoppingItem(String id){
    List<ShoppingItem> tempShoppingItems = _shoppingItems.value;
    tempShoppingItems.removeWhere((item)=>item.id == id);
    _shoppingItems.add(tempShoppingItems);
  }

  dispose() {
    _shoppingItems.close();
  }
}

final bloc = ShoppingItemBloc();
