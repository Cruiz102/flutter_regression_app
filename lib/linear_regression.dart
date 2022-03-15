import 'package:scidart/numdart.dart';

class linearRegression {
  List<double> x_coor;
  List<double> y_coor;
  linearRegression(this.x_coor, this.y_coor);

  List bCoeffients() {
    double xMedian = median(Array(x_coor));
    double yMedian = median(Array(y_coor));

    double sum1 = 0;
    double sum2 = 0;
    for (int i = 0; i < x_coor.length; i++) {
      sum1 += (x_coor[i] - xMedian) * (y_coor[i] - yMedian);
      sum2 += pow((x_coor[i] - xMedian), 2);
    }
    double b0 = sum1 / sum2;
    double b1 = yMedian - b0 * xMedian;

    return [b0, b1];
  }

  double predict(x) {
    var co = bCoeffients();

    return x * co[0] + co[1];
  }
}
