import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:pdpa/app/config/config.dart';

class RecentlyImageSelector extends StatelessWidget {
  const RecentlyImageSelector({
    super.key,
    this.width = 80.0,
    this.height = 80.0,
    required this.imageUrls,
    required this.currentImageUrl,
    this.onSelected,
  });

  final double width;
  final double height;
  final List<String> imageUrls;
  final String currentImageUrl;
  final Function(String value)? onSelected;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      shrinkWrap: true,
      itemCount: imageUrls.length,
      itemBuilder: (context, index) {
        return _buildImage(
          context,
          imageUrl: imageUrls[index],
        );
      },
      separatorBuilder: (context, _) => const SizedBox(
        width: UiConfig.actionSpacing,
      ),
    );
  }

  InkWell _buildImage(
    BuildContext context, {
    required String imageUrl,
  }) {
    return InkWell(
      onTap: () {
        if (onSelected != null) {
          onSelected!(imageUrl);
        }
      },
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background.withOpacity(0.6),
          border: Border.all(
            color: imageUrl == currentImageUrl
                ? Theme.of(context).colorScheme.primary
                : Colors.transparent,
            width: 2.0,
          ),
        ),
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          placeholder: (context, url) {
            return SizedBox(
              width: width,
              height: height,
              child: LoadingAnimationWidget.hexagonDots(
                color: Theme.of(context).colorScheme.primary,
                size: 24.0,
              ),
            );
          },
          errorWidget: (context, url, error) {
            return SizedBox(
              width: width,
              height: height,
              child: Icon(
                Ionicons.warning_outline,
                color: Theme.of(context).colorScheme.onError,
              ),
            );
          },
        ),
      ),
    );
  }
}
