part of 'add_expense_bloc.dart';

sealed class ExpenseEvent {
  const ExpenseEvent();
}

final class GetExpenseEvent extends ExpenseEvent {
  const GetExpenseEvent();
}

final class AddExpenseEvent extends ExpenseEvent {
  const AddExpenseEvent(
      {required this.currency, required this.date, required this.amount});

  final String currency;
  final String date;
  final String amount;
}

final class DeleteExpenseEvent extends ExpenseEvent {
  const DeleteExpenseEvent({required this.expenseId});

  final String expenseId;
}
