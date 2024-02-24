class Book {
  String name;
  String pdfUrl;
  int pageNumber;
  int start; 
  int end;

  Book({
    required this.name,
    required this.pdfUrl,
    required this.pageNumber,
    required this.start,
    required this.end,
  });

  // Convert Book object to a Map
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'pdf_url': pdfUrl,
      'page_number': pageNumber,
      'start': start,
      'end': end,
    };
  }

  // Create a Book object from a Map
  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      name: json['name'] ?? '',
      pdfUrl: json['pdf_url'] ?? '',
      pageNumber: json['page_number'] ?? 0,
      start: json['start'] ?? 0,
      end: json['end'] ?? 0,
    );
  }
}
