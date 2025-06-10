import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:med_aid/app/app_router.dart';

class CitySelectionScreen extends StatefulWidget {
  const CitySelectionScreen({super.key});

  @override
  State<CitySelectionScreen> createState() => _CitySelectionScreenState();
}

class _CitySelectionScreenState extends State<CitySelectionScreen> {
  String? _selectedCity;
  final List<String> _cities = ['Bardoli', 'Surat', 'Mumbai', 'Delhi', 'Bangalore'];
  late final AppRouter appRouter;
  
  @override
  void initState() {
    super.initState();
    appRouter = Get.find<AppRouter>();
    
    // Set default city
    _selectedCity = _cities.first;
    
    // Debug print
    debugPrint("CitySelectionScreen initialized");
  }
  
  @override
  Widget build(BuildContext context) {
    // Debug print
    debugPrint("CitySelectionScreen build method called");
    
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
        children: [
          // Header with app icon and title - now extends to the top
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(
              left: 24, 
              right: 24, 
              bottom: 16,
              // Add padding to the top to account for status bar
              top: MediaQuery.of(context).padding.top + 16,
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
                // App icon
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    color: const Color(0xFF289193),
                    padding: const EdgeInsets.all(8),
                    child: Image.asset(
                      'assets/app-logo.png',
                      width: 24,
                      height: 24,
                      color: Colors.white,
                    ),
                  ),
                ),
                
                // Title
                const Text(
                  'Explore Cities',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF3A3A3A),
                  ),
                ),
                
                // Settings icon
                const Icon(
                  Icons.settings,
                  color: Color(0xFF289193),
                  size: 28,
                ),
              ],
            ),
          ),
          
          // Rest of the content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  const SizedBox(height: 50),
                  
                  // Welcome text
                  const Text(
                    'Welcome !!',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF54B2B3),
                    ),
                  ),
                  const Text(
                    'to MED-AID',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF54B2B3),
                    ),
                  ),
                  
                  const SizedBox(height: 40),
                  
                  // City selection dropdown
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Label with asterisk
                      Row(
                        children: [
                          Text(
                            'Select City',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[700],
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Text(
                            '*',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 8),
                      
                      // Dropdown
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _selectedCity,
                            isExpanded: true,
                            hint: const Text('Bardoli'),
                            icon: const Icon(Icons.keyboard_arrow_down),
                            items: _cities.map((String city) {
                              return DropdownMenuItem<String>(
                                value: city,
                                child: Text(city),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                _selectedCity = newValue;
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  const Spacer(),
                  
                  // Submit button
                  Padding(
                    padding: const EdgeInsets.only(bottom: 32),
                    child: ElevatedButton(
                      onPressed: () {
                        // Navigate to home or next screen
                        if (_selectedCity != null || _cities.contains(_selectedCity)) {
                          // Show a loading indicator
                          setState(() {
                            // You could add a loading indicator here if needed
                          });
                          
                          // Debug print
                          debugPrint("CitySelectionScreen: Navigating to equipment list");
                          
                          // Use Future.delayed to ensure navigation happens after state update
                          Future.delayed(const Duration(milliseconds: 100), () {
                            appRouter.goWithTransition('/equipment');
                          });
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please select a city'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF54B2B3),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        minimumSize: Size(double.infinity, 0),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Submit',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
} 