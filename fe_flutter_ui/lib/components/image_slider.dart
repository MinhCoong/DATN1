import 'package:fe_flutter_ui/components/widgets/imagecacheprovider.dart';
import 'package:fe_flutter_ui/models/slider.dart';
import 'package:fe_flutter_ui/provider/news_provider.dart';
import 'package:fe_flutter_ui/utils/colors.dart';
import 'package:fe_flutter_ui/utils/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../utils/list_item.dart';

class SliderP extends ConsumerStatefulWidget {
  const SliderP({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SliderPState();
}

class _SliderPState extends ConsumerState<SliderP> {
  int activeIndex = 0;
  final controller = CarouselController();
  @override
  Widget build(BuildContext context) {
    final lstSlider = ref.watch(sliderMrSoaiData);

    return lstSlider.when(
        data: (data) {
          List<SliderMrSoai> lslider = data.map((e) => e).toList();
          return Padding(
            padding: EdgeInsets.symmetric(vertical: Dimensions.heighContainer0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CarouselSlider.builder(
                    carouselController: controller,
                    itemCount: lslider.length,
                    itemBuilder: (context, index, realIndex) {
                      final urlImage = lslider[index].imageSlider!;
                      return buildImage(urlImage, index);
                    },
                    options: CarouselOptions(
                        height: Dimensions.heighContainer3 / 1.5,
                        viewportFraction: 0.95,
                        autoPlay: true,
                        enableInfiniteScroll: false,
                        autoPlayAnimationDuration: const Duration(seconds: 2),
                        enlargeCenterPage: true,
                        scrollPhysics: const BouncingScrollPhysics(),
                        enlargeFactor: 0.4,
                        onPageChanged: (index, reason) => setState(() => activeIndex = index))),
                SizedBox(height: Dimensions.heighContainer0),
                buildIndicator(lslider.length)
              ],
            ),
          );
        },
        error: (error, s) => Text(error.toString()),
        loading: () =>
            Center(child: Lottie.asset('assets/images/loading-line-red.json', width: Dimensions.heighContainer3 / 2)));
  }

  Widget buildIndicator(int x) => AnimatedSmoothIndicator(
        onDotClicked: animateToSlide,
        effect: ExpandingDotsEffect(
            dotWidth: 10,
            dotHeight: 4,
            paintStyle: PaintingStyle.fill,
            dotColor: Colors.grey.shade300,
            activeDotColor: AppColors.BURGUNDY.withOpacity(.9)),
        activeIndex: activeIndex,
        count: x,
      );

  void animateToSlide(int index) => controller.animateToPage(index);
}

Widget buildImage(String urlImage, int index) => ClipRRect(
    borderRadius: const BorderRadius.all(Radius.circular(15)),
    child: ImageCachedProvider(
      url: UrlImageSlider + urlImage,
      x: BoxFit.cover,
    ));
