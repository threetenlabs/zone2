import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:zone2/app/modules/track/controllers/track_controller.dart';
import 'package:get/get.dart';
import 'package:zone2/app/services/health_service.dart'; // Import GetX for controller access
import 'package:intl/intl.dart'; // Add this import

// Define an enum for time frames

class WeightTab extends StatelessWidget {
  const WeightTab({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Week'),
              Tab(text: 'Month'),
              Tab(text: '6M'),
              Tab(text: 'Journey'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            WeightGraph(timeFrame: TimeFrame.week),
            WeightGraph(timeFrame: TimeFrame.month),
            WeightGraph(timeFrame: TimeFrame.sixMonths),
            WeightGraph(timeFrame: TimeFrame.allTime),
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

    final timeframeTextMap = {
      TimeFrame.week: 'This Week',
      TimeFrame.month: 'This Month',
      TimeFrame.sixMonths: 'Last 6 Months',
      TimeFrame.allTime: 'Journey',
    };
    Future<List<WeightData>> data =
        controller.getWeightData(timeFrame); // Use the controller to fetch data

    return FutureBuilder<List<WeightData>>(
      future: data,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator()); // Loading indicator
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}')); // Error handling
        } else if (snapshot.data == null || snapshot.data!.isEmpty || snapshot.data!.length < 2) {
          return const Center(
              child: Text('There are not enough entries')); // Display message if no data
        } else {
          return SfCartesianChart(
            primaryXAxis: const CategoryAxis(),
            title: ChartTitle(text: "Weight Loss ${timeframeTextMap[timeFrame] ?? ''}"),
            series: <CartesianSeries>[
              LineSeries<WeightData, String>(
                dataSource: snapshot.data!,
                xValueMapper: (WeightData weight, _) {
                  // Use DateFormat to parse and format the date
                  final DateFormat inputFormat = DateFormat('M/d/yy');
                  final DateFormat outputFormat = DateFormat('M/dd');
                  DateTime date = inputFormat.parse(weight.date);
                  return outputFormat.format(date);
                },
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
