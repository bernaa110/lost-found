import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:image_picker/image_picker.dart';

class ImageUploadService {
  static Future<String?> uploadItemImage(XFile imageFile) async {
    final cloudinary = CloudinaryPublic(
      'dgjxdajkh',
      'unsigned_preset',
      cache: false,
    );
    try {
      CloudinaryResponse response = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(
          imageFile.path,
          resourceType: CloudinaryResourceType.Image,
        ),
      );
      return response.secureUrl;
    } catch (e) {
      print('Cloudinary upload error: $e');
      return null;
    }
  }
}