import 'package:fourth_app/datetime/date_time_helper.dart';
import 'package:fourth_app/models/expense_item.dart';

class ExpenseData {
  // list of ALL expenses
  List<ExpenseItem> overallExpenseList = [];

  // get expenses list
  List<ExpenseItem> getAllExpenseList() {
    return overallExpenseList;
  }

  // add new exspense
  void addNewExpense(ExpenseItem newExpense) {
    overallExpenseList.add(newExpense);
  }

  // delete exspence
  void deleteExpense(ExpenseItem expense) {
    overallExpenseList.remove(expense);
  }

  // get weekday from a DateTime object
  String getDayName(DateTime dateTime) {
    switch(dateTime.weekday) {
      case 1:
        return "Mon";
      case 2:
        return "Tue";
      case 3:
        return "Wed";
      case 4:
        return "Thur";
      case 5:
        return "Fri";
      case 6:
        return "Sat";
      case 7:
        return "Sun";
      default:
        return "";
    }
  }

  // function to get the date from the start of the week
  DateTime startOfWeekDate() {
    DateTime? startOfWeek;

    // get todays date
    DateTime today = DateTime.now();

    // go backwards from today to find sunday
    for(int i = 0; i < 7; i++) {
      if(getDayName(today.subtract(Duration(days: i))) == "Sun") {
        startOfWeek = today.subtract(Duration(days: i));
      }
    }

    return startOfWeek!;
  }

  /* convert overall list of expenses in to a daily expense summary, and then show it to the user as a graph

  overallExpenseList = [
    [food, 2023/03/26, £12],
    [golf, 2023/03/23, £18],
    [hotel, 2023/03/24, £32],
    [bowling, 2023/03/24, £9],
    [drinks, 2023/03/24, £10],
  ]

  dailyExpenseSummary = [
    [20230326: £12],
    [20230326: £4],
    [20230326: £19],
  ]
  */
  
  Map<String, double> calculateDailyExpenseSummary() {
    Map<String, double> dailyExpenseSummary = {

    };

    for(var expense in overallExpenseList) {
      String date = convertDateTimeToString(expense.dateTime);
      double amount = double.parse(expense.amount);

      if(dailyExpenseSummary.containsKey(date)) {
        double currentAmount = dailyExpenseSummary[date]!;
        currentAmount += amount;
        dailyExpenseSummary[date] = currentAmount;
      } else {
        dailyExpenseSummary.addAll({date: amount});
      }
    }

    return dailyExpenseSummary;
  }
}