import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:invoice_maker/main.dart';
import 'package:invoice_maker/utils/widgets/cached_network_image.dart';
import 'package:nb_utils/nb_utils.dart';

InputDecoration inputDecoration(BuildContext context, {required String label, Widget? prefixIcon}) {
  return InputDecoration(
    border: OutlineInputBorder(borderRadius: radius(80)),
    label: Text('$label', style: primaryTextStyle()),
    alignLabelWithHint: true,
    floatingLabelAlignment: FloatingLabelAlignment.center,
    prefixIcon: prefixIcon,
  );
}

Widget loaderWidgetWithObserver({bool? isVisible}) {
  return Observer(
    builder: (context) => Loader().visible(isVisible ?? appStore.isLoading),
  );
}

Widget circleAvatarWidget({required String image, double size = 64}) {
  return cachedImage(image, height: size, width: size, fit: BoxFit.cover).cornerRadiusWithClipRRect(80);
}
