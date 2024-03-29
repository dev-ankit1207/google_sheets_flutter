import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:invoice_maker/utils/images.dart';
import 'package:nb_utils/nb_utils.dart';

Widget cachedImage(
  String? url, {
  double? height,
  double? width,
  BoxFit? fit,
  Color? color,
  String? placeHolderImage,
  AlignmentGeometry? alignment,
  bool usePlaceholderIfUrlEmpty = true,
}) {
  if (url.validate().isEmpty) {
    return placeHolderWidget(placeHolderImage: placeHolderImage, height: height, width: width, fit: fit, alignment: alignment);
  } else if (url.validate().startsWith('http')) {
    return CachedNetworkImage(
      imageUrl: url!,
      height: height,
      width: width,
      fit: fit,
      color: color,
      alignment: alignment as Alignment? ?? Alignment.center,
      errorWidget: (_, s, d) {
        return placeHolderWidget(placeHolderImage: placeHolderImage, height: height, width: width, fit: fit, alignment: alignment);
      },
    );
  } else {
    return Image.asset(
      url!,
      height: height,
      width: width,
      fit: fit,
      color: color,
      alignment: alignment ?? Alignment.center,
      errorBuilder: (_, s, d) {
        return placeHolderWidget(height: height, width: width, fit: fit, alignment: alignment);
      },
    );
  }
}

Widget placeHolderWidget({String? placeHolderImage, double? height, double? width, BoxFit? fit, AlignmentGeometry? alignment}) {
  return Image.asset(
    placeHolderImage ?? placeholder_image,
    height: height,
    width: width,
    alignment: alignment ?? Alignment.center,
  );
}
