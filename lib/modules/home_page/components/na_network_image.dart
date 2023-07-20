import 'package:flutter/material.dart';
import 'package:news_app/values/strings.dart';

class NaNetworkImage extends StatelessWidget {
  const NaNetworkImage({
    required this.url,
    this.height,
    this.width,
    super.key,
    this.fit,
  });
  final String url;
  final double? height;
  final double? width;
  final BoxFit? fit;
  @override
  Widget build(BuildContext context) {
    return Image.network(
      url,
      width: width,
      height: height,
      fit: fit,
      loadingBuilder: (
        BuildContext context,
        Widget child,
        ImageChunkEvent? loadingProgress,
      ) {
        if (loadingProgress == null) {
          return child;
        }
        return Center(
          child: CircularProgressIndicator(
            value: loadingProgress.expectedTotalBytes != null
                ? loadingProgress.cumulativeBytesLoaded /
                    loadingProgress.expectedTotalBytes!
                : null,
          ),
        );
      },
      errorBuilder: (_, __, ___) => const Center(
        child: Text(AppStrings.error),
      ),
    );
  }
}
