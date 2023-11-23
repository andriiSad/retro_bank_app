import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppSvgButton extends StatefulWidget {
  const AppSvgButton({
    required this.path,
    super.key,
    this.fillColor = Colors.white,
    this.shadowColor = Colors.black,
    this.size = 50.0,
    this.isNetwork = false,
    this.onPressed,
  });

  final String path;
  final Color fillColor;
  final Color shadowColor;
  final double size;
  final void Function()? onPressed;
  final bool isNetwork;

  @override
  State<AppSvgButton> createState() => _AppSvgButtonState();
}

class _AppSvgButtonState extends State<AppSvgButton> {
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: isPressed ? const Offset(3, 4) : Offset.zero,
      child: Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          shape: BoxShape.circle, // Make the button circular
          color: widget.fillColor,
          border: Border.all(
            color: widget.shadowColor,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: isPressed ? Colors.transparent : widget.shadowColor,
              offset: isPressed ? Offset.zero : const Offset(3, 4),
            ),
          ],
        ),
        child: InkWell(
          onTapDown: (_) {
            if (widget.onPressed != null) {
              setState(() {
                isPressed = true;
              });
            }
          },
          onTapUp: (_) {
            setState(() {
              isPressed = false;
            });
          },
          onTapCancel: () {
            setState(() {
              isPressed = false;
            });
          },
          onTap: widget.onPressed != null ? () => widget.onPressed!() : null,
          child: widget.isNetwork
              ? CachedNetworkImage(
                  imageUrl: widget.path,
                  imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle, // Make the button circular
                      image: DecorationImage(
                        fit: BoxFit.fill,
                        image: imageProvider,
                      ),
                    ),
                  ),
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      Center(
                    child: CircularProgressIndicator(
                      value: downloadProgress.progress,
                      color: Colors.grey,
                    ),
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                )
              : Center(
                  child: SvgPicture.asset(
                    widget.path,
                    width: widget.size / 2,
                    height: widget.size / 2,
                  ),
                ),
        ),
      ),
    );
  }
}
