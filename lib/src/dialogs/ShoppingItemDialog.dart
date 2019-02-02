import 'package:flutter/material.dart';
import '../models/ShoppingItem.dart';
import '../blocs/ShoppingItemBloc.dart';
import 'dart:math';

class ShoppingItemDialog extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ShoppingItemDialogState();
}

class _ShoppingItemDialogState extends State<ShoppingItemDialog> {
  final _formKey = GlobalKey<FormState>();

  String _itemName;

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Container(
        decoration: BoxDecoration(
            border:
                Border(bottom: BorderSide(width: 1.0, color: Colors.green))),
        child: Container(
          padding: EdgeInsets.only(top: 15.0, left: 10.0),
          child: Text('Add item'),
        ),
      ),
      titlePadding: EdgeInsets.all(0.0),
      contentPadding: EdgeInsets.all(10.0),
      children: <Widget>[
        Form(
          key: _formKey,
          child: Column(
            children: <Widget>[_itemInput(), _submitButton()],
          ),
        )
      ],
    );
  }

  Widget _submitButton() {
    return Align(
      alignment: Alignment.bottomRight,
      child: MaterialButton(
        color: Colors.blue,
        onPressed: () async {
          if (_formKey.currentState.validate()) {
            _formKey.currentState.save();
            var randomNumber = new Random();

            bloc.addItemToShoppingList(ShoppingItem(
                id: (bloc.totalShoppingItems +1).toString(),
                name: _itemName,
                completed: false));
            Navigator.pop(context);
          }
        },
        child: Text('Add item'),
      ),
    );
  }

  Widget _itemInput() {
    return TextFormField(
      validator: (String value) {
        if (value.isEmpty) return 'Item cannot be blank';
      },
      onSaved: (String value) {
        _itemName = value;
      },
      decoration: InputDecoration(hintText: 'Pack of something'),
    );
  }
}
