import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CustomCachedImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final double borderRadius;
  final Widget? placeholder;
  final Widget? errorWidget;

  const CustomCachedImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius = 0,
    this.placeholder,
    this.errorWidget,
  });

  /// Normalizes URL to use HTTPS for production servers
  String _normalizeUrl(String url) {
    // Fix Railway URLs that come as http instead of https
    if (url.contains('railway.app') && url.startsWith('http://')) {
      return url.replaceFirst('http://', 'https://');
    }
    return url;
  }

  @override
  Widget build(BuildContext context) {
    var normalizedUrl = _normalizeUrl(imageUrl);
    // debugPrint('Loading Image: $normalizedUrl'); // Uncomment for debugging
    
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: CachedNetworkImage(
        imageUrl: normalizedUrl,
        width: width,
        height: height,
        fit: fit,
        placeholder: (context, url) =>
            placeholder ??
            Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                width: width,
                height: height,
                color: Colors.white,
              ),
            ),
        errorWidget: (context, url, error) =>
            errorWidget ??
            Container(
              width: width,
              height: height,
              color: Colors.grey[200],
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.image_not_supported_outlined, color: Colors.grey[400], size: 32),
                  if (height != null && height! > 60) ...[
                    const SizedBox(height: 4),
                    Text(
                      'No Image', 
                      style: TextStyle(color: Colors.grey[500], fontSize: 10),
                    ),
                  ],
                ],
              ),
            ),
      ),
    );
  }
}
