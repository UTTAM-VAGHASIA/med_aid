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
    print("Loading NGO items...");
    ngoItems.assignAll([
      NGOItem(
        id: '1',
        name: 'I M HUMAN CHARITABLE TRUST',
        logoPath: 'assets/ngo/imct_logo.png',
        location: 'Bardoli',
        openingHours: 'Open 24 Hrs',
        organizationType: 'Charity Organization',
        phoneNumber: '+91 84605 17015',
        address: '108 Siddhshila Appartment, Chowk, Upli Bazar, Opposite o, Near Sardar, Bardoli-394601',
      ),
      NGOItem(
        id: '2',
        name: 'Beyond Humanity Foundation (NGO)',
        logoPath: 'assets/ngo/bhf_logo.png',
        location: 'Bardoli',
        openingHours: 'Open 24 Hrs',
        organizationType: 'Non-governmental organization in Gujarat',
        phoneNumber: '+91 70169 60550',
        address: 'Ngo, 119, Sai Villa Complex, Near Saibaba Temple Astan, Bardoli-394601',
      ),
      NGOItem(
        id: '3',
        name: 'Diwaliben Ukabhai Patel Sarvajanik Trust',
        logoPath: 'assets/ngo/dupst_logo.png', // Placeholder logo
        location: 'Bardoli',
        openingHours: 'Open 24 Hrs',
        organizationType: 'Public Charitable Trust',
        phoneNumber: 'TBD',
        address: 'TBD',
      ),
      NGOItem(
        id: '4',
        name: 'Universal Welfare Trust',
        logoPath: 'assets/ngo/uwt_logo.png', // Placeholder logo
        location: 'Bardoli',
        openingHours: 'Open 24 Hrs',
        organizationType: 'Welfare Organization',
        phoneNumber: 'TBD',
        address: 'TBD',
      ),
      NGOItem(
        id: '5',
        name: 'Vatsalya Trust',
        logoPath: 'assets/ngo/vatsalya_logo.png', // Placeholder logo
        location: 'Bardoli',
        openingHours: 'Open 24 Hrs',
        organizationType: 'Charitable Trust',
        phoneNumber: 'TBD',
        address: 'TBD',
      ),
    ]);
    print("Loaded ${ngoItems.length} NGO items");
  }

  // Get filtered NGO items based on search query
  List<NGOItem> get filteredNGOItems {
    if (searchQuery.value.isEmpty) {
      print("Returning all ${ngoItems.length} NGO items");
      return ngoItems;
    }
    
    final filtered = ngoItems.where((item) => 
      item.name.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
      item.location.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
      item.organizationType.toLowerCase().contains(searchQuery.value.toLowerCase())
    ).toList();
    
    print("Filtered to ${filtered.length} NGO items");
    return filtered;
  }
} 