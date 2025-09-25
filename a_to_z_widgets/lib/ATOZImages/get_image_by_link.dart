import 'package:flutter/material.dart';
import 'package:a_to_z_widgets/ATOZAnimations/a_to_z_animation.dart'; // غيّر المسار حسب مكان ملف AtoZLoader

class CloudinaryImage extends StatelessWidget {
  final String imageUrl;
  final double imageHeight;
  const CloudinaryImage({
    Key? key,
    required this.imageUrl,
    required this.imageHeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.network(
      imageUrl,
      fit: BoxFit.fill,
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        // استدعاء AtoZLoader مباشرة
        return const Center(child: AtoZLoader());
      },
      errorBuilder: (context, error, stackTrace) {
        return Center(
          child: Icon(
            Icons.category,
            color: Colors.grey[400],
            size: imageHeight * 0.5,
          ),
        );
      },
    );
  }
}
