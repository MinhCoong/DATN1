import 'package:expandable/expandable.dart';
import 'package:fe_flutter_ui/components/app_bar.dart';
import 'package:fe_flutter_ui/components/image_slider.dart';
import 'package:fe_flutter_ui/components/item_cardMrSoai.dart';
import 'package:fe_flutter_ui/components/item_login_cart.dart';
import 'package:fe_flutter_ui/components/loyalty_cards.dart';
import 'package:fe_flutter_ui/models/news.dart';
import 'package:fe_flutter_ui/screens/home/news_details_screen.dart';
import 'package:fe_flutter_ui/utils/colors.dart';
import 'package:fe_flutter_ui/utils/dimensions.dart';
import 'package:fe_flutter_ui/components/widgets/big_text.dart';
import 'package:fe_flutter_ui/components/widgets/small_text.dart';
import 'package:fe_flutter_ui/utils/list_item.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../components/item_Type_Of_Food.dart';
import '../../components/widgets/imagecacheprovider.dart';
import '../../models/category.dart';
import '../../provider/category_provider.dart';
import '../../provider/news_provider.dart';

final indexScreenProvider = StateProvider<int>((ref) {
  return 0;
});

final methodDeliveryProvider = StateProvider<String>((ref) {
  return Giaoden;
});

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool isTap = false;
  @override
  Widget build(BuildContext context) {
    final listCate = ref.watch(categoryDataProvider);
    final listNew = ref.watch(newsData);
    return Scaffold(
      backgroundColor: AppColors.BACKGROUND_COLOR,
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(Dimensions.heigthAppBar), child: const MyAppBarMS(txt: 'ơi, có gì mới không')),
      body: SafeArea(
        child: CustomScrollView(
          anchor: 0.0,
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: ExpandableNotifier(
                  child: ScrollOnExpand(
                      child: ExpandablePanel(
                theme: const ExpandableThemeData(tapBodyToExpand: true, tapBodyToCollapse: true),
                collapsed: SizedBox(height: Dimensions.heighContainer1 * 1.8, child: const ItemCardMrSoai()),
                expanded: FirebaseAuth.instance.currentUser == null ? const LoginCard() : const LoyaltyCard(),
                builder: (_, collapsed, expanded) {
                  return Expandable(
                    collapsed: collapsed,
                    expanded: expanded,
                    theme: const ExpandableThemeData(),
                  );
                },
              ))),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: Dimensions.heigthAppBar2 * .9,
                width: Dimensions.screenWidth,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 5,
                      width: Dimensions.padding_MarginHome3,
                      decoration: BoxDecoration(color: AppColors.BURGUNDY, borderRadius: BorderRadius.circular(10)),
                    ),
                    SizedBox(
                      height: Dimensions.heighContainer0 / 1.5,
                    ),
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 15,
                              child: NeumorphicButton(
                                onPressed: () {
                                  ref.read(indexScreenProvider.notifier).update((state) => 1);
                                  ref.read(methodDeliveryProvider.notifier).update((state) => Giaoden);
                                },
                                padding: const EdgeInsets.fromLTRB(10, 5, 10, 25),
                                style: NeumorphicStyle(
                                    shape: NeumorphicShape.flat,
                                    boxShape: NeumorphicBoxShape.roundRect(
                                      const BorderRadius.horizontal(left: Radius.circular(15)),
                                    ),
                                    depth: 2,
                                    lightSource: LightSource.topLeft,
                                    color: AppColors.WHX),
                                child: ListTile(
                                  title: const Image(
                                    image: AssetImage('assets/images/delivery.png'),
                                    fit: BoxFit.fitHeight,
                                  ),
                                  subtitle: Align(
                                      alignment: Alignment.topCenter,
                                      child: SmallText(
                                        text: 'Giao hàng',
                                        size: 10,
                                      )),
                                ),
                              ),
                            ),
                            const Spacer(),
                            Expanded(
                              flex: 15,
                              child: NeumorphicButton(
                                onPressed: () {
                                  ref.read(indexScreenProvider.notifier).update((state) => 1);
                                  ref.read(methodDeliveryProvider.notifier).update((state) => Denlay);
                                },
                                padding: const EdgeInsets.fromLTRB(10, 5, 10, 25),
                                style: NeumorphicStyle(
                                    shape: NeumorphicShape.flat,
                                    boxShape: NeumorphicBoxShape.roundRect(
                                      const BorderRadius.horizontal(right: Radius.circular(15)),
                                    ),
                                    depth: 2,
                                    lightSource: LightSource.topLeft,
                                    color: AppColors.WHX),
                                child: ListTile(
                                  title: const Image(
                                    image: AssetImage('assets/images/takeaway.png'),
                                    fit: BoxFit.fitHeight,
                                  ),
                                  subtitle: Align(
                                      alignment: Alignment.topCenter,
                                      child: SmallText(
                                        text: 'Mang đi',
                                        size: 10,
                                      )),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            const SliverToBoxAdapter(
              child: SliderP(),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: Dimensions.heighContainer0 * 1.5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    BigText(
                      text: 'Các loại món',
                      size: 16,
                    ),
                    SizedBox(
                      width: Dimensions.padding_MarginHome2,
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: Dimensions.highSBox),
                      child: const Icon(
                        Icons.brunch_dining_rounded,
                        size: 25,
                      ),
                    )
                  ],
                ),
              ),
            ),
            listCate.when(
                data: (categoryData) {
                  List<Categorys> lstCategory = categoryData.map((e) => e).toList();
                  return SliverToBoxAdapter(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: SizedBox(
                              height: Dimensions.heighContainer1 * 1.4,
                              child: ListView.builder(
                                  physics: const BouncingScrollPhysics(),
                                  scrollDirection: Axis.horizontal,
                                  itemCount: lstCategory.length,
                                  itemBuilder: (_, index) {
                                    return Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: Dimensions.padding_MarginHome2 / 2,
                                          vertical: Dimensions.heighContainer0 * 1.5),
                                      child: ItemTypeOfFood(
                                          index: index,
                                          url: lstCategory[index].image,
                                          firstValue: lstCategory[0].categoryName,
                                          text: lstCategory[index].categoryName),
                                    );
                                  }),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                error: (error, s) => SliverToBoxAdapter(child: Text(error.toString())),
                loading: () => SliverToBoxAdapter(
                      child: Center(
                          child: Lottie.asset('assets/images/loading-line-red.json',
                              width: Dimensions.heighContainer3 / 2)),
                    )),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: Dimensions.heighContainer0 * 1.5),
                child: Row(
                  children: [
                    BigText(
                      text: 'Khám phá',
                      size: 16,
                    ),
                    SizedBox(
                      width: Dimensions.padding_MarginHome2,
                    ),
                    const Icon(
                      Icons.light,
                      size: 25,
                    )
                  ],
                ),
              ),
            ),
            listNew.when(
                data: (data) {
                  final lNews = data.map((e) => e).toList();
                  return SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: Dimensions.heighContainer0 * 1.5),
                      child: GridView.builder(
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              mainAxisExtent: Dimensions.heighContainer2,
                              crossAxisSpacing: Dimensions.heighContainer0 * 1.5,
                              childAspectRatio: 0.78,
                              crossAxisCount: 2),
                          itemCount: lNews.length,
                          padding: const EdgeInsets.symmetric(
                            vertical: 5,
                          ),
                          primary: false,
                          shrinkWrap: true,
                          itemBuilder: (context, index) => GestureDetector(
                              onTap: () {
                                Get.to(() => NewDetailsScreen(news: lNews[index]));
                              },
                              child: ItemNews(news: lNews[index]))),
                    ),
                  );
                },
                error: (error, s) => SliverToBoxAdapter(child: Text(error.toString())),
                loading: () => SliverToBoxAdapter(
                      child: Center(
                          child: Lottie.asset('assets/images/loading-line-red.json',
                              width: Dimensions.heighContainer3 / 2)),
                    )),
          ],
        ),
      ),
    );
  }
}

class ItemNews extends StatelessWidget {
  const ItemNews({
    super.key,
    required this.news,
  });
  final News news;
  @override
  Widget build(BuildContext context) {
    var x = news.newsDate.toString().split('T').first.split('-');
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
            child: Neumorphic(
          margin: EdgeInsets.only(top: Dimensions.heighContainer0),
          style: NeumorphicStyle(
              shape: NeumorphicShape.flat,
              boxShape: NeumorphicBoxShape.roundRect(const BorderRadius.all(Radius.circular(20))),
              depth: 3,
              lightSource: LightSource.topLeft,
              color: AppColors.BACKGROUND_COLOR),
          child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              child: ImageCachedProvider(
                url: UrlImageNews + news.image!,
              )),
        )),
        SizedBox(height: Dimensions.highSBox),
        BigText(
          text: news.title!,
          overFlow: TextOverflow.fade,
          size: 15,
        ),
        Row(
          children: [
            FaIcon(
              FontAwesomeIcons.calendar,
              color: Colors.black.withOpacity(.7),
              size: 15,
            ),
            SizedBox(
              width: Dimensions.padding_MarginHome2 / 2,
            ),
            SmallText(
              text: '${x[2]}/${x[1]}/${x[0]}',
              size: 12,
              color: Colors.black.withOpacity(.5),
            )
          ],
        )
      ],
    );
  }
}
