import 'package:fcc/screens/bloc/expense/add_expense_bloc.dart';
import 'package:fcc/widgets/expense_record_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _HomeScreen();
  }
}

class _HomeScreen extends State<HomeScreen> {
  bool isLoading = false;
  @override
  void initState() {
    setState(() {
      isLoading = true;
    });
    context.read<ExpenseBloc>().add(const GetExpenseEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ExpenseBloc, ExpenseState>(listener: (context, state) {
      setState(() {
        isLoading = false;
      });
    }, builder: (context, state) {
      Widget? content;
      if (state.expensesList!.isEmpty) {
        content = Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Center(
                child: Text(
                  "You have not added any expense records!",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                child: const Text("Add new expense!"),
                onPressed: () {
                  context.go("/DashBoardScreen/AddExpense");
                },
              ),
            ],
          ),
        );
      }
      if (isLoading) {
        content = const Center(
          child: CircularProgressIndicator(
            color: Colors.deepPurple,
          ),
        );
      }
      if (state.expensesList!.isNotEmpty) {
        content = ListView.builder(
          itemCount: state.expensesList!.length,
          itemBuilder: (ctx, index) =>
              ExpenseRecordItems(expenseRecord: state.expensesList![index]),
        );
      }
      return content!;
    });
  }
}
