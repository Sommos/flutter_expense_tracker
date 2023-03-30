import 'package:hive_flutter/hive_flutter.dart';

import '../models/expense_item.dart';

class HiveDataBase {
  // reference box
  final _myBox = Hive.box("expense_database");

  // write data
  void saveData(List<ExpenseItem> allExpense) {
    /* 
    hive can only store primitive data types, and not custom objects like ExpenseItem without additional setup

    allExpense =
      [
        ExpenseItem(name / amount / dateTime),
        ..
      ]

      ->
      
      [
        [name, amount, dateTime],
        ..
      ]
    */

    List<List<dynamic>> allExepensesFormatted = [];

    for(var expense in allExpense) {
      // convert each expenseItem into a list of storage types
      List<dynamic> expenseFormatted = [
        expense.name,
        expense.amount,
        expense.dateTime,
      ];
      allExepensesFormatted.add(expenseFormatted);
    }

    // finally store in the database
    _myBox.put("ALL_EXPENSES", allExepensesFormatted);
  }

  // read data
  List<ExpenseItem> readData() {
    /*
    data is stored in hive as a list of strings and dateTime
    so we will need to convert the saved data in to ExepenseItem objects

    savedData = 
      [
        [name, amount, dateTime],
        ..
      ]

      ->

      [
        ExepnseItem(name / amount / dateTime),
        ..
      ]
    */

    List savedExpenses = _myBox.get("ALL_EXPENSES") ?? [];
    List<ExpenseItem> allExpenses = [];

    for(int i = 0; i < savedExpenses.length; i++) {
      // collect individual expense data
      String name = savedExpenses[i][0];
      String amount = savedExpenses[i][1];
      DateTime dateTime = savedExpenses[i][2];

      // create ExpenseItem object
      ExpenseItem expense = 
        ExpenseItem(
          name: name, 
          amount: amount, 
          dateTime: dateTime,
        );
      
      // add expense to overall list of expenses
      allExpenses.add(expense);
    }

    return allExpenses;
  }
}