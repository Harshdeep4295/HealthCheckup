import 'package:fit_kit/fit_kit.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Widget> _list = [];
  static bool needToShowAllData = false;
  bool dayToday = false;
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
            child: NotificationListener<OverscrollIndicatorNotification>(
              onNotification: (overscroll) {
                overscroll.disallowGlow();
              },
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Welcome to the Health Tracker App... ',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 24),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text('Need to display full data'),
                        Checkbox(
                            value: needToShowAllData,
                            onChanged: (value) {
                              setState(() {
                                needToShowAllData = value;

                                _list.clear();
                              });
                              readData();
                            }),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        RaisedButton(
                          onPressed: () async {
                            setState(() {
                              _list.clear();
                              dayToday = false;
                            });

                            readData();
                          },
                          child: Text(
                            'Click Me For yesterday\'s Data.',
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                        RaisedButton(
                          onPressed: () async {
                            setState(() {
                              _list.clear();
                              dayToday = true;
                            });

                            readData();
                          },
                          child: Text(
                            'Click Me For Today\'s Data.',
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    if (_list.length > 0) ..._list
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> readPermissions() async {
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
        final value = await FitKit.requestPermissions([
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

        return value;
      } else {
        return true;
      }
    } on UnsupportedException catch (e) {
      // thrown in case e.dataType is unsupported
      print(e);
      return false;
    }
  }

  void readData() async {
    bool permissionsGiven = await readPermissions();

    if (permissionsGiven) {
      DateTime current = DateTime.now();
      DateTime dateFrom;
      DateTime dateTo;
      if (!dayToday) {
        dateFrom = DateTime.now().subtract(Duration(
          hours: current.hour + 24,
          minutes: current.minute,
          seconds: current.second,
        ));
        dateTo = dateFrom.add(Duration(
          hours: 23,
          minutes: 59,
          seconds: 59,
        ));
      } else {
        dateFrom = current.subtract(Duration(
          hours: current.hour,
          minutes: current.minute,
          seconds: current.second,
        ));
        dateTo = DateTime.now();
      }

      for (DataType type in DataType.values) {
        try {
          final results = await FitKit.read(
            type,
            dateFrom: dateFrom,
            dateTo: dateTo,
          );

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
    if (type == DataType.STEP_COUNT) {
      int total = 0;
      for (FitData datasw in data) {
        total += datasw.value;
      }
      print("-------------------------- $total");
    }
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

    int lengthToDisplay =
        list.length > 5 && !needToShowAllData ? 5 : list.length;

    if (list.length > 0) {
      for (var i = 0; i < lengthToDisplay; i++) {
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
        return 'litre';
      case DataType.SLEEP:
        return 'Sleep';
      default:
        return 'UnKnown';
    }
  }
}
