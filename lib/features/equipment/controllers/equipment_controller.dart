import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:med_aid/features/equipment/data/models/equipment_item.dart';

class EquipmentController extends GetxController {
  // Observable list of equipment items
  final RxList<EquipmentItem> equipmentItems = <EquipmentItem>[].obs;
  
  // Search query
  final RxString searchQuery = ''.obs;
  
  // Search controller
  final TextEditingController searchController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    loadEquipmentItems();
    
    // Add listener to search controller
    searchController.addListener(() {
      searchQuery.value = searchController.text;
    });
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  // Load equipment items
  void loadEquipmentItems() {
    equipmentItems.assignAll([
      EquipmentItem(
        id: '1',
        name: 'Hospital bed',
        imagePath: 'assets/items/hospital-bed.png',
      ),
      EquipmentItem(
        id: '2',
        name: 'Walking stick',
        imagePath: 'assets/items/walking_stick/walking-stick-right.png',
      ),
      EquipmentItem(
        id: '3',
        name: 'Crutches',
        imagePath: 'assets/items/crutches.png',
      ),
      EquipmentItem(
        id: '4',
        name: 'Walker',
        imagePath: 'assets/items/walker.png',
      ),
      EquipmentItem(
        id: '5',
        name: 'Wheel chair',
        imagePath: 'assets/items/wheel-chair.png',
      ),
      EquipmentItem(
        id: '6',
        name: 'Stretcher',
        imagePath: 'assets/items/stretcher.png',
      ),
      EquipmentItem(
        id: '7',
        name: 'Coller',
        imagePath: 'assets/items/coller.png',
      ),
      EquipmentItem(
        id: '8',
        name: 'Nebulizer',
        imagePath: 'assets/items/nebulizer.png',
      ),
      EquipmentItem(
        id: '9',
        name: 'Pulse oximeter',
        imagePath: 'assets/items/pulse-oximeter.png',
      ),
    ]);
  }

  // Get filtered equipment items based on search query
  List<EquipmentItem> get filteredEquipmentItems {
    if (searchQuery.value.isEmpty) {
      return equipmentItems;
    }
    
    return equipmentItems.where((item) => 
      item.name.toLowerCase().contains(searchQuery.value.toLowerCase())
    ).toList();
  }
}
