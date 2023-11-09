// ignore_for_file: prefer_typing_uninitialized_variables, must_be_immutable

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../utils/dimensions.dart';

class ImageCachedProvider extends StatelessWidget {
  ImageCachedProvider(
      {super.key, required this.url, this.x = BoxFit.fitHeight});
  final url;
  BoxFit x;
  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      key: UniqueKey(),
      imageUrl: url,
      imageBuilder: (context, imageProvider) => Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              fit: x,
              image: imageProvider,
              colorFilter: const ColorFilter.mode(
                  Colors.transparent, BlendMode.colorBurn)),
        ),
      ),
      placeholder: (context, url) => Container(),
      // const Center(child: CircularProgressIndicator()),
      errorWidget: (context, url, error) => Center(
          child: Lottie.asset('assets/images/loading-line-red.json',
              width: Dimensions.heighContainer3 / 2)),
    );
  }
}
