import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lost_found_app/theme/app_colors.dart';
import '../services/image_upload_service.dart';

class ImagePickerButton extends StatefulWidget {
  final ValueChanged<String?> onImageUploaded;
  final bool isUploading;
  final String? imageUrl;

  const ImagePickerButton({
    super.key,
    required this.onImageUploaded,
    this.isUploading = false,
    this.imageUrl,
  });

  @override
  State<ImagePickerButton> createState() => _ImagePickerButtonState();
}

class _ImagePickerButtonState extends State<ImagePickerButton> {
  Future<void> _pickAndUpload(BuildContext context, ImageSource source) async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: source,
      maxWidth: 1200,
      maxHeight: 1200,
      imageQuality: 80,
    );
    if (image != null) {
      widget.onImageUploaded(null);
      final url = await ImageUploadService.uploadItemImage(image);
      if (mounted) widget.onImageUploaded(url);
    }
  }

  void _showImageSourceModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(18))),
      builder: (ctx) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt, color: kLogoLightBlue),
              title: const Text('Сликај со камера', style: TextStyle(color: kLogoLightBlue)),
              onTap: widget.isUploading
                  ? null
                  : () {
                Navigator.of(ctx).pop();
                _pickAndUpload(context, ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library, color: kLogoLightBlue),
              title: const Text('Одбери од галерија', style: TextStyle(color: kLogoLightBlue)),
              onTap: widget.isUploading
                  ? null
                  : () {
                Navigator.of(ctx).pop();
                _pickAndUpload(context, ImageSource.gallery);
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OutlinedButton.icon(
          onPressed: widget.isUploading ? null : () => _showImageSourceModal(context),
          icon: widget.isUploading
              ? const SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(strokeWidth: 2, color: kLogoLightBlue),
          )
              : const Icon(Icons.add_a_photo_outlined, color: kLogoLightBlue),
          label: Text(
            widget.imageUrl != null && !widget.isUploading
                ? 'Слика додадена'
                : "Додај слика",
            style: const TextStyle(color: kLogoLightBlue),
          ),
          style: OutlinedButton.styleFrom(
            foregroundColor: kLogoLightBlue,
            side: const BorderSide(color: Colors.black54),
          ),
        ),
        if (widget.imageUrl != null && widget.imageUrl!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(9),
              child: Image.network(widget.imageUrl!, height: 100, width: 160, fit: BoxFit.cover),
            ),
          ),
      ],
    );
  }
}