import 'package:carousel_slider/carousel_slider.dart';
import 'package:ecommerc_app/models/slide.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class SliderBanner extends StatefulWidget {
  const SliderBanner({super.key});

  @override
  State<SliderBanner> createState() => _SliderBannerState();
}

class _SliderBannerState extends State<SliderBanner> {
  int current = 0;
  final CarouselSliderController controller = CarouselSliderController();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 16,
      ),
      height: 220,
      child: Column(
        children: [
          CarouselSlider(
            items: slidesCarousel.map(
              (slide) {
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: DecorationImage(
                      image: NetworkImage(
                        slide,
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            ).toList(),
            carouselController: controller,
            options: CarouselOptions(
              autoPlay: true,
              autoPlayCurve: Curves.easeInQuad,
              enlargeCenterPage: true,
              aspectRatio: 2.5,
              onPageChanged: (index, reason) {
                setState(() {
                  current = index;
                });
              },
            ),
          ),
          const Spacer(),
          AnimatedSmoothIndicator(
            activeIndex: current,
            count: 3,
            effect: ExpandingDotsEffect(
              dotColor: Colors.grey[300]!,
            ),
          ),
        ],
      ),
    );
  }
}
