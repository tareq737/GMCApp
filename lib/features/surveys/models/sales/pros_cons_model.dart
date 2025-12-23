class ProsConsItem {
  final int id;
  final String detail;

  ProsConsItem({required this.id, required this.detail});

  factory ProsConsItem.fromJson(Map<String, dynamic> json) {
    return ProsConsItem(
      id: json['id'] as int,
      detail: json['detail'] as String,
    );
  }
}

class ProsConsResponse {
  final List<ProsConsItem> pros;
  final List<ProsConsItem> cons;

  ProsConsResponse({required this.pros, required this.cons});

  factory ProsConsResponse.fromJson(Map<String, dynamic> json) {
    return ProsConsResponse(
      pros: (json['pros'] as List)
          .map((item) => ProsConsItem.fromJson(item))
          .toList(),
      cons: (json['cons'] as List)
          .map((item) => ProsConsItem.fromJson(item))
          .toList(),
    );
  }
}
