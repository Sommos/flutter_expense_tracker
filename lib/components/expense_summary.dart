import 'package:flutter/material.dart';
import 'package:fourth_app/bar%20graph/bar_graph.dart';
import 'package:provider/provider.dart';

import '../data/expense_data.dart';

class ExpenseSummary extends StatelessWidget {
  final DateTime startOfWeek;
  const ExpenseSummary({
    super.key,
    required this.startOfWeek,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpenseData>(
      builder: (context, value, child) => SizedBox(
        height: 200,
        child: MyBarGraph(
          maxY: 100,
          sunAmount: 39,
          monAmount: 3,
          tueAmount: 25,
          wedAmount: 46,
          thurAmount: 50,
          friAmount: 73,
          satAmount: 95,
        )
      )
    );
  }
}