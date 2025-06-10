import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:med_aid/features/NGO/controllers/ngo_controller.dart';
import 'package:med_aid/app/app_router.dart';
import 'package:med_aid/core/widgets/settings_dialog.dart';
import 'package:med_aid/features/NGO/data/models/ngo_item.dart';

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
                // Back button
                GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.arrow_back,
                      color: Color(0xFF3E8B8C),
                      size: 24,
                    ),
                  ),
                ),
                
                // Page title
                const Text(
                  'NGO Partners',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF3E8B8C),
                  ),
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
          
          const SizedBox(height: 16),
          
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
                  hintText: 'Search NGO...',
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
          
          const SizedBox(height: 16),
          
          // NGO list - Number indicator
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Obx(() {
              final itemCount = controller.filteredNGOItems.length;
              return Text(
                'Found $itemCount NGO partners',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade600,
                ),
              );
            }),
          ),
          
          const SizedBox(height: 18),
          
          // NGO list
          Expanded(
            child: Obx(() {
              final items = controller.filteredNGOItems;
              
              if (items.isEmpty) {
                return Center(
                  child: Text(
                    'No NGOs found',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade600,
                    ),
                  ),
                );
              }
              
              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return _buildNGOCard(context, item);
                },
              );
            }),
          ),
        ],
      ),
    );
  }
  
  Widget _buildNGOCard(BuildContext context, NGOItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row 1: Logo and Column with name + location row
          Row(
  crossAxisAlignment: CrossAxisAlignment.center, // Changed from CrossAxisAlignment.start
  children: [
    // NGO logo
    ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 50,
        width: 50,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade200),
          borderRadius: BorderRadius.circular(12),
        ),
        child: _buildNgoLogo(item),
      ),
    ),
    const SizedBox(width: 12),

    // Column with Name and city+hours row
    Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // NGO name
          Text(
            item.name,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),

          // City and hours row
          Row(
            children: [
              Text(
                item.location,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(width: 18),
              Text(
                "Open 24 Hrs",
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF54B2B3),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
            
          ),
        ],
      ),
    ),
  ],
),
          const SizedBox(height: 12),
          
          // Row 2: Organization type
          Text(
            item.organizationType,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 16),
          
          // Row 3: Phone number with icon
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Color(0xFFE3F2FD),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.phone,
                  color:  Color(0xFF54B2B3),
                  size: 18,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                item.phoneNumber,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          // Row 4: Address with location icon
          Row(
  crossAxisAlignment: CrossAxisAlignment.center, // Changed from CrossAxisAlignment.start
  children: [
    Container(
      padding: const EdgeInsets.all(8),
      decoration: const BoxDecoration(
        color: Color(0xFFE8F5E9),
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.location_on,
        color: Color(0xFF54B2B3),
        size: 18,
      ),
    ),
    const SizedBox(width: 8),
    Expanded(
      child: Text(
        item.address,
        style: const TextStyle(
          fontSize: 14,
          color: Colors.black87,
        ),
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
      ),
    ),
  ],
)
        ],
      ),
    );
  }
  
  // Custom logo for each NGO based on their ID
  Widget _buildNgoLogo(NGOItem item) {
    // Using generatePlaceholderLogo for missing logos
    if (!item.logoPath.contains('assets/ngo/')) {
      return _generatePlaceholderLogo(item);
    }
    
    return Image.asset(
      item.logoPath,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        // If the image fails to load, use placeholder logo
        return _generatePlaceholderLogo(item);
      },
    );
  }
  
  // Generate a placeholder logo with the NGO's initials
  Widget _generatePlaceholderLogo(NGOItem item) {
    // Generate initials from the NGO name
    final List<String> nameParts = item.name.split(' ');
    String initials = '';
    
    if (nameParts.isNotEmpty) {
      // Get first 2 initials
      for (var i = 0; i < nameParts.length && i < 2; i++) {
        if (nameParts[i].isNotEmpty) {
          initials += nameParts[i][0];
        }
      }
    }
    
    // If no initials could be generated, use a default
    if (initials.isEmpty) {
      initials = 'N';
    }
    
    // Choose color based on NGO ID (consistent color per NGO)
    final List<Color> colors = [
      const Color(0xFF1976D2), // Blue
      const Color(0xFF388E3C), // Green
      const Color(0xFFD32F2F), // Red
      const Color(0xFF7B1FA2), // Purple
      const Color(0xFFFF9800), // Orange
    ];
    
    // Use the ID to determine color
    final colorIndex = int.tryParse(item.id)?.remainder(colors.length) ?? 0;
    final backgroundColor = colors[colorIndex];
    
    return Container(
      color: backgroundColor,
      child: Center(
        child: Text(
          initials.toUpperCase(),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
  
  // Show contact dialog
  void _showContactDialog(BuildContext context, NGOItem item) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Contact ${item.name}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (item.phoneNumber != 'TBD')
                ListTile(
                  leading: const Icon(Icons.phone, color: Color(0xFF1976D2)),
                  title: Text(item.phoneNumber),
                  onTap: () {
                    // Add phone call functionality here
                    Navigator.of(context).pop();
                  },
                ),
              ListTile(
                leading: const Icon(Icons.home, color: Color(0xFF388E3C)),
                title: Text(item.address),
                subtitle: Text(item.location),
              ),
              ListTile(
                leading: const Icon(Icons.email, color: Color(0xFF388E3C)),
                title: const Text('Send Email'),
                onTap: () {
                  // Add email functionality here
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
} 