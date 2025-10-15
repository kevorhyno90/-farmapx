class FieldModel {
  final String id;
  final String name;
  final String description;
  final double areaHa;
  final String soilType;

  FieldModel({
    required this.id,
    required this.name,
    this.description = '',
    this.areaHa = 0.0,
    this.soilType = '',
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'description': description,
        'areaHa': areaHa,
        'soilType': soilType,
      };

  factory FieldModel.fromMap(Map<String, dynamic> m) => FieldModel(
        id: m['id'] as String,
        name: m['name'] as String,
        description: m['description'] as String? ?? '',
        areaHa: (m['areaHa'] is num) ? (m['areaHa'] as num).toDouble() : double.tryParse('${m['areaHa']}') ?? 0.0,
        soilType: m['soilType'] as String? ?? '',
      );
}
