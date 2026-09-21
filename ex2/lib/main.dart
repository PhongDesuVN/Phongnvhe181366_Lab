import 'developer.dart';

void main() {
  List<Developer> teamA = [Developer("An"), Developer("Bình")];
  List<Developer> teamB = [Developer("Cường")];


  List<Developer> allStaff = [...teamA, ...teamB];

  print("--- BẮT ĐẦU ĐIỂM DANH ---");
  for (var staff in allStaff) {
    staff.checkIn();
 //   staff.work();
  }
}