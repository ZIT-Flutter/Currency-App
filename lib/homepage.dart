import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // bool isLo
  List<Map<String, dynamic>> currencies = [];

  @override
  void initState() {
    super.initState();
    fetchCurrencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Currency App'),
      ),
      body: ListView.builder(
          shrinkWrap: true,
          itemCount: currencies.length,
          itemBuilder: (context, index) {
            var currentCurrency = currencies[index];
            String code = currentCurrency['code'];
            var value = currentCurrency['value'];

            return Card(
              child: ListTile(
                leading: Text('${index + 1}'),
                title: Text(code),
                trailing: Text('$value'),
              ),
            );
          }),
    );
  }

  Future<void> fetchCurrencies() async {
    final response = await http.get(Uri.parse(
        'https://api.currencyapi.com/v3/latest?apikey=cur_live_zuaTCDVbopL9MjsRWRaXR0DarghKMHjKDYJFcU04'));

    if (response.statusCode == 200) {
      final parsedJson = json.decode(response.body);
      final data = parsedJson['data'] as Map<String, dynamic>;

      setState(() {
        data.forEach((key, value) {
          bool isBDT = value['code'] == 'BDT';
          var curMap = {'code': value['code'], 'value': value['value']};

          if (isBDT) {
            currencies.insert(0, curMap);
          } else {
            currencies.add(curMap);
          }
        });
        // isLoading = false;
      });

      print(currencies);
    } else {
      throw Exception('Failed to load currencies');
    }
  }
}
