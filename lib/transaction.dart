import 'package:flutter/material.dart';

class MyTransaction extends StatelessWidget {
  final String TransactionName;
  final String Money;
  final String IncomeOrExpense;
  const MyTransaction(
      {super.key,
      required this.TransactionName,
      required this.Money,
      required this.IncomeOrExpense});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: Container(
          padding: EdgeInsets.all(15.0),
          color: Colors.grey[200],
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.grey[500],
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Icon(
                        Icons.attach_money_outlined,
                        color: Colors.white,
                        size: 25,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Text(
                    TransactionName,
                    style: TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                ],
              ),
              Text(
                (IncomeOrExpense == 'expense' ? '- ' : '+ ') + "\$$Money",
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: (IncomeOrExpense == 'expense'
                      ? Colors.red
                      : Colors.green),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
