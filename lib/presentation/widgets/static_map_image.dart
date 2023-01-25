import 'package:flutter/material.dart';
import 'package:lenden_delivery/presentation/widgets/loading_animation_widget.dart';

/// Widget [StaticMapImage] : The StaticMapImage for displaying map static image
class StaticMapImage extends StatelessWidget {
  final String previewImageUrl;
  final double mHeight;

  const StaticMapImage(
      {@required this.previewImageUrl, @required this.mHeight});

  // =========================== Build Function ===========================

  @override
  Widget build(BuildContext context) {
    return Container(
        height: mHeight * 0.25,
        width: double.infinity,
        alignment: Alignment.center,
        child: previewImageUrl == null || previewImageUrl == ""
            ? const Text(
                "Sorry, there are no any ongoing rides for map",
                textAlign: TextAlign.center,
              )
            : Image.network(previewImageUrl,
                fit: BoxFit.cover, width: double.infinity,
                loadingBuilder: (ctx, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(child: LoadingAnimation());
              }));
  }
}
