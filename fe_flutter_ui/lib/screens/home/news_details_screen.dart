import 'package:fe_flutter_ui/components/widgets/imagecacheprovider.dart';
import 'package:fe_flutter_ui/models/news.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';

import '../../components/widgets/big_text.dart';
import '../../utils/colors.dart';
import '../../utils/dimensions.dart';
import '../../utils/list_item.dart';

class NewDetailsScreen extends StatelessWidget {
  const NewDetailsScreen({super.key, required this.news});
  final News news;

  @override
  Widget build(BuildContext context) {
    var x = news.newsDate!.split('T').first.split('-');
    return Scaffold(
      backgroundColor: AppColors.BACKGROUND_COLOR,
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        toolbarHeight: Dimensions.heightListtile,
        elevation: 4,
        title: BigText(
          text: 'Tin tức',
          fontweight: FontWeight.w800,
          color: Colors.black.withOpacity(.9),
        ),
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
            size: 20,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            15,
            15,
            15,
            Dimensions.heightListtile * 0.9,
          ),
          child: Column(
            children: [
              BigText(
                text: news.title!,
                size: 15,
                fontweight: FontWeight.w800,
              ),
              SizedBox(
                height: Dimensions.heighContainer0,
              ),
              Neumorphic(
                style: NeumorphicStyle(
                  shape: NeumorphicShape.flat,
                  boxShape: NeumorphicBoxShape.roundRect(const BorderRadius.all(Radius.circular(15))),
                  depth: 6,
                  color: AppColors.WH,
                  lightSource: LightSource.top,
                ),
                child: SizedBox(
                  height: Dimensions.heighContainer2 / 1.2,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(15)),
                    child: ImageCachedProvider(
                      url: UrlImageNews + news.image!,
                      x: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: Dimensions.heighContainer0 * 2,
              ),
              BigText(
                text: "    ${news.description!}",
                overFlow: TextOverflow.visible,
              ),
              SizedBox(
                height: Dimensions.heighContainer0,
              ),
              Align(alignment: Alignment.bottomRight, child: BigText(text: 'Ngày: ${x[2]}/${x[1]}/${x[0]}')),
            ],
          ),
        ),
      ),
    );
  }
}
