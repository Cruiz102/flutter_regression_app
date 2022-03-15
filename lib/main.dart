import 'package:flutter/material.dart';
import 'package:flutter_regression_app/gradient_descend.dart';
import 'package:flutter_regression_app/linear_regression.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:scidart/numdart.dart';

void main() {
  return runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.blue),
      home: _MyHomePage(),
    );
  }
}

enum Regressions { linear, quadratic, cubic }

class _MyHomePage extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  _MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<_MyHomePage> {
  bool setPoints = false;
  late ChartSeriesController _seriesController;
  late Regressions _selection;
  var xLine;
  var b;
  late List<double> b2;
  var d;
  var points;
  late Array lis1;
  late Array lis2;
  List<Widget> _floatingButtom = [];
  int index = 0;

  @override
  void initState() {
    super.initState();
    xLine = linspace(1, 20, num: 100);
    lis1 = Array([1, 9]);
    lis2 = Array([2, 4]);
    points = [
      for (int i = 0; i < lis1.length; i++) _SalesData(lis2[i], lis1[i])
    ];
    xLine.toList();
    b = [
      for (int x = 0; x < xLine.length; x++)
        linearRegression(lis2, lis1).predict(xLine[x])
    ];
    double func(x) {
      return pow(x, 2) + x + 1;
    }

    var gra = gradientDescend(lis2, lis1, func);
    b2 = [for (int x = 0; x < xLine.length; x++) gra.predict(x)];

    var c = xLine.length;
    d = [for (var i = 0; i < c; i++) _SalesData(xLine[i], b2[i])];
  }

  @override
  void dispose() {
    super.dispose();
  }

  void updateChart(offpoint) {
    lis1.add(offpoint.y);
    lis2.add(offpoint.x);
    points.add(_SalesData(offpoint.x, offpoint.y));
    b = [
      for (int x = 0; x < xLine.length; x++)
        linearRegression(lis2, lis1).predict(xLine[x])
    ];
    var c = xLine.length;
    d = [for (var i = 0; i < c; i++) _SalesData(xLine[i], b[i])];
  }

  void setpointFunction() {
    setState(() {
      if (setPoints) {
        setPoints = false;
      } else {
        setPoints = true;
      }
    });
  }

  // This is the type used by the popup menu below.

// This menu button widget updates a _selection field (of type WhyFarther,
// not shown here).

  List<_SalesData> data = [_SalesData(1, 0), _SalesData(2, 1)];
  @override
  Widget build(BuildContext context) {
    void F() {
      setState(() {
        if (index == 1) {
          index = 0;
        } else {
          print(index);
          index++;
        }
      });
    }

    // Clear all the points
    void clear() {
      setState(() {
        lis1.clear();
        lis2.clear();
        lis1.add(0);
        lis2.add(0);
        points.clear();
        b.clear();
        d.clear();
      });
    }

    // This is the type used by the popup menu below.
    var a = PopupMenuButton<Regressions>(
        onSelected: (Regressions result) {
          setState(() {
            _selection = result;
            print(_selection);
          });
        },
        itemBuilder: (BuildContext context) => <PopupMenuEntry<Regressions>>[
              PopupMenuItem<Regressions>(
                  value: Regressions.linear, child: Text("Linear")),
              PopupMenuItem<Regressions>(
                  value: Regressions.quadratic, child: Text("quadratic")),
              PopupMenuItem<Regressions>(
                  value: Regressions.cubic, child: Text("Cubic")),
            ]);

    _floatingButtom = [
      FloatingActionButton(
        child: Icon(Icons.ac_unit_outlined),
        onPressed: F,
      ),
      Container(
        decoration: BoxDecoration(
            color: Colors.blueAccent,
            borderRadius: BorderRadius.all(Radius.circular(10))),
        height: 40,
        width: 300,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FloatingActionButton(onPressed: clear),
            FloatingActionButton(onPressed: setpointFunction),
            FloatingActionButton(onPressed: () {}),
            IconButton(
              icon: Icon(Icons.cancel_presentation),
              onPressed: F,
            ),
            a
          ],
        ),
      )
    ];

    return Scaffold(
        appBar: AppBar(
          title: const Text('Polynomial Regression'),
        ),
        body:
            //Initialize the chart widget
            Stack(children: [
          SfCartesianChart(
            zoomPanBehavior: ZoomPanBehavior(
                enablePanning: true,
                enableMouseWheelZooming: true,
                enablePinching: true),
            primaryXAxis: NumericAxis(isVisible: true, maximum: 20),
            primaryYAxis: NumericAxis(minimum: -20),
            series: <ChartSeries<_SalesData, double>>[
              LineSeries<_SalesData, double>(
                dataSource: d,
                xValueMapper: (_SalesData sales, _) => sales.year,
                yValueMapper: (_SalesData sales, _) => sales.sales,
                name: 'Sales',
                // Enable data label
              ),
              ScatterSeries(
                  animationDuration: 0.00,
                  onRendererCreated: (ChartSeriesController _controller) {
                    _seriesController = _controller;
                  },
                  dataSource: points,
                  borderWidth: 2.0,
                  color: Colors.amber,
                  xValueMapper: (_SalesData sales, _) => sales.year,
                  yValueMapper: (_SalesData sales, _) => sales.sales)
            ],
            onChartTouchInteractionDown: (ChartTouchInteractionArgs _args) {
              var newPoint = _seriesController
                  .pixelToPoint(Offset(_args.position.dx, _args.position.dy));
              if (setPoints) {
                points.add(_SalesData(newPoint.x, newPoint.y));

                // This function Update the chart scatterpoints
                updateChart(newPoint);
                setState(() {});
              }
            },
          ),
          Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                  padding: EdgeInsets.only(bottom: 15.5),
                  child: AnimatedSwitcher(
                      transitionBuilder: (child, animation) =>
                          ScaleTransition(scale: animation, child: child),
                      child: _floatingButtom[index],
                      duration: Duration(milliseconds: 300)))),
        ]));
  }
}

class _SalesData {
  _SalesData(this.year, this.sales);

  final double year;
  final double sales;
}
