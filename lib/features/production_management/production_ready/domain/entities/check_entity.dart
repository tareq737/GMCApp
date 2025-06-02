class CheckEntity {
  final bool check;
  final String notes;
  final int depId;
  final int planId;
  final double? density;

  CheckEntity({
    this.density,
    required this.check,
    required this.notes,
    required this.depId,
    required this.planId,
  });
}
