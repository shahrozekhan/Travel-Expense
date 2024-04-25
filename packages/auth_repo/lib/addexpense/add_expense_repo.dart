import 'dart:async';

import 'package:auth_repo/addexpense/model/expense_record.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

enum ExpenseStatus {
  get_expense_list,
  expense_added,
  expense_deleted,
  failed_to_add,
  failed_to_delete,
  failed_expense_list,
  unknown,
}

class ExpenseRepository {
  final _controller = StreamController<ExpenseStatus>();
  Stream<ExpenseStatus> get addExpenseStatus async* {
    yield* _controller.stream;
  }

  Future<ExpenseRecord?> addExpense(
      String currency, String date, String amount) async {
    try {
      final uniqueID = FirebaseAuth.instance.currentUser!.uid;
      final documentReference = await FirebaseFirestore.instance
          .collection("expense-" + uniqueID)
          .add({'currency': currency, 'date': date, 'amount': amount});
      return ExpenseRecord(
          id: documentReference.id,
          currency: currency,
          date: DateTime.parse(date),
          amount: amount);
    } on FirebaseException {
      return null;
    }
    //
  }

  void deleteExpense(String expenseId) {
    try {
      //TODO call the api to delete expense.
      _controller.add(ExpenseStatus.expense_deleted);
    } catch (exception) {
      _controller.add(ExpenseStatus.failed_to_delete);
    }
    //
  }

  Future<List<ExpenseRecord>> getExpenseList() async {
    try {
      final uniqueID = FirebaseAuth.instance.currentUser!.uid;
      final documentReference = await FirebaseFirestore.instance
          .collection("expense-" + uniqueID)
          .get();
      List<ExpenseRecord> expenseList = [];
      documentReference.docs.forEach((doc) {
        expenseList.add(ExpenseRecord(
            id: doc.id,
            currency: doc["currency"],
            date: DateTime.parse(doc["date"]),
            amount: doc["amount"]));
      });
      return expenseList;
    } on FirebaseException {
      return [];
    }
    //
  }

  void dispose() => _controller.close();
}
