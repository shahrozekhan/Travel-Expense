class ExpenseRecord {
  ExpenseRecord(
      {required this.id,
      required this.currency,
      required this.date,
      required this.amount});

  final String id;
  final String currency;
  final DateTime date;
  final String amount;
}
