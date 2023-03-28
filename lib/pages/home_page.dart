import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/expense_tile.dart';
import '../data/expense_data.dart';
import '../models/expense_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  // text controllers
  final newExpenseNameController = TextEditingController();
  final newExpenseAmountController = TextEditingController();

  // add new expense
  void addNewExpense() {
    showDialog(
      context: context, 
      builder: (context) => AlertDialog(
        title: const Text("Add new expense"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            //expense name
            TextField(
              controller: newExpenseNameController,
            ),

            // expense amount
            TextField(
              controller: newExpenseAmountController,
            ),
          ]

        ),
        actions: [
          // save button 
          MaterialButton(
            onPressed: save, 
            child: const Text(
              "Save"
            ),
          ),

          // cancel button 
          MaterialButton(
            onPressed: cancel, 
            child: const Text(
              "Cancel"
            ),
          ),
        ]
      ),
    );
  }

  // save method
  void save() {
    // create expense item
    ExpenseItem newExpense = ExpenseItem(
      name: newExpenseNameController.text, 
      amount: newExpenseAmountController.text, 
      dateTime: DateTime.now(),
    );
    // add the new expense
    Provider.of<ExpenseData>(context, listen: false).addNewExpense(newExpense);

    Navigator.pop(context);
    clear();
  }

  // cancel method
  void cancel() {
    Navigator.pop(context);
    clear();
  }

  // clear controllwers
  void clear() {
    newExpenseNameController.clear();
    newExpenseAmountController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpenseData>(
      builder: (context, value, child) => Scaffold(
        backgroundColor: Colors.grey[300],
        floatingActionButton: FloatingActionButton(
          onPressed: addNewExpense,
          child: const Icon(Icons.add), 
        ),
        body: ListView.builder(
          itemCount: value.getAllExpenseList().length,
          itemBuilder: (context, index) => ExpenseTile(
            name: value.getAllExpenseList()[index].name,
            amount: value.getAllExpenseList()[index].amount,
            dateTime: value.getAllExpenseList()[index].dateTime,
          ),
        ),
      ),
    );
  }
}