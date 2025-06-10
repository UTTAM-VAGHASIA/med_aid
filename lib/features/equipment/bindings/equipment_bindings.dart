import 'package:get/get.dart';
import 'package:med_aid/features/equipment/controllers/equipment_controller.dart';

class EquipmentBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EquipmentController>(() => EquipmentController());
  }
} 