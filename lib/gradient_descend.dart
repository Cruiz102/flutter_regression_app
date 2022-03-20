import 'package:scidart/numdart.dart';

class gradientDescend {
  List xCoords;
  List yCoords;
  Function _function;
  double h = 0.0001;
  double learningRate = 0.001;
  gradientDescend(this.xCoords, this.yCoords, this._function);



  double derivative(c, p) {
    return (_function(c) - _function(p)) / h;
  }

  Array gradient(Array point) {
    Array grad = zeros(point.length);
    for (int i = 0; i < point.length; i++) {
      Array c =  point.copy();
      c[i] = point[i] + h;
      double slope = derivative(c, point);
      grad[i] = slope;
    }

    return grad;
  }

  Array GradientDescend(iterations, args) {
  // Gradient Descend Formula c = c - Gradient* Learning rate
    for (int i = 0; i < iterations; i++) {
      args = args - gradient(args) * Array(List.generate(args.length, (i) => learningRate)) ;

    }
    return args;
  }

  Array WithoutDerivative(iterations, args) {
    for (int i = 0; i < iterations; i++) {
    for (int i = 0; i <xCoords.length; i++) {
      var x = xCoords[i];
      var y = yCoords[i];
      var guess = args[0]*x + args[1];
       //args[0]*x*x + args[1]*x + args[2];
      var error =  y - guess ;
     // args[0] = args[0] - error*x*x * learningRate ;
      args[0] = args[0] - error*x * learningRate ;
      args[1] = args[1] - error *learningRate;
    }}

    return args;

  }
 
    
  
  double predictxx(double x){
    var grad = WithoutDerivative(1000, Array([1,1]));
    print(grad);
    return  x*grad[0]+ grad[1];
    //x*x* grad[0] + x*grad[1]+ grad[2];
    }
  
}
