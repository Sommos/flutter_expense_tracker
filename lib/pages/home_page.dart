import 'package:flutter/material.dart';
import 'package:fourth_app/components/expense_summary.dart';
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
  final newExpensePoundsController = TextEditingController();
  final newExpensePenceController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // prepare data on startup
    Provider.of<ExpenseData>(
      context, 
      listen: false
    ).prepareData();
  }

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
              decoration: const InputDecoration(
                hintText: "Expense Name",
              ),
            ),

            Row(
              children: [
                // pounds
                Expanded(
                  child: TextField(
                    controller: newExpensePoundsController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: "£",
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                // pence
                Expanded(
                  child: TextField(
                    controller: newExpensePenceController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: "p",
                    ),
                  ),
                ),
              ],
            ),
          ],

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

  // delete method
  void delete(ExpenseItem expense) {
    Provider.of<ExpenseData>(context, listen: false).deleteExpense(expense);
  }

  // edit method
  void edit(ExpenseItem expense) {
    delete(expense);
    addNewExpense();
  }

  // save method
  void save() {
    // only save expense if all fields are filled
    if(newExpenseNameController.text.isNotEmpty && 
      newExpensePoundsController.text.isNotEmpty && 
      newExpensePenceController.text.isNotEmpty) {
      // put pounds and pence together
      String amount = "${newExpensePoundsController.text}.${newExpensePenceController.text}";
      // create expense item
      ExpenseItem newExpense = ExpenseItem(
        name: newExpenseNameController.text, 
        amount: amount, 
        dateTime: DateTime.now(),
      );
      // add the new expense
      Provider.of<ExpenseData>(context, listen: false).addNewExpense(newExpense);
    }

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
    newExpensePoundsController.clear();
    newExpensePenceController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpenseData>(
      builder: (context, value, child) => Scaffold(
        backgroundColor: Colors.grey[300],
        floatingActionButton: FloatingActionButton(
          onPressed: addNewExpense,
          backgroundColor: Colors.black,
          child: const Icon(Icons.add), 
        ),
        body: ListView(children: [
          // weekly summary
          ExpenseSummary(startOfWeek: value.startOfWeekDate()),

          const SizedBox(height: 20),

          // expense list
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: value.getAllExpenseList().length,
            itemBuilder: (context, index) => ExpenseTile(
              name: value.getAllExpenseList()[index].name,
              amount: value.getAllExpenseList()[index].amount,
              dateTime: value.getAllExpenseList()[index].dateTime,
              deleteTapped: (p0) =>
                delete(value.getAllExpenseList()[index]),
              editTapped: (p0) =>
                edit(value.getAllExpenseList()[index]),
            ),
          ),
        ]),
      ),
    );
  }
}