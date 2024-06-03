import 'dart:math';

class StockModel {
  String? stockName;
  int? lastPrice;

  StockModel({required this.stockName, required this.lastPrice});

  StockModel.fromMap(Map<String, dynamic> map) {
    stockName = map['identifier'];
    lastPrice = Random().nextInt(100);
  }
}
