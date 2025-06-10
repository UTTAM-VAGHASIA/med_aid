import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:med_aid/features/NGO/data/models/ngo_item.dart';

class NGOController extends GetxController {
  // Observable list of NGO items
  final RxList<NGOItem> ngoItems = <NGOItem>[].obs;
  
  // Search query
  final RxString searchQuery = ''.obs;
  
  // Search controller
  final TextEditingController searchController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    loadNGOItems();
    
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

  // Load NGO items
  void loadNGOItems() {
    ngoItems.assignAll([
      NGOItem(
        id: '1',
        name: 'I M HUMAN CHARITABLE TRUST',
        logoPath: 'assets/ngo/imct_logo.png', // Placeholder, create these assets
        location: 'Bardoli',
        openingHours: 'Open 24 Hrs',
        organizationType: 'Charity Organization',
        phoneNumber: '+91 84605 17015',
        address: '108 Siddhshila Appartment, Chowk, Upli Bazar, Opposite o, Near Sardar, Bardoli-394601',
      ),
      NGOItem(
        id: '2',
        name: 'Beyond Humanity Foundation (NGO)',
        logoPath: 'assets/ngo/bhf_logo.png', // Placeholder, create these assets
        location: 'Bardoli',
        openingHours: 'Open 24 Hrs',
        organizationType: 'Non-governmental organization in Gujarat',
        phoneNumber: '+91 70169 60550',
        address: 'Ngo, 119, Sai Villa Complex, Near Saibaba Temple Astan, Bardoli-394601',
      ),
    ]);
  }

  // Get filtered NGO items based on search query
  List<NGOItem> get filteredNGOItems {
    if (searchQuery.value.isEmpty) {
      return ngoItems;
    }
    
    return ngoItems.where((item) => 
      item.name.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
      item.location.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
      item.organizationType.toLowerCase().contains(searchQuery.value.toLowerCase())
    ).toList();
  }
} 