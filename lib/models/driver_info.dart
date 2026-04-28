import 'package:hive/hive.dart';

@HiveType(typeId: 0)
class DriverInfo extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String vehicleType; // "Police", "Ambulance", "Fire"

  @HiveField(3)
  String vehicleNumber;

  @HiveField(4)
  String contact;

  DriverInfo({
    required this.id,
    required this.name,
    required this.vehicleType,
    required this.vehicleNumber,
    required this.contact,
  });
}
