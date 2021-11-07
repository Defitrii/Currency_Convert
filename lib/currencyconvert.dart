import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(const CurrencyConvertPage());

class CurrencyConvertPage extends StatefulWidget {
  const CurrencyConvertPage({Key? key}) : super(key: key);

  @override
  State<CurrencyConvertPage> createState() => _CurrencyConvertPageState();
}

class _CurrencyConvertPageState extends State<CurrencyConvertPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Currency Convert',
      theme: ThemeData(primarySwatch: Colors.yellow),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Currency Convert'),
        ),
        body: const Center(child: CurrencyConvertForm()),
      ),
    );
  }
}

class CurrencyConvertForm extends StatefulWidget {
  const CurrencyConvertForm({Key? key}) : super(key: key);

  @override
  _CurrencyConvertFormState createState() => _CurrencyConvertFormState();
}

class _CurrencyConvertFormState extends State<CurrencyConvertForm> {
  String selectCurrency = "IDR", selectCurrency2 = "USD";
  List<String> currencyList = [
    "USD",
    "MYR",
    "IDR",
    "KRW",
    "SGD",
  ];

  TextEditingController intputEditingController = TextEditingController();
  double input = 0.0, currency1 = 0.0, currency2 = 0.0, output = 0.0;
  String desc = "";

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
        child: Column(
          children: [
            const SizedBox(height: 50),
            const Text(
              "Currency Convert",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 50),
            TextField(
                controller: intputEditingController,
                keyboardType: const TextInputType.numberWithOptions(),
                onChanged: (newValue) {
                  setState(() {
                    _cConvert();
                  });
                },
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0)))),
            const SizedBox(height: 30),
            DropdownButton(
              itemHeight: 60,
              isExpanded: true,
              value: selectCurrency,
              onChanged: (newValue) {
                setState(() {
                  selectCurrency = newValue.toString();
                  _cConvert();
                });
              },
              items: currencyList.map((selectCurrency) {
                return DropdownMenuItem(
                  child: Text(
                    selectCurrency,
                  ),
                  value: selectCurrency,
                );
              }).toList(),
            ),
            const SizedBox(height: 30),
            DropdownButton(
              itemHeight: 60,
              isExpanded: true,
              value: selectCurrency2,
              onChanged: (newValue) {
                setState(() {
                  selectCurrency2 = newValue.toString();
                  _cConvert();
                });
              },
              items: currencyList.map((selectCurrency2) {
                return DropdownMenuItem(
                  child: Text(
                    selectCurrency2,
                  ),
                  value: selectCurrency2,
                );
              }).toList(),
            ),
            const SizedBox(height: 40),
            Text(
              output.toString(),
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }

  _cConvert() async {
    var url = Uri.parse(
        'https://freecurrencyapi.net/api/v2/latest?apikey=37c04820-3cba-11ec-bcda-0fc9fde8a528');
    var response = await http.get(url);
    var rescode = response.statusCode;
    if (rescode == 200) {
      var jsonData = response.body;
      var persedJson = json.decode(jsonData);
      setState(() {
        if (selectCurrency == 'USD') {
          currency1 = 1;
        } else {
          currency1 = persedJson['data'][selectCurrency];
        }
        if (selectCurrency2 == 'USD') {
          currency2 = 1;
        } else {
          currency2 = persedJson['data'][selectCurrency2];
        }
        if (intputEditingController.text == "") {
          input = 0.0;
        } else {
          input = double.parse(intputEditingController.text);
        }

        output = (input / currency1) * currency2;
        desc = "";
      });
    } else {
      setState(() {
        desc = "No record";
      });
    }
  }
}
