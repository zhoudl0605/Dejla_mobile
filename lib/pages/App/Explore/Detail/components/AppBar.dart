import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class DeatilPageAppBar extends StatelessWidget {
  const DeatilPageAppBar({Key key, this.images}) : super(key: key);
  final List<Widget> images;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: MediaQuery.of(context).size.width / 4 * 3 - 25,
      floating: false,
      pinned: true,
      snap: false,
      flexibleSpace: new FlexibleSpaceBar(
        background: Container(
          color: Colors.white,
          child: CarouselSlider(
            items: images,
            options: CarouselOptions(
              aspectRatio: 4 / 3,
              viewportFraction: 1.0,
              initialPage: 0,
              enableInfiniteScroll: true,
              autoPlay: false,
              reverse: false,
              scrollDirection: Axis.horizontal,
            ),
          ),
        ),
        centerTitle: true,
        collapseMode: CollapseMode.pin,
      ),
    );
  }
}
