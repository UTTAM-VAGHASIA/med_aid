import 'package:get/get.dart';
import 'package:med_aid/features/NGO/controllers/ngo_controller.dart';

class NGOBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NGOController>(() => NGOController());
  }
} 