import 'package:flutter/material.dart';
import '../models/ShoppingItem.dart';
import '../blocs/ShoppingItemBloc.dart';

class ShoppingItemDialog extends StatefulWidget {
  final BuildContext originalContext;
  ShoppingItemDialog(this.originalContext);

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

            bloc.addItemToShoppingList(ShoppingItem(
                name: _itemName,
                completed: false));
            Scaffold.of(widget.originalContext).showSnackBar(SnackBar(content: Text('Item added succesfully')));
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
