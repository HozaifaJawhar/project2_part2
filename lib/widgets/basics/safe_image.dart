import 'package:flutter/material.dart';

class SafeImage extends StatelessWidget {
  final String? urlOrAsset;
  final String fallbackAsset; // مثال: 'assets/images/news_placeholder.png'
  final BoxFit fit;
  final double? width;
  final double? height;

  const SafeImage({
    super.key,
    required this.urlOrAsset,
    required this.fallbackAsset,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
  });

  bool get _isNetwork {
    final u = (urlOrAsset ?? '').trim();
    return u.startsWith('http://') || u.startsWith('https://');
  }

  @override
  Widget build(BuildContext context) {
    final u = (urlOrAsset ?? '').trim();

    if (u.isEmpty) {
      return Image.asset(fallbackAsset, width: width, height: height, fit: fit);
    }

    if (_isNetwork) {
      return Image.network(
        u,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (_, __, ___) =>
            Image.asset(fallbackAsset, width: width, height: height, fit: fit),
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return const Center(child: CircularProgressIndicator(strokeWidth: 2));
        },
      );
    }

    // نفترض أنه asset path
    return Image.asset(
      u,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (_, __, ___) =>
          Image.asset(fallbackAsset, width: width, height: height, fit: fit),
    );
  }
}
