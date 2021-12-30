/// Модель для передачи изображения
/// data - base64Encode
/// extension - расширение изображения
class ImageRequestModel{
  String data;
  String extension;

  ImageRequestModel({required this.extension, required this.data});
}