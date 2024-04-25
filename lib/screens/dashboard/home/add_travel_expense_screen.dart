import 'package:auth_repo/addexpense/add_expense_repo.dart';
import 'package:fcc/common/date_utils.dart';
import 'package:fcc/common/storage/storage.dart';
import 'package:fcc/model/exchange_rates.dart';
import 'package:fcc/screens/bloc/expense/add_expense_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';

import '../../../widgets/textfield_style.dart';

class AddExpense extends StatefulWidget {
  const AddExpense({super.key});

  @override
  State<StatefulWidget> createState() {
    return _AddTravelExpense();
  }
}

class _AddTravelExpense extends State<AddExpense> {
  final TextEditingController _amountController = TextEditingController();
  DateTime? _selectedDate;
  ExchangeRate? _selectedExchangeRate;
  List<ExchangeRate>? exchangeRatesList = [];
  final _formValidator = GlobalKey<FormState>();
  bool _loader = false;
  SecureStorage secureStorage = SecureStorage();

  void _presentDatePicker() async {
    final initialDate = DateTime.now();
    final firstDate =
        DateTime(initialDate.year - 1, initialDate.month, initialDate.day);
    final pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: firstDate,
        lastDate: initialDate);

    setState(() {
      _selectedDate = pickedDate;
    });
  }

  @override
  void initState() {
    retrieveExpenseList();
    super.initState();
  }

  void retrieveExpenseList() async {
    var exchangeRatesList =
        await context.read<ExpenseBloc>().loadExchangeRatesFromFile();
    var storedCurrency = await secureStorage.read<String>("currency");
    var selectedCurrency = exchangeRatesList.where(
      (element) => element.currency == storedCurrency,
    );
    _selectedExchangeRate =
        selectedCurrency.firstOrNull ?? exchangeRatesList[0];
    setState(() {
      this.exchangeRatesList = exchangeRatesList;
    });
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _submittExpense() async {
    setState(() {
      _loader = true;
    });
    final isValid = _formValidator.currentState!.validate();
    if (!isValid) {
      setState(() {
        _loader = false;
      });
      return;
    }

    context.read<ExpenseBloc>().add(AddExpenseEvent(
        currency: _selectedExchangeRate!.currency.toString(),
        date: _selectedDate.toString(),
        amount: _amountController.value.text));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ExpenseBloc, ExpenseState>(
      listener: (ctx, state) {
        if (state.status == ExpenseStatus.expense_added) {
          context.go("/DashBoardScreen");
          Fluttertoast.showToast(msg: "Expense Added Successfully!");
        } else if (state.status == ExpenseStatus.failed_to_add) {
          setState(() {
            _loader = false;
          });
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Something went wrong!")));
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Add Expenses"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formValidator,
            child: Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.currency_exchange),
                        const SizedBox(width: 10),
                        Text(
                          'Currency:',
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    //Add dropdown
                    BlocBuilder<ExpenseBloc, ExpenseState>(
                        builder: (context, state) {
                      return SizedBox(
                        width: double.infinity,
                        child: DropdownButton(
                          menuMaxHeight: 400,
                          value: _selectedExchangeRate,
                          icon: const Icon(Icons.arrow_drop_down),
                          onChanged: (newValue) {
                            setState(() {
                              _selectedExchangeRate =
                                  newValue! as ExchangeRate?;
                            });
                          },
                          items: exchangeRatesList
                              ?.map<DropdownMenuItem<ExchangeRate>>(
                                  (ExchangeRate value) {
                            return DropdownMenuItem<ExchangeRate>(
                              value: value,
                              child: Text(
                                  "${value.currency} (${value.currencyName})"),
                            );
                          }).toList(),
                        ),
                      );
                    }),
                  ],
                ),
                const SizedBox(height: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.date_range),
                        const SizedBox(width: 10),
                        Text(
                          'Select Date',
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: () {
                        _presentDatePicker();
                      },
                      child: TextFieldStyleText(
                        text: _selectedDate != null
                            ? dateFormatter.format(_selectedDate!)
                            : "Select Date.",
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.attach_money),
                        const SizedBox(width: 10),
                        Text(
                          'Amount',
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Amount cannot be empty";
                        }
                        return null;
                      },
                      controller: _amountController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Enter amount',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                if (_loader == true)
                  CircularProgressIndicator(
                    color: Theme.of(context).colorScheme.primary,
                  )
                else
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _submittExpense,
                      child: const Text('Save Expense!'),
                    ),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
