import 'package:fit_kit/fit_kit.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Widget> _list = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Health Package Demo.'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Welcome to the Health Tracker App... ',
                    textAlign: TextAlign.center,
                  ),
                  RaisedButton(
                    onPressed: () async {
                      // await read();
                      // await readLast();
                      setState(() {
                        _list.clear();
                      });
                      readAll();
                    },
                    child: Text('Click Me'),
                  ),
                  if (_list.length > 0) ..._list
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void read() async {
    try {
      final responses = await FitKit.hasPermissions([
        DataType.HEART_RATE,
        DataType.STEP_COUNT,
        DataType.HEIGHT,
        DataType.WEIGHT,
        DataType.DISTANCE,
        DataType.ENERGY,
        DataType.WATER,
        DataType.SLEEP,
        DataType.STAND_TIME,
        DataType.EXERCISE_TIME,
      ]);
      if (!responses) {
        await FitKit.requestPermissions([
          DataType.HEART_RATE,
          DataType.STEP_COUNT,
          DataType.HEIGHT,
          DataType.WEIGHT,
          DataType.DISTANCE,
          DataType.ENERGY,
          DataType.WATER,
          DataType.SLEEP,
          DataType.STAND_TIME,
          DataType.EXERCISE_TIME,
        ]);
      }
    } on UnsupportedException catch (e) {
      // thrown in case e.dataType is unsupported
      print(e);
    }
  }

  void readAll() async {
    if (await FitKit.requestPermissions(DataType.values)) {
      for (DataType type in DataType.values) {
        try {
          final results = await FitKit.read(type,
              dateFrom: DateTime.now().subtract(Duration(hours: 35)),
              dateTo: DateTime.now());

          print(type);
          print(results);
          addWidget(type, results);
        } on Exception catch (ex) {
          print(ex);
        }
      }
    }
  }

  void addWidget(DataType type, List<FitData> data) {
    Widget widget = Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('$type'),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: (data.length > 0)
                  ? Column(
                      children: map(
                          list: data,
                          handler: (index, FitData datas) {
                            return Container(
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        '${DateFormat("dd-MM HH:mm").format(datas.dateFrom).toString()}',
                                        softWrap: true,
                                      ),
                                    ),
                                    Text('to'),
                                    Expanded(
                                      child: Text(
                                        '${DateFormat("dd-MM HH:mm").format(datas.dateTo).toString()}',
                                        softWrap: true,
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        '${datas.value is double ? datas.value.toStringAsFixed(1) : datas.value} ${getBaseUnit(type)}',
                                        softWrap: true,
                                      ),
                                    )
                                  ]),
                            );
                          }),
                    )
                  : Text(' No Data Availbale'),
            ),
          ],
        ));

    setState(() {
      _list.add(widget);
    });
  }

  static List<T> map<T>({@required List list, @required Function handler}) {
    List<T> result = [];

    if (list.length > 0) {
      for (var i = 0; i < (list.length > 10 ? 5 : list.length); i++) {
        result.add(handler(i, list[i]));
      }
    }

    return result;
  }

  static String getBaseUnit(DataType type) {
    switch (type) {
      case DataType.HEART_RATE:
        return 'count/min';
      case DataType.STEP_COUNT:
        return '';
      case DataType.HEIGHT:
        return 'meter';
      case DataType.WEIGHT:
        return 'kg';
      case DataType.DISTANCE:
        return 'meter';
      case DataType.ENERGY:
        return 'kilocalorie';
      case DataType.WATER:
        return 'liter';
      case DataType.SLEEP:
        return 'Sleep';
      default:
        return 'UnKnown';
    }
  }
}
