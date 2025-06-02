class CustomerBriefEntity {
  int id;
  String? customerName;
  String? shopName;
  String? governate;
  String? region;
  String? shopCoordinates;
  String? address;
  CustomerBriefEntity({
    required this.id,
    this.customerName,
    this.shopName,
    this.governate,
    this.region,
    this.shopCoordinates,
    this.address,
  });
}
