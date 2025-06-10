class EquipmentItem {
  final String id;
  final String name;
  final String imagePath;
  final bool isLarge;

  EquipmentItem({
    required this.id,
    required this.name,
    required this.imagePath,
    this.isLarge = false,
  });
} 