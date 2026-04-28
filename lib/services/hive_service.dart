import 'package:hive_flutter/hive_flutter.dart';
import 'package:res_q_route/models/driver_info.dart';

class HiveService {
  static const String driverBoxName = 'driverBox';

  static Future<void> init() async {
    await Hive.initFlutter();
    // Register Adapters
    if (!Hive.isAdapterRegistered(0)) {
      // We will register manually if build_runner is not used, or use the generated adapter.
      // Assuming we will write a manual adapter if we don't want to run build_runner, 
      // but let's assume we'll just run build_runner or write it manually.
      Hive.registerAdapter(DriverInfoAdapter());
    }
    await Hive.openBox<DriverInfo>(driverBoxName);
  }

  static Box<DriverInfo> getDriverBox() {
    return Hive.box<DriverInfo>(driverBoxName);
  }

  static Future<void> saveDriverInfo(DriverInfo info) async {
    final box = getDriverBox();
    await box.put('current_driver', info);
  }

  static DriverInfo? getCurrentDriver() {
    final box = getDriverBox();
    return box.get('current_driver');
  }

  static Future<void> clearDriverInfo() async {
    final box = getDriverBox();
    await box.delete('current_driver');
  }
}

// Manual Adapter to avoid build_runner overhead for now
class DriverInfoAdapter extends TypeAdapter<DriverInfo> {
  @override
  final int typeId = 0;

  @override
  DriverInfo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DriverInfo(
      id: fields[0] as String,
      name: fields[1] as String,
      vehicleType: fields[2] as String,
      vehicleNumber: fields[3] as String,
      contact: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, DriverInfo obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.vehicleType)
      ..writeByte(3)
      ..write(obj.vehicleNumber)
      ..writeByte(4)
      ..write(obj.contact);
  }
  
  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DriverInfoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
