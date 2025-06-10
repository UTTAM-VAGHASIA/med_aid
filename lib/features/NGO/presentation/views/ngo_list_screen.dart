import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:med_aid/features/NGO/controllers/ngo_controller.dart';

class NGOListScreen extends StatelessWidget {
  const NGOListScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    final NGOController controller = Get.find<NGOController>();
    
    // Set status bar color to match the header
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Color(0xFFAFDCDD),
        statusBarIconBrightness: Brightness.dark,
      ),
    );
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top curved container with app logo and settings icon
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(
              left: 24, 
              right: 24, 
              bottom: 16,
              top: MediaQuery.of(context).padding.top + 16, // Add padding for status bar
            ),
            decoration: const BoxDecoration(
              color: Color(0xFFAFDCDD),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // App logo at left
                Image.asset(
                  'assets/app-logo.png',
                  height: 48,
                ),
                
                // Settings icon at right
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.settings,
                    color: Color(0xFF3E8B8C),
                    size: 24,
                  ),
                ),
              ],
            ),
          ),
          
          // NGO title
          const Padding(
            padding: EdgeInsets.only(left: 24, top: 24, bottom: 16),
            child: Text(
              'NGO',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color(0xFF54B2B3),
                letterSpacing: 1.0,
              ),
            ),
          ),
          
          // Search bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: TextField(
              controller: controller.searchController,
              decoration: InputDecoration(
                hintText: 'Search NGO...',
                hintStyle: TextStyle(
                  color: Colors.grey.shade400,
                  fontSize: 14,
                ),
                suffixIcon: const Icon(
                  Icons.search,
                  color: Color(0xFF54B2B3),
                ),
                fillColor: Colors.white,
                filled: true,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 16,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Colors.grey.shade300,
                    width: 1.0,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color(0xFF54B2B3),
                    width: 1.0,
                  ),
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // NGO list
          Expanded(
            child: Obx(() {
              final items = controller.filteredNGOItems;
              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return _buildNGOCard(item);
                },
              );
            }),
          ),
        ],
      ),
    );
  }
  
  Widget _buildNGOCard(dynamic item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade100,
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: Colors.grey.shade100,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // NGO header with logo, name, location and hours
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // NGO logo
                ClipOval(
                  child: Container(
                    height: 50,
                    width: 50,
                    color: Colors.grey.shade100,
                    child: const Center(
                      child: Icon(
                        Icons.business, 
                        color: Color(0xFF3E8B8C),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                
                // NGO details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // NGO name
                      Text(
                        item.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      
                      // Location and hours
                      Row(
                        children: [
                          Text(
                            item.location,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFC8E6C9), // Light green for "Open"
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              item.openingHours,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF2E7D32), // Dark green text
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      
                      // Organization type
                      Text(
                        item.organizationType,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          const Divider(height: 1, color: Color(0xFFEEEEEE)),
          
          // Contact information
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Phone number
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Color(0xFFE3F2FD), // Light blue background
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.phone,
                        color: Color(0xFF1976D2), // Blue icon
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      item.phoneNumber,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                // Address
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Color(0xFFE8F5E9), // Light green background
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.location_on, 
                        color: Color(0xFF388E3C), // Green icon
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        item.address,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
} 