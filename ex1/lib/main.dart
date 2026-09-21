import 'car.dart';
void main(){
  print("test xe 1");
  car nomalCar = car('Honda', 2006, false);
  nomalCar.startEngine();

  print('test xe 2');
  car teslaCar = car.tesla(2025);
  teslaCar.startEngine();
}