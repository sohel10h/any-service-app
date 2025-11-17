import 'dart:convert';

class WebsocketResponseModel<T> {
  final String? type;
  final String? title;
  final T? parsedData;

  WebsocketResponseModel({
    this.type,
    this.title,
    this.parsedData,
  });

  factory WebsocketResponseModel.fromApiResponse(
    Map<String, dynamic> response,
    T Function(Map<String, dynamic>) parser,
  ) {
    final type = response['type'] ?? '';
    final notification = response['notification'] ?? {};
    final title = notification['title'] ?? '';
    final dataString = notification['data'];
    final Map<String, dynamic> decoded = jsonDecode(dataString);
    return WebsocketResponseModel(
      type: type,
      title: title,
      parsedData: parser(decoded),
    );
  }
}
