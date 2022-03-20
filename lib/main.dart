import 'package:flutter/material.dart';
import 'package:flutter_regression_app/linear_regression.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:scidart/numdart.dart';
import "sales_data.dart";
import 'gradient_descend.dart';

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
  // Change if we can add Points to the Chart
  bool setPoints = true;
  late ChartSeriesController _seriesController;
  // This variable is for selecting what value goes to the type of regression pop menu
   Regressions _selection = Regressions.linear;
  // xLine is the sets of points in the x axis
  var xLine;
  // Values in Sales Data Structure
  var points;
  late Array Xvalues;
  late Array YValues;
  var predictedPoints;
  var predictedSales;
  var MeanSquaredError;
  var xpoints;
  List<Widget> _floatingButtom = [];
  int index = 0;
  bool visibility = false;

  int maxPoints = 1000;
  int pointCounter = 0;


  void checkSelections() {
        // Check what type of Regression is used
   if(_selection ==  Regressions.linear) {
    xpoints = [for(int i = 0; i< Xvalues.length; i++) simpleLinearRegression(Xvalues, YValues).predict(Xvalues[i])];
    predictedPoints = [
      for (int x = 0; x < xLine.length; x++)
        simpleLinearRegression(Xvalues, YValues).predict(xLine[x])];
    }
    else if((_selection == Regressions.quadratic) &  (Xvalues.length > 3)) {
          xpoints = [for(int i = 0; i< Xvalues.length; i++) PolyFit(Xvalues, YValues,2).predict(Xvalues[i])];
      predictedPoints = [
      for (int x = 0; x < xLine.length; x++)
      PolyFit(Xvalues, YValues, 2).predict(xLine[x])  
      ];
    }
    else if(_selection == Regressions.cubic) {
      xpoints = [for(int i = 0; i< Xvalues.length; i++) PolyFit(Xvalues, YValues,3).predict(Xvalues[i])];
      predictedPoints = [
      for (int x = 0; x < xLine.length; x++)
      // gradientDescend( Xvalues, YValues, func).predictxx(xLine[x])  
      PolyFit(Xvalues, YValues, 3).predict(xLine[x]) ];
    }

  }


  // Initialize the variables
  @override
  void initState() {
    super.initState();
    xLine = linspace(-20, 20, num: 35);
    Xvalues = Array([1,6]);
    YValues = Array([1,5]);
    
    points = [
      for (int i = 0; i < Xvalues.length; i++) SalesData(Xvalues[i], YValues[i])
    ];
    xpoints = [for(int i = 0; i< Xvalues.length; i++) simpleLinearRegression(Xvalues, YValues).predict(Xvalues[i])];

    checkSelections();

    if(  (predictedPoints.length != 0)){
    predictedSales = [for (var i = 0; i < xLine.length; i++) SalesData(xLine[i], predictedPoints[i])];}
    

    calculateMeanSquared(Array(xpoints), YValues);




  }

  @override
  void dispose() {
    super.dispose();
  }

  void calculateMeanSquared( predicted, real){
    MeanSquaredError = 0;
    var list1 = real - predicted;
    list1 = list1 * list1;
    for(int x = 0; x < list1.length; x++){
      MeanSquaredError += list1[x];

    }
    MeanSquaredError = MeanSquaredError/ list1.length;
    print(MeanSquaredError);
  }

  void updateChart(offpoint) {
    if(pointCounter < maxPoints){
      points.add(SalesData(offpoint.x, offpoint.y));
    Xvalues.add(offpoint.x);
    YValues.add(offpoint.y);
    points.add(SalesData(offpoint.x, offpoint.y));
       
    
    // Check what type of Regression is used
    checkSelections();
    predictedSales = [for (var i = 0; i < xLine.length; i++) SalesData(xLine[i], predictedPoints[i])];
    calculateMeanSquared(Array(xpoints), YValues);
    pointCounter += 1;
    }
  }

  void setpointFunction() {
    setState(() {
        setPoints = !setPoints;
    
    });
  }

  // This is the type used by the popup menu below.

// This menu button widget updates a _selection field (of type WhyFarther,
// not shown here).
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
        Xvalues.clear();
        YValues.clear();
        Xvalues.add(0);
        YValues.add(0);
        Xvalues.add(3);
        YValues.add(2);
        Xvalues.add(-1);
        YValues.add(-1);
        points.clear();
        pointCounter = 0;
        predictedPoints.clear();
        predictedSales.clear();
        
      });
    }

    // This is the type used by the popup menu below.
    var a = PopupMenuButton<Regressions>(
        onSelected: (Regressions result) {
          setState(() {
            _selection = result;
            print(_selection);
              // Check what type of Regression is used
              checkSelections();
              calculateMeanSquared(Array(xpoints), YValues);
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
            FloatingActionButton(onPressed: clear, child: Icon(Icons.clear_sharp)),
            FloatingActionButton(child: setPoints?  Icon(Icons.access_alarm_outlined): Icon(Icons.add_circle_outline, color: Colors.red), onPressed: setpointFunction),
            FloatingActionButton(onPressed: () {setState(() {
              visibility = !visibility;
            });}),
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
          centerTitle: true,
          title:  Text('Polynomial Regression'),
        ),
        body:
            //Initialize the chart widget
            Stack(children: [
          SfCartesianChart(
            enableAxisAnimation: true,
            zoomPanBehavior: ZoomPanBehavior(
                enablePanning: true,
                enableMouseWheelZooming: true,
                enablePinching: true),
            primaryXAxis: NumericAxis(isVisible: true, maximum: 20, minimum: -20),
            primaryYAxis: NumericAxis(minimum: -20,maximum: 20),
            series: <ChartSeries<SalesData, double>>[
              LineSeries<SalesData, double>(
                dataSource: predictedSales,
                xValueMapper: (SalesData sales, _) => sales.x,
                yValueMapper: (SalesData sales, _) => sales.y,
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
                  xValueMapper: (SalesData sales, _) => sales.x,
                  yValueMapper: (SalesData sales, _) => sales.y,
                  onPointTap: (ChartPointDetails _info){
                    if(!setPoints){
                      setState(() {
                                       Xvalues.remove(_info.pointIndex);
                      YValues.remove(_info.pointIndex);
                      points.remove(_info.pointIndex);
                      print(_info.pointIndex);
                      });
                    }
                  }
                  
                  ),
            ],
            onChartTouchInteractionDown: (ChartTouchInteractionArgs _args) {
              var newPoint = _seriesController
                  .pixelToPoint(Offset(_args.position.dx, _args.position.dy));
              if (setPoints) {

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

          Positioned(right:10,

            child:
            Column(children: [
             Visibility( 
              visible: visibility,
              child:
             Container(
              decoration: BoxDecoration(
                color: Colors.blue,
                boxShadow: [BoxShadow(
                color: Colors.blueGrey,
                blurRadius: 9,
                

              )]),
              child: Text("Mean Square error \n $MeanSquaredError", style: TextStyle(fontSize: 20)),
              height:80, width:230)),
              Visibility(
                visible:  pointCounter >= maxPoints,
                child: 
              Container(height:50,width:230,color: Colors.red,child: Text("You get to the max points")))
            ])
              )
        ]));
  }
}

