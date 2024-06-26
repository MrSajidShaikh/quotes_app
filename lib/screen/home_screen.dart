import 'package:amazing_quotes/controller/quote_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  QuoteController control = Get.put(QuoteController());


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
            backgroundColor: const Color(0xff015B8A),
            onPressed: () {
              Get.toNamed("/add");
            },
            child: const Icon(Icons.add_outlined)),
        appBar: AppBar(
          backgroundColor: const Color(0xff015B8A),
          title: const Text("Quotes"),
          centerTitle: true,

          // leading: IconButton(icon: Icon(Icons.menu_rounded), iconSize: 25,
          //   onPressed: ()  {},),
        ),
        body: Padding(
          padding: EdgeInsets.all(5),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: CarouselSlider(
                        items: control.imgList
                            .map((e) => Container(
                          height: 25.h,
                          width: 90.w,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.w),
                              color: Colors.amber,
                              image: DecorationImage(
                                  image: AssetImage(e),
                                  fit: BoxFit.fill)),
                        ))
                            .toList(),
                        options: CarouselOptions(
                          autoPlay: true,
                          scrollDirection: Axis.horizontal,
                          viewportFraction: 1,
                          height: 25.h,
                          initialPage: control.currentSliderIndex.value,
                          onPageChanged: (index, reason) {
                            control.currentSliderIndex.value = index;
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Container(
                  height: 25.h,
                  width: 100.w,
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TitleTab("Quotes by Category"),
                      Expanded(
                        child: Obx(
                              () => GridView.builder(
                            itemCount: control.categoryList.length,
                            scrollDirection: Axis.horizontal,
                            padding: EdgeInsets.all(2.5),
                            gridDelegate:
                            SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisExtent: 46.w,
                                mainAxisSpacing: 10,
                                crossAxisSpacing: 5),
                            itemBuilder: (context, index) {
                              // Random r = Random();
                              //int colorBookIndex = r.nextInt(control.colorPaleteList.length);
                              List<Color> colorpalate =
                              control.colorPaleteList[index + 4];

                              return GestureDetector(
                                  onTap: () {
                                    control.filterQuotesAccordingToCategory(
                                        control.categoryList[index]
                                        ['category']);
                                    Get.toNamed("/viewCategory", arguments: {
                                      "what": "category",
                                      "value": control.categoryList[index]
                                      ['category']
                                    });
                                  },
                                  child: SubTitleBox(
                                      subtitle: control.categoryList[index]
                                      ['category'],
                                      colorList: colorpalate));
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Container(
                  height: 35.h,
                  width: 100.w,
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TitleTab("Quotes by Author"),
                      Expanded(
                        child: Obx(
                              () => GridView.builder(
                            itemCount: control.authorList.length,
                            scrollDirection: Axis.horizontal,
                            padding: EdgeInsets.all(2.5),
                            gridDelegate:
                            SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                mainAxisExtent: 46.w,
                                mainAxisSpacing: 10,
                                crossAxisSpacing: 5),
                            itemBuilder: (context, index) {
                              // Random r = Random();
                              //int colorBookIndex = r.nextInt(control.colorPaleteList.length);
                              List<Color> colorpalate =
                              control.colorPaleteList[index];

                              return GestureDetector(
                                  onTap: () {
                                    control.filterQuotesAccordingToAuthor(
                                        control.authorList[index]);
                                    Get.toNamed("/viewCategory", arguments: {
                                      "what": "author",
                                      "value": control.authorList[index]
                                    });
                                  },
                                  child: SubTitleBox(
                                      subtitle: control.authorList[index],
                                      colorList: colorpalate));
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget TitleTab(String title) => Padding(
    padding: EdgeInsets.symmetric(vertical: 5),
    child: Text(
      "$title",
      style: TextStyle(fontWeight: FontWeight.w500, fontSize: 17.sp),
    ),
  );

  Widget SubTitleBox({subtitle, colorList}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 2.5),
      height: 9.h,
      width: 45.w,
      alignment: Alignment.center,
      child: Text(
        "$subtitle",
        style: TextStyle(
            fontSize: 16.sp, fontWeight: FontWeight.w500, color: Colors.white),
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.w),
          gradient: LinearGradient(colors: colorList),
          color: Colors.redAccent),
    );
  }
}