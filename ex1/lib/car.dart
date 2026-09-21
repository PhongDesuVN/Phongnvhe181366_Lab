import 'package:ex1/vehicle.dart';

class car extends vehicle{
  bool isElectric;

  car(String brand,int year,this.isElectric) : super(brand,year);

//Tên dành riêng cho tesla
  car.tesla(int year)
      : isElectric = true,
        super('Tesla',year);

//ghi đè phương thức startEngine
  @override
  void startEngine(){
    if(isElectric){
      print("Xe điện $brand ($year) : Êm ái, không tiếng ồn!");
    }else{
      print("Xe xăng $brand ($year) : Sóc, Ồn ào vô cùng luôn!");
    }
  }

}