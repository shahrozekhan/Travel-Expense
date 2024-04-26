part of 'add_expense_bloc.dart';

class ExpenseState {
  ExpenseState({required this.status, required this.expensesList});

  ExpenseState._({this.status = ExpenseStatus.unknown, this.expensesList});

  ExpenseState.unknown() : this._();

  ExpenseState.addExpenseFailed()
      : this._(
          status: ExpenseStatus.failed_to_add,
        );

  ExpenseState.addExpenseSuccess()
      : this._(
          status: ExpenseStatus.expense_added,
        );

  ExpenseState.getExpenseFailed(List<ExpenseRecord> expenseList)
      : this._(
            status: ExpenseStatus.failed_expense_list,
            expensesList: expenseList);

  ExpenseState.getExpenseListSuccess(List<ExpenseRecord> expenseList)
      : this._(
            status: ExpenseStatus.get_expense_list, expensesList: expenseList);

  ExpenseState.deleteExpenseFailed()
      : this._(
          status: ExpenseStatus.failed_to_delete,
        );

  ExpenseState.deleteExpenseSuccess()
      : this._(
          status: ExpenseStatus.expense_deleted,
        );

  final ExpenseStatus status;
  List<ExpenseRecord>? expensesList = [];
}
