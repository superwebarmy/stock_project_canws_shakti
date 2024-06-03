import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/stock_provider.dart';

class History extends StatefulWidget {
  const History({Key? key}) : super(key: key);

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved History'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: SafeArea(
        child: Consumer<StockProvider>(
          builder: (context, provider, widgetTree) {
            if (provider.isLoading) {
              return const Center(
                  child: CircularProgressIndicator(color: Colors.blueAccent));
            }
            return ListView.builder(
              itemCount: provider.savedStockList.length,
              itemBuilder: (context, int index) {
                return ListTile(
                  title: Text(provider.savedStockList[index].stockName!),
                  subtitle: Text(provider.savedStockList[index].lastPrice!
                      .toStringAsFixed(2)),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
