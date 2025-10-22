import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:service_la/view/widgets/common/skeleton.dart';
import 'package:cached_network_image/cached_network_image.dart';

class NetworkImageLoader extends StatelessWidget {
  final String src;
  final Color? color;
  final double height;
  final double width;
  final double? radius;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final String? errorImagePath;

  const NetworkImageLoader(
    this.src, {
    super.key,
    required this.height,
    required this.width,
    this.color,
    this.fit = BoxFit.fill,
    this.radius,
    this.borderRadius,
    this.errorImagePath,
  });

  @override
  Widget build(BuildContext context) {
    final safeUrl = _getSafeUrl(src);
    final fallback = errorImagePath?.isNotEmpty == true ? errorImagePath! : "assets/images/no_image_available.jpg";
    final border = borderRadius ?? BorderRadius.circular(radius ?? 16.r);

    return ClipRRect(
      borderRadius: border,
      child: safeUrl.startsWith("assets/")
          ? Image.asset(safeUrl, height: height, width: width, fit: fit, color: color)
          : CachedNetworkImage(
              height: height,
              width: width,
              fit: fit,
              imageUrl: safeUrl,
              imageBuilder: (context, imageProvider) => color != null
                  ? ColorFiltered(
                      colorFilter: ColorFilter.mode(color!, BlendMode.color),
                      child: Image(image: imageProvider, fit: fit),
                    )
                  : Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(image: imageProvider, fit: fit),
                      ),
                    ),
              placeholder: (_, __) => const Skeleton(),
              errorWidget: (_, url, error) {
                log("Image load failed: $url -> $error");
                return fallback.startsWith("assets/")
                    ? Image.asset(fallback, height: height, width: width, fit: fit, color: color)
                    : Icon(Icons.image, color: color ?? Colors.grey, size: height / 2);
              },
            ),
    );
  }

  String _getSafeUrl(String? url) {
    if (url == null || url.trim().isEmpty || url.toLowerCase() == "null") {
      return errorImagePath?.isNotEmpty == true ? errorImagePath! : "assets/images/no_image_available.jpg";
    }
    return url;
  }
}
