import 'package:auth_repo/addexpense/model/expense_record.dart';
import 'package:fcc/common/storage/storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auth_repo/addexpense/add_expense_repo.dart';

import '../../../common/file/JsonFileReader.dart';
import '../../../model/currency_date.dart';
import '../../../model/exchange_rates.dart';
import '../../../model/symbols.dart';

part 'add_expense_event.dart';

part 'add_expense_state.dart';

class ExpenseBloc extends Bloc<ExpenseEvent, ExpenseState> {
  final ExpenseRepository _expenseRepository;
  SecureStorage secureStorage = SecureStorage();

  final List<ExchangeRate>? exchangeRateList = null;

  ExpenseBloc({required ExpenseRepository addExpenseRepository})
      : _expenseRepository = addExpenseRepository,
        super(ExpenseState(status: ExpenseStatus.unknown, expensesList: [])) {
    on<GetExpenseEvent>((event, emit) async {
      final expenseList = await _expenseRepository.getExpenseList();
      final exchangeRatesList = await loadExchangeRatesFromFile();
      var storedCurrency = await secureStorage.read<String>("currency");
      var selectedCurrency = exchangeRatesList.where(
        (element) => element.currency == storedCurrency,
      );
      var settingExchangeRate =
          selectedCurrency.firstOrNull ?? exchangeRatesList[0];
      List<ExpenseRecord> newExpenseList = [];
      expenseList.forEach((element) {
        var fromExchangeRate = exchangeRatesList
            .where((exchangeRate) => element.currency == exchangeRate.currency);
        var newRate = (settingExchangeRate.rate / fromExchangeRate.first.rate);
        newExpenseList.add(ExpenseRecord(
            id: element.id,
            currency:
                "${settingExchangeRate.currency} (${settingExchangeRate.currencyName})",
            date: element.date,
            amount:
                (double.parse(element.amount) * newRate).toStringAsFixed(6)));
      });

      if (expenseList.isNotEmpty == true) {
        emit(ExpenseState.getExpenseListSuccess(newExpenseList));
      } else {
        emit(ExpenseState.getExpenseFailed(state.expensesList!));
      }
    });

    on<AddExpenseEvent>((event, emit) async {
      final expenseRecord = await _expenseRepository.addExpense(
          event.currency, event.date, event.amount);
      if (expenseRecord != null) {
        emit(ExpenseState(
            status: ExpenseStatus.expense_added,
            expensesList: [expenseRecord, ...state.expensesList!]));
      } else {
        emit(ExpenseState(
            status: ExpenseStatus.expense_added,
            expensesList: [...state.expensesList!]));
      }
    });
    on<DeleteExpenseEvent>((event, emit) {});
  }

  //This function will be moved to ExchangeRate Repository. As they will be fetched from API service or local storage.
  Future<List<ExchangeRate>> loadExchangeRatesFromFile() async {
    final String exchange_rates = 'assets/exchange_rate.json';
    final String symbols = 'assets/symbols.json';
    final Map<String, dynamic> exchangeRateJson =
        await JsonReader.loadData(exchange_rates);
    final Map<String, dynamic> symbols_json =
        await JsonReader.loadData(symbols);
    final CurrencyData currencyData = CurrencyData.fromJson(exchangeRateJson);
    final CurrencySymbols symbolsData = CurrencySymbols.fromJson(symbols_json);
    final List<ExchangeRate> exchangeRate = getExchangeRateSortedOnCurrencies(
        currencyData.rates, symbolsData.symbols);
    return exchangeRate;
  }

// Future<void> _getExchangeRate(){
//
// }
}
