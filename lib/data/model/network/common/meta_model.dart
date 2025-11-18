class MetaModel {
  final int? page;
  final int? pageSize;
  final int? totalItems;
  final int? totalPages;

  MetaModel({
    this.page,
    this.pageSize,
    this.totalItems,
    this.totalPages,
  });

  factory MetaModel.fromJson(Map<String, dynamic> json) => MetaModel(
        page: json["page"],
        pageSize: json["page_size"],
        totalItems: json["total_items"],
        totalPages: json["total_pages"],
      );

  Map<String, dynamic> toJson() => {
        "page": page,
        "page_size": pageSize,
        "total_items": totalItems,
        "total_pages": totalPages,
      };
}
