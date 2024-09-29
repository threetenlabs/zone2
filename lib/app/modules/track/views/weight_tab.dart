import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:zone2/app/modules/track/controllers/track_controller.dart';
import 'package:get/get.dart';
import 'package:zone2/app/services/health_service.dart'; // Import GetX for controller access

// Define an enum for time frames

class WeightTab extends StatelessWidget {
  const WeightTab({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Weight Over Time'),
          bottom: const TabBar(
            tabs: [
              Tab(text: '1W'),
              Tab(text: '3M'),
              Tab(text: '6M'),
              Tab(text: 'All'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            WeightGraph(timeFrame: TimeFrame.lastWeek),
            WeightGraph(timeFrame: TimeFrame.lastThreeMonths),
            WeightGraph(timeFrame: TimeFrame.lastSixMonths),
            WeightGraph(timeFrame: TimeFrame.all),
          ],
        ),
      ),
    );
  }
}

class WeightGraph extends GetWidget<TrackController> {
  final TimeFrame timeFrame; // Update type to TimeFrame

  const WeightGraph({super.key, required this.timeFrame});

  @override
  Widget build(BuildContext context) {
    // Map enum to string for fetching data

    Future<List<WeightData>> data =
        controller.getWeightData(timeFrame); // Use the controller to fetch data

    return FutureBuilder<List<WeightData>>(
      future: data,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator()); // Loading indicator
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}')); // Error handling
        } else {
          return SfCartesianChart(
            primaryXAxis: const CategoryAxis(),
            title: const ChartTitle(text: 'Weight Over Time'),
            series: <CartesianSeries>[
              LineSeries<WeightData, String>(
                dataSource: snapshot.data!,
                xValueMapper: (WeightData weight, _) => weight.date,
                yValueMapper: (WeightData weight, _) => weight.weight,
              ),
            ],
          );
        }
      },
    );
  }
}

class WeightData {
  final String date;
  final double weight;

  WeightData(this.date, this.weight);
}
