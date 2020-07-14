import 'package:fit_kit/fit_kit.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Health Package Demo.'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Welcome to the Health Tracker App...',
                textAlign: TextAlign.center,
              ),
              RaisedButton(
                onPressed: () {
                  // read();
                  // readLast();
                  readAll();
                },
                child: Text('Click Me'),
              )
            ],
          ),
        ),
      ),
    );
  }

  void read() async {
    try {
      final results = await FitKit.read(
        DataType.HEART_RATE,
        dateFrom: DateTime.now().subtract(Duration(days: 5)),
        dateTo: DateTime.now(),
      );
      print(results);
    } on UnsupportedException catch (e) {
      // thrown in case e.dataType is unsupported
    }
  }

  void readLast() async {
    final result = await FitKit.readLast(DataType.HEIGHT);
    print(result);
  }

  void readAll() async {
    if (await FitKit.requestPermissions(DataType.values)) {
      for (DataType type in DataType.values) {
        try {
          final results = await FitKit.read(
            type,
            dateFrom: DateTime.now().subtract(Duration(days: 5)),
            dateTo: DateTime.now(),
          );
          print(results);
        } on Exception catch (ex) {
          print(ex);
        }
      }
    }
  }
}
