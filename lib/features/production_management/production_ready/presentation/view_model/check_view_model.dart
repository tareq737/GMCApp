class CheckViewModel {
  final bool check;
  final String notes;
  final int depId;
  final int planId;
  final double? density;

  CheckViewModel({
    required this.planId,
    required this.check,
    required this.notes,
    required this.depId,
    this.density,
  });
}
