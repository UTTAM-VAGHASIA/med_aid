import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:med_aid/features/equipment/controllers/equipment_controller.dart';
import 'package:med_aid/app/app_router.dart';
import 'package:med_aid/core/widgets/settings_dialog.dart';
import 'package:med_aid/features/equipment/data/models/equipment_item.dart';

class EquipmentListScreen extends StatelessWidget {
  const EquipmentListScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    final EquipmentController controller = Get.find<EquipmentController>();
    final screenWidth = MediaQuery.of(context).size.width;
    
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
                GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => const SettingsDialog(),
                    );
                  },
                  child: Container(
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
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(color: Colors.grey.shade300),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade200,
                    blurRadius: 3,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: TextField(
                controller: controller.searchController,
                decoration: InputDecoration(
                  hintText: 'Search equipment...',
                  hintStyle: TextStyle(
                    color: Colors.grey.shade400,
                    fontSize: 16,
                  ),
                  suffixIcon: const Icon(
                    Icons.search,
                    color: Color(0xFF54B2B3),
                    size: 28,
                  ),
                  fillColor: Colors.white,
                  filled: true,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 14,
                    horizontal: 20,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Responsive equipment grid with proportional card sizes
          Expanded(
            child: Obx(() {
              final items = controller.filteredEquipmentItems;
              
              if (items.isEmpty) {
                return const Center(
                  child: Text(
                    'No equipment found',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                );
              }
              
              // Calculate available width for cards (accounting for padding and spacing)
              final availableWidth = screenWidth - 40 - 32; // 20px padding on each side, 16px spacing between cards
              
              // Calculate card sizes for each row type
              final row1CardWidth = availableWidth / 3;
              final row1CardHeight = row1CardWidth;
              
              final row3CardWidth = availableWidth / 2;
              final row3CardHeight = row3CardWidth / 2;
              
              final row4CardWidth = availableWidth;
              final row4CardHeight = row4CardWidth / 4;
              
              // Group items by row
              final row1Items = items.where((item) => ['Hospital bed', 'Walking stick', 'Crutches'].contains(item.name)).toList();
              final row2Items = items.where((item) => ['Walker', 'Wheel chair', 'Stretcher'].contains(item.name)).toList();
              final row3Items = items.where((item) => ['Collar', 'Nebulizer'].contains(item.name)).toList();
              final row4Items = items.where((item) => item.name == 'Pulse oximeter').toList();
              
              // Consistent image size for all cards
              const imageSize = 80.0;
              
              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    // Row 1 - 3 cards of equal width
                    buildRow(row1Items, row1CardWidth, row1CardHeight, imageSize, LayoutType.standardTopLeftBottomRight),
                    
                    const SizedBox(height: 16),
                    
                    // Row 2 - 3 cards of equal width
                    buildRow(row2Items, row1CardWidth, row1CardHeight, imageSize, LayoutType.standardTopLeftBottomRight),
                    
                    const SizedBox(height: 16),
                    
                    // Row 3 - 2 cards of equal width (wider than rows 1-2)
                    buildRow(row3Items, row3CardWidth, row3CardHeight, imageSize, LayoutType.horizontalLeftRight),
                    
                    const SizedBox(height: 16),
                    
                    // Row 4 - 1 full-width card
                    buildRow(row4Items, row4CardWidth, row4CardHeight, imageSize, LayoutType.horizontalLeftRight),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
  
  // Build a row of equipment cards
  Widget buildRow(List<EquipmentItem> items, double cardWidth, double cardHeight, double imageSize, LayoutType layoutType) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: items.map((item) => _buildEquipmentCard(
        item, 
        cardWidth: cardWidth, 
        cardHeight: cardHeight, 
        imageSize: imageSize,
        layoutType: layoutType,
      )).toList(),
    );
  }
  
  // Build individual equipment card
  Widget _buildEquipmentCard(
    EquipmentItem item, {
    required double cardWidth,
    required double cardHeight,
    required double imageSize,
    required LayoutType layoutType,
  }) {
    return Hero(
      tag: 'equipment_${item.id}',
      child: Material(
        color: Colors.transparent,
        child: GestureDetector(
          onTap: () {
            // Navigate to NGO list when item is tapped
            final appRouter = Get.find<AppRouter>();
            appRouter.goWithTransition('/ngo');
          },
          child: Container(
            width: cardWidth,
            height: cardHeight,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade200,
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: layoutType == LayoutType.standardTopLeftBottomRight
                ? _buildTopLeftBottomRightLayout(item, imageSize)
                : _buildHorizontalLayout(item, imageSize),
          ),
        ),
      ),
    );
  }
  
  // Layout with title at top-left and image at bottom-right (Rows 1-2)
  Widget _buildTopLeftBottomRightLayout(EquipmentItem item, double imageSize) {
    return Stack(
      children: [
        // Equipment name at the top left
        Positioned(
          top: 16,
          left: 16,
          right: 16,
          child: Text(
            item.name,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Color(0xFF54B2B3),
            ),
          ),
        ),
        
        // Equipment image in the bottom right
        Positioned(
          bottom: 8,
          right: 8,
          child: SizedBox(
            width: imageSize,
            height: imageSize,
            child: Image.asset(
              item.imagePath,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ],
    );
  }
  
  // Horizontal layout with title on left and image on right (Rows 3-4)
  Widget _buildHorizontalLayout(EquipmentItem item, double imageSize) {
    return Row(
      children: [
        // Title on the left side
        Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Text(
            item.name,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Color(0xFF54B2B3),
            ),
          ),
        ),
        
        // Image on the right side
        Expanded(
          child: Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 16),
              child: SizedBox(
                width: imageSize,
                height: imageSize,
                child: Image.asset(
                  item.imagePath,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
} 