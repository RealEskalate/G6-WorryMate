import 'package:flutter/material.dart';
import 'data.dart';

class ScrollableServicesWidget extends StatelessWidget {
  final double width;
  final double height;
  final List<AppService> servicesData;
  final bool showTitle;
  final ValueChanged<AppService>? onServiceTap;
  final bool isDark;
  const ScrollableServicesWidget({
    super.key,
    required this.height,
    required this.width,
    required this.showTitle,
    required this.servicesData,
    this.onServiceTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    // final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black87;

    return SizedBox(
      width: width,
      height: height,
      child: ListView(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        children: servicesData.map((service) {
          return SizedBox(
            width: width * 0.3,
            height: height,
            child: InkWell(
              borderRadius: BorderRadius.circular(6.0),
              onTap: () => onServiceTap?.call(service),
              child: Padding(
                padding: EdgeInsets.only(right: width * 0.03),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: showTitle ? height * 0.75 : height,
                      width: width * 0.45,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage(service.coverImage.url),
                        ),
                      ),
                    ),
                    showTitle
                        ? Text(
                            service.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: height * 0.08,
                              color: textColor,
                              fontWeight: FontWeight.w500,
                            ),
                          )
                        : const SizedBox(),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
