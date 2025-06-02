class ProdPlanViewModel {
  int id;
  String type;
  String tier;
  String color;
  String? insertDate;
  List<PackageBreakdownViewModel>? packagingBreakdown;
  double? totalWeight;
  double? totalVolume;
  double? density;
  Map<String, bool?> depChecks;
  Map<String, String?> depNotes;
  String? preparedByNotes;
  ProdPlanViewModel({
    required this.id,
    required this.type,
    required this.tier,
    required this.color,
    this.insertDate,
    this.packagingBreakdown,
    this.totalWeight,
    this.totalVolume,
    this.density,
    Map<String, bool?>? depChecks,
    Map<String, String?>? depNotes,
    this.preparedByNotes,
  })  : depChecks = depChecks ??
            {
              'rawMaterial': null,
              'manufacturing': null,
              'lab': null,
              'emptyPackaging': null,
              'packaging': null,
              'finishedGoods': null,
            },
        depNotes = depNotes ??
            {
              'rawMaterial': null,
              'manufacturing': null,
              'lab': null,
              'emptyPackaging': null,
              'packaging': null,
              'finishedGoods': null,
            };

  bool get allReady {
    return depChecks.values.every((value) {
      return value == true;
    });
  }
}

class PackageBreakdownViewModel {
  String brand;
  String packageType;
  double packageWeight;
  double packageVolume;
  int quantity;
  double? sumWeight;
  double? sumVolume;
  PackageBreakdownViewModel({
    required this.brand,
    required this.packageType,
    required this.packageWeight,
    required this.packageVolume,
    required this.quantity,
    this.sumWeight,
    this.sumVolume,
  });
}
