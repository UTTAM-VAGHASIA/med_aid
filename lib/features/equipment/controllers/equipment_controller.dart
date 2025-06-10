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
      // Row 1 - Small cards (3 per row)
      EquipmentItem(
        id: '1',
        name: 'Hospital bed',
        imagePath: 'assets/items/hospital-bed.png',
        columnSpan: 2,
        imageSize: 90,
        rowHeight: 3,
        layoutType: LayoutType.standardTopLeftBottomRight,
      ),
      EquipmentItem(
        id: '2',
        name: 'Walking stick',
        imagePath: 'assets/items/walking_stick/walking-stick-right.png',
        columnSpan: 2,
        imageSize: 90,
        rowHeight: 3,
        layoutType: LayoutType.standardTopLeftBottomRight,
      ),
      EquipmentItem(
        id: '3',
        name: 'Crutches',
        imagePath: 'assets/items/crutches.png',
        columnSpan: 2,
        imageSize: 90,
        rowHeight: 3,
        layoutType: LayoutType.standardTopLeftBottomRight,
      ),
      
      // Row 2 - Small cards (3 per row)
      EquipmentItem(
        id: '4',
        name: 'Walker',
        imagePath: 'assets/items/walker.png',
        columnSpan: 2,
        imageSize: 90,
        rowHeight: 3,
        layoutType: LayoutType.standardTopLeftBottomRight,
      ),
      EquipmentItem(
        id: '5',
        name: 'Wheel chair',
        imagePath: 'assets/items/wheel-chair.png',
        columnSpan: 2,
        imageSize: 90,
        rowHeight: 3,
        layoutType: LayoutType.standardTopLeftBottomRight,
      ),
      EquipmentItem(
        id: '6',
        name: 'Stretcher',
        imagePath: 'assets/items/stretcher.png',
        columnSpan: 2,
        imageSize: 90,
        rowHeight: 3,
        layoutType: LayoutType.standardTopLeftBottomRight,
      ),
      
      // Row 3 - Medium cards (2 per row) - shorter height
      EquipmentItem(
        id: '7',
        name: 'Collar',
        imagePath: 'assets/items/coller.png',
        columnSpan: 3,
        imageSize: 110,
        rowHeight: 2,
        layoutType: LayoutType.horizontalLeftRight,
      ),
      EquipmentItem(
        id: '8',
        name: 'Nebulizer',
        imagePath: 'assets/items/nebulizer.png',
        columnSpan: 3,
        imageSize: 110,
        rowHeight: 2,
        layoutType: LayoutType.horizontalLeftRight,
      ),
      
      // Row 4 - Large card (1 per row) - taller height
      EquipmentItem(
        id: '9',
        name: 'Pulse oximeter',
        imagePath: 'assets/items/pulse-oximeter.png',
        columnSpan: 6,
        imageSize: 130,
        rowHeight: 1.8,
        layoutType: LayoutType.horizontalLeftRight,
      ),
    ]);
  }


  List<EquipmentItem> get filteredEquipmentItems {
    if (searchQuery.value.isEmpty) {
      return equipmentItems;
    }
    
    return equipmentItems.where((item) => 
      item.name.toLowerCase().contains(searchQuery.value.toLowerCase())
    ).toList();
  }
}
