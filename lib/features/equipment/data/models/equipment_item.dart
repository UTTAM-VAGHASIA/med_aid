class EquipmentItem {
  final String id;
  final String name;
  final String imagePath;
  final bool isLarge;
  
  // New layout properties
  final LayoutType layoutType;
  final double imageSize;
  final int rowSpan;
  final int columnSpan;
  final double rowHeight;

  EquipmentItem({
    required this.id,
    required this.name,
    required this.imagePath,
    this.isLarge = false,
    this.layoutType = LayoutType.standardTopLeftBottomRight,
    this.imageSize = 120,
    this.rowSpan = 1,
    this.columnSpan = 2,
    this.rowHeight = 3,
  });
}

// Define layout types for different card styles
enum LayoutType {
  // Title top-left, image bottom-right (rows 1-2)
  standardTopLeftBottomRight,
  
  // Title left side, image right side (rows 3-4)
  horizontalLeftRight
} 