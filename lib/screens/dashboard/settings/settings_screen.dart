import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fcc/common/storage/storage.dart';
import 'package:fcc/model/exchange_rates.dart';
import 'package:fcc/screens/bloc/expense/add_expense_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transparent_image/transparent_image.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _SettingScreen();
  }
}

class _SettingScreen extends State<SettingsScreen> {
  String imagePath = "";
  List<ExchangeRate>? exchangeRatesList = [];
  SecureStorage secureStorage = SecureStorage();
  ExchangeRate? _selectedExchangeRate;

  void _getImage() async {
    final profileDoc = FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid);

    try {
      final profileSnapShot = await profileDoc.get();
      setState(() {
        imagePath = profileSnapShot["image_url"];
      });
    } catch (message) {
      print(message);
    }
  }

  void _retrieveExpenseList() async {
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

  void _saveExchangeRate() async {
    secureStorage.write("currency", value: _selectedExchangeRate!.currency);
  }

  @override
  void initState() {
    _getImage();
    _retrieveExpenseList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        if (imagePath.isNotEmpty)
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100),
            ),
            child: CircleAvatar(
              backgroundImage: NetworkImage(imagePath),
              radius: 100,
            ),
          )
        else
          Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100),
              ),
              child: CircleAvatar(
                backgroundImage: MemoryImage(kTransparentImage),
                radius: 100,
              )),
        const SizedBox(
          height: 10,
        ),
        Text(
          FirebaseAuth.instance.currentUser!.email ?? "",
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 20),
        ),
        const SizedBox(
          height: 10,
        ),
        BlocBuilder<ExpenseBloc, ExpenseState>(builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Text(
                      'Default Currency:',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(fontWeight: FontWeight.normal),
                    ),
                  ),
                  DropdownButton(
                    value: _selectedExchangeRate,
                    icon: const Icon(Icons.arrow_drop_down),
                    onChanged: (newValue) {
                      setState(() {
                        _selectedExchangeRate = newValue! as ExchangeRate?;
                        _saveExchangeRate();
                      });
                    },
                    items: exchangeRatesList
                        ?.map<DropdownMenuItem<ExchangeRate>>(
                            (ExchangeRate value) {
                      return DropdownMenuItem<ExchangeRate>(
                        value: value,
                        child: SizedBox(
                          width: 220,
                          child: Text(
                            "${value.currency} (${value.currencyName})",
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ]),
          );
        }),
      ],
    );
  }
}
