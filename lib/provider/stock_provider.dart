import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../model/stock_model.dart';

class StockProvider extends ChangeNotifier {
  late Timer periodicTimer;
  bool isPeriodic = true;
  bool isLoading = false;
  String? error;
  List<StockModel> stockList = [];
  List<StockModel> savedStockList = [];

  Future<void> fetchStockList(BuildContext context) async {
    try {
      isLoading = true;
      notifyListeners();
      Map<String, String> headerMap = {
        "x-rapidapi-key": "5882de32d4msh5d594a10557342ep126c0ajsn83f192b2b93b",
        "x-rapidapi-host": "latest-stock-price.p.rapidapi.com"
      };
      http.Response response = await http.get(
          Uri.parse('https://latest-stock-price.p.rapidapi.com/any'),
          headers: headerMap);
      if (response.statusCode == 200) {
        List<dynamic> parsedResponse =
            jsonDecode(response.body) as List<dynamic>;
        List<StockModel> fetchedStockList =
            parsedResponse.map((e) => StockModel.fromMap(e)).toList();
        stockList = fetchedStockList;
        isLoading = false;
        notifyListeners();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('something went wrong')));
        isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      isLoading = false;
      error = e.toString();
      notifyListeners();
    }
  }

  void addStockToHistory(StockModel stockModel) {
    savedStockList.add(stockModel);
    notifyListeners();
  }

  void fetchStockOnPeriodic(BuildContext context) {
    periodicTimer = Timer.periodic(const Duration(seconds: 5), (timer) async {
      await fetchStockList(context);
    });
  }

  void changePeriodicState(BuildContext context) {
    if (isPeriodic) {
      isPeriodic = false;
      periodicTimer.cancel();
      notifyListeners();
    } else {
      isPeriodic = true;
      periodicTimer = Timer.periodic(const Duration(seconds: 5), (timer) async {
        await fetchStockList(context);
      });
      notifyListeners();
    }
  }
}
