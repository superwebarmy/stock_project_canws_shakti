import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_project/provider/stock_provider.dart';
import 'package:stock_project/view/history.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<StockProvider>(context, listen: false)
          .fetchStockOnPeriodic(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stock List'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        leading: InkWell(
          onTap: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => const History()));
          },
          child: const Icon(Icons.history),
        ),
        actions: [
          Consumer<StockProvider>(
            builder: (context, provider, widgetTree) {
              return InkWell(
                onTap: () {
                  provider.changePeriodicState(context);
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(provider.isPeriodic
                      ? Icons.pause_circle_filled_outlined
                      : Icons.play_circle_fill_outlined),
                ),
              );
            },
          )
        ],
      ),
      body: SafeArea(
        child: Consumer<StockProvider>(
          builder: (context, provider, widgetTree) {
            if (provider.isLoading) {
              return const Center(
                  child: CircularProgressIndicator(color: Colors.blueAccent));
            }
            if (provider.error != null) {
              return Center(
                  child: Text(provider.error ?? 'something went wrong'));
            }
            return ListView.builder(
              itemCount: provider.stockList.length,
              itemBuilder: (context, int index) {
                return ListTile(
                  onTap: () {
                    provider.addStockToHistory(provider.stockList[index]);
                  },
                  title: Text(provider.stockList[index].stockName!),
                  subtitle: Text(
                      provider.stockList[index].lastPrice!.toStringAsFixed(2)),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
