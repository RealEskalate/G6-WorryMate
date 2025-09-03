import 'package:flutter/material.dart';
import 'data.dart';

class ScrollableServicesWidget extends StatelessWidget {

  final double width;
  final double height;
  final List<AppService> servicesData;
  final bool showTitle;
const ScrollableServicesWidget({super.key, required this.height, required this.width, required this.showTitle, required this.servicesData});

  @override
  Widget build(BuildContext context){
    return SizedBox(
      width: width,
      height: height,
      child: ListView(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        children: servicesData.map((service){
          return Container(
            padding: EdgeInsets.only(right: width*0.03),
            width: width*0.3,
            height: height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: showTitle ?  height*0.75 : height,
                  width: width*0.45,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    image:DecorationImage(
                      fit: BoxFit.cover,
                      image:AssetImage(service.coverImage.url))
                  ),
                ),
                showTitle ? Text(service.title, maxLines: 2, style: TextStyle(fontSize: height*0.08, color: Colors.white),) : const SizedBox()
              ],
            ),
          );}
        ).toList(),
      ),
    );
  }
}