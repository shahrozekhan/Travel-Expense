import 'package:auth_repo/addexpense/model/expense_record.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ExpenseRecordItems extends StatelessWidget {
  const ExpenseRecordItems({super.key, required this.expenseRecord});

  final ExpenseRecord expenseRecord;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        clipBehavior: Clip.hardEdge,
        elevation: 2,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
          child: Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Amount",
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(fontWeight: FontWeight.normal)),
                Text(
                  expenseRecord.amount,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(fontWeight: FontWeight.bold),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Currency",
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(fontWeight: FontWeight.normal),
                ),
                Text(
                  expenseRecord.currency,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(fontWeight: FontWeight.bold),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Date",
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(fontWeight: FontWeight.normal),
                ),
                Text(
                  DateFormat('dd, MMMM yyyy').format(expenseRecord.date),
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(fontWeight: FontWeight.bold),
                )
              ],
            ),
          ]),
        ),
      ),
    );
  }
}
