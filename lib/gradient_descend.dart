import 'package:scidart/numdart.dart';

class gradientDescend {
  List xCoords;
  List yCoords;
  Function _function;
  double h = 0.001;
  double learningRate = 0.01;
  gradientDescend(this.xCoords, this.yCoords, this._function);

  void estimate() {
    double estimate = 0;
    for (int i = 0; i < xCoords.length; i++) {
      estimate += pow(_function(xCoords[i]) - yCoords[i], 2);
    }
  }

  dynamic errorFunction(i) {
    return pow(-yCoords[i], 2);
  }

  double derivative(c, p) {
    return (errorFunction(c[0]) - errorFunction(p[0])) / h;
  }

  Array gradient(Array point) {
    Array grad = Array([0, 0, 0]);
    for (int i = 0; i < point.length; i++) {
      Array c = point;
      c[i] = point[i] + h;
      double slope = derivative(c, point);
      grad[i] = slope;
    }

    return grad;
  }

  Array iterateCoeffients(iterations) {
    // Gradient Descend Formula c = c - Gradient* Learning rate
    Array B = Array([5.0, 6.0, 3.0]);
    for (int i = 0; i < iterations; i++) {
      B = B - gradient(B) * Array([learningRate, learningRate, learningRate]);
    }
    return B;
  }

  double predict(x) {
    // Horners Method
    var a = newWay();
    double sum = 0;
    for (int e = 0; e < a.length; e++) {
      sum += x * a[e];
      x = x * x;
    }
    return sum;
  }

  dynamic newWay() {
    dynamic b4 = [2.0, 5.0, 3.0];
    for (var e = 0; e < 1000; e++) {
      for (int i = 0; i < xCoords.length; i++) {
        var x = xCoords[i];
        var y = yCoords[i];
        var guess = x * x * b4[0] + x * b4[1] + b4[2];
        var error = y - guess;
        b4[0] = b4[0] + error * x * x * learningRate;
        b4[1] = b4[1] + error * x * learningRate;
        b4[2] = b4[2] + error * learningRate;
      }
    }
    return [b4[0], b4[1], b4[2]];
  }
}
