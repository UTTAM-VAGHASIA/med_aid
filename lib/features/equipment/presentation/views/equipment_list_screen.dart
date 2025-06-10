import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:med_aid/features/equipment/controllers/equipment_controller.dart';
import 'package:med_aid/app/app_router.dart';

class EquipmentListScreen extends StatelessWidget {
  const EquipmentListScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    final EquipmentController controller = Get.find<EquipmentController>();
    
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
          
          // Equipment title
          const Padding(
            padding: EdgeInsets.only(left: 24, top: 24, bottom: 16),
            child: Text(
              'EQUIPMENT',
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
                hintText: 'Search equipment...',
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
          
          // Equipment grid
          Expanded(
            child: Obx(() {
              final items = controller.filteredEquipmentItems;
              return GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 0.9,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return _buildEquipmentCard(item);
                },
              );
            }),
          ),
        ],
      ),
    );
  }
  
  Widget _buildEquipmentCard(dynamic item) {
    return GestureDetector(
      onTap: () {
        // Navigate to NGO list when item is tapped
        final appRouter = Get.find<AppRouter>();
        appRouter.goWithTransition('/ngo');
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200,
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Equipment image
            Expanded(
              child: Image.asset(
                item.imagePath,
                fit: BoxFit.contain,
                height: 60,
              ),
            ),
            
            // Equipment name
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: const BoxDecoration(
                color: Color(0xFFAFDCDD),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
              child: Text(
                item.name,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF3E8B8C),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 