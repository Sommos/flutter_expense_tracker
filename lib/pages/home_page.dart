import 'package:flutter/material.dart';
import 'package:fourth_app/components/expense_summary.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';

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
  void addNewExpense(
    {edit = false, 
    oldTextData = "", 
    oldPoundsData = "", 
    oldPenceData = "",
    text = ""}
  ) {
    // if an edit is being done change the texts to contain what is retrieved from the hive database
    if(edit) {
      newExpenseNameController.text = oldTextData;
      newExpensePoundsController.text = oldPoundsData;
      newExpensePenceController.text = oldPenceData;
      text = "Edit an expense";
    } else {
      text = "Add new expense";
    }

    showDialog(
      context: context, 
      builder: (context) => AlertDialog(
        title: Text(text),
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
  void edit (ExpenseItem expense) {
    // split the string returned from 'expense.amount'
    List<String> split = expense.amount.split('.');

    // save the split amounts in independent variables
    String pounds = split[0];
    String pence = split[1];

    // put the data in to the text fields
    addNewExpense(
      edit: true, 
      oldTextData: expense.name, 
      oldPoundsData: pounds, 
      oldPenceData: pence
    );
  }

  // save method
  void save() {
    // only save expense if all fields are filled
    if(newExpenseNameController.text.isNotEmpty && 
      newExpensePoundsController.text.isNotEmpty && 
      newExpensePenceController.text.isNotEmpty) {

      // set string to first letter uppercase
      String capitalisedText = newExpenseNameController.text.substring(0, 1).toUpperCase() + newExpenseNameController.text.substring(1);

      // if the pence has been entered with only one digit, append a zero
      if (newExpensePenceController.text.length < 2) {
        newExpensePenceController.text += "0";
      }

      // put pounds and pence together
      String amount = "${newExpensePoundsController.text}.${newExpensePenceController.text}";

      // create expense item
      ExpenseItem newExpense = ExpenseItem(
        name: capitalisedText, 
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