// @dart=2.9
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tk/tk.dart';
import 'package:get/get.dart' as g;

class TkImage extends StatelessWidget {
  final String image;

  final double width;

  final double height;

  final int quality;

  final BoxFit boxFit;

  final Widget errorWidget;

  const TkImage(this.image,
      {Key key,
      this.width,
      this.height,
      this.quality = 85,
      this.boxFit = BoxFit.cover,
      this.errorWidget})
      : super(key: key);

  String get formatUrl {
    var url = this.image + '?x-oss-process=image/';
    var query = [];
    var deviceRatio = g.Get.mediaQuery.devicePixelRatio;

    if (this.width != null || this.height != null) {
      var resize = ['resize'];
      if (this.width != null && this.height != null)
        resize.add('m_fill');
      else
        resize.add('m_lfit');

      if (this.width != null) {
        resize.add('w_' + (this.width * deviceRatio).round().toString());
      }
      if (this.height != null) {
        resize.add('h_' + (this.height * deviceRatio).round().toString());
      }
      query.add(resize.join(','));
    }

    if (g.GetPlatform.isAndroid) query.add('format,webp');

    query.add('quality,q_' + this.quality.toString());
    url += query.join('/');
    return url;
  }

  Widget get _errorWidget {
    return TkBox(
      color: Colors.black12,
      alignment: Alignment.center,
      width: width ?? double.infinity,
      minHeight: height ?? 200,
      child: Icon(
        Icons.broken_image,
        color: Colors.white,
        size: 40,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (image.isURL)
      return FancyShimmerImage(
        imageUrl: formatUrl,
        errorWidget: errorWidget ?? _errorWidget,
        boxFit: boxFit,
        width: width,
        height: height,
      );
    else
      return Image.asset(
        image,
        width: width,
        height: height,
        fit: boxFit,
      );
  }
}
