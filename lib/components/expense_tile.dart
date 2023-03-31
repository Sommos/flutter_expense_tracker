import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ExpenseTile extends StatelessWidget {
  final String name;
  final String amount;
  final DateTime dateTime;
  void Function(BuildContext)? deleteTapped;

  ExpenseTile({
    super.key, 
    required this.name, 
    required this.amount, 
    required this.dateTime,
    required this.deleteTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Slidable(
      endActionPane: ActionPane(
        motion: const StretchMotion(),
        children: [
          // delete button
          SlidableAction(
            onPressed: deleteTapped,
            icon: Icons.delete_outlined,
            backgroundColor: Colors.red,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(4), 
              bottomLeft: Radius.circular(4),
            ),
          ),
          // edit button
          SlidableAction(
            // !change onPressed argument to edit function! //
            onPressed: deleteTapped,
            icon: Icons.settings,
            backgroundColor: Colors.green,
          ),
        ]
      ),
      child: Padding(
        padding: const EdgeInsets.only(
          left: 15, 
          right: 15,
        ),
        child: ListTile(
          title: Text(name),
          subtitle: Text(
            "${dateTime.day} / ${dateTime.month} /  ${dateTime.year}",
          ),
          trailing: Text("\$$amount"),
        ),
      ),
    );
  }
}