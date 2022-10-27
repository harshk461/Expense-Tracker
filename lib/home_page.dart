import 'dart:async';
import 'package:expense_tracker/google_sheet_api.dart';
import 'package:expense_tracker/loading.dart';
import 'package:expense_tracker/plus_button.dart';
import 'package:expense_tracker/top_card.dart';
import 'package:expense_tracker/transaction.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  //controllers
  final _textControllerAmount = TextEditingController();
  final _textControllerItem = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isIncome = false;

  //enter new transaction
  void _enterNewTransaction() {
    GoogleSheetsApi.insert(
      _textControllerItem.text,
      _textControllerAmount.text,
      _isIncome,
    );
    setState(() {});
  }

  //new transaction
  void _newTransaction() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                contentPadding: const EdgeInsets.all(10),
                title: const Text("New Transaction"),
                content: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Expense"),
                          Switch(
                              value: _isIncome,
                              onChanged: (newValue) {
                                setState(() {
                                  _isIncome = newValue;
                                });
                              }),
                          const Text("Income"),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Form(
                              key: _formKey,
                              child: TextFormField(
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: "Amount?",
                                ),
                                validator: (text) {
                                  if (text == null || text.isEmpty) {
                                    return "Enter an Amount";
                                  }
                                  return null;
                                },
                                controller: _textControllerAmount,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: "For What?",
                              ),
                              controller: _textControllerItem,
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
                actions: <Widget>[
                  MaterialButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    color: Colors.grey[600],
                    child: const Text(
                      "Cancel",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  MaterialButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _enterNewTransaction();
                        _textControllerAmount.text = '';
                        _textControllerItem.text = '';
                        Navigator.pop(context);
                      }
                    },
                    color: Colors.grey[600],
                    child: const Text(
                      "Enter",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        });
  }

  //wait for the data to be fetched from google spreadsheet
  bool timerhasStarted = false;
  void startLoading() {
    timerhasStarted = true;
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (GoogleSheetsApi.loading == false) {
        setState(() {});
        timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (GoogleSheetsApi.loading == true && timerhasStarted == false) {
      startLoading();
    }
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              TopNeuCard(
                balance: (GoogleSheetsApi.CalculateIncome() -
                        GoogleSheetsApi.CalculateExpense())
                    .toStringAsFixed(2),
                income: GoogleSheetsApi.CalculateIncome().toString(),
                expense: GoogleSheetsApi.CalculateExpense().toString(),
              ),
              Expanded(
                child: Container(
                  child: Center(
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 10.0,
                        ),
                        Expanded(
                          child: GoogleSheetsApi.loading == true
                              ? const Loading()
                              : ListView.builder(
                                  itemCount:
                                      GoogleSheetsApi.currentTransaction.length,
                                  itemBuilder: (context, index) {
                                    return MyTransaction(
                                        TransactionName: GoogleSheetsApi
                                            .currentTransaction[index][0],
                                        Money: GoogleSheetsApi
                                            .currentTransaction[index][1],
                                        IncomeOrExpense: GoogleSheetsApi
                                            .currentTransaction[index][2]);
                                  },
                                ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              PlusButton(
                function: _newTransaction,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
