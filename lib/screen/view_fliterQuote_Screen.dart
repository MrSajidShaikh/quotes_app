import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../controller/quote_controller.dart';
import '../model/quote_model.dart';
import '../utils/quote_db_helper.dart';
import 'add/add_Category_screen.dart';

class View_FilteredQuote_Screen extends StatefulWidget {
  const View_FilteredQuote_Screen({super.key});

  @override
  State<View_FilteredQuote_Screen> createState() =>
      _View_FilteredQuote_ScreenState();
}

class _View_FilteredQuote_ScreenState extends State<View_FilteredQuote_Screen> {
  TextEditingController tquote = TextEditingController();

  int tempImgIndex = 3;
  String title = "";
  String subdata = "";
  String what = "";
  Map mapDATA = {};
  QuoteController control = Get.put(QuoteController());

  @override
  void initState() {
    super.initState();

    mapDATA = Get.arguments;
    what = mapDATA['what'];
    if (what == "category") {
      subdata = "category";
    } else {
      subdata = "author";
    }

    title = mapDATA["value"];
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
              backgroundColor: const Color(0xff015B8A),
              elevation: 0,
              centerTitle: true,
              title: Text(
                title,
                style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w600),
              )),
          body: Obx(
            () => ListView.builder(
              padding: EdgeInsets.only(left: 3.w, right: 3.w, top: 5.w),
              itemCount: control.filterData.length,
              itemBuilder: (context, index) {
                print("\n view screen ==== == ${control.filterData.value}");
                Random r = Random();
                control.imgIndex.value = r.nextInt(control.bgImgList.length);

                return GestureDetector(
                  onTap: () {
                    tquote = TextEditingController(
                        text: control.filterData[index]['quote']);
                    Get.defaultDialog(
                        title: "Update Quote",
                        content: Column(
                          children: [
                            SizedBox(
                              height: 1.5.h,
                            ),
                            CustomTextField(
                                hint: "Quote",
                                kboard: TextInputType.text,
                                controller: tquote),
                            SizedBox(
                              height: 2.h,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                IconButton(
                                  onPressed: () async {
                                    Quote_DB_Helper.quote_db_helper
                                        .deleteInQuoteTABLE(
                                            control.filterData[index]['id']);

                                    what == "category"
                                        ? control
                                            .filterQuotesAccordingToCategory(
                                                title)
                                        : control.filterQuotesAccordingToAuthor(
                                            title);

                                    control.loadCategoryDB();
                                    Get.back();
                                  },
                                  icon: const Icon(Icons.delete_outline_rounded),
                                  iconSize: 30.sp,
                                  color: Colors.red,
                                ),
                                IconButton(
                                  onPressed: () async {
                                    QuoteModel model = QuoteModel(
                                        author: control.filterData[index]
                                            ['author'],
                                        category: control.filterData[index]
                                            ['category'],
                                        fav: control.filterData[index]['fav'],
                                        id: control.filterData[index]['id'],
                                        quote: tquote.text);

                                    await Quote_DB_Helper.quote_db_helper
                                        .updateInQuoteTABLE(model);

                                    what == "category"
                                        ? control
                                            .filterQuotesAccordingToCategory(
                                                title)
                                        : control.filterQuotesAccordingToAuthor(
                                            title);

                                    control.loadCategoryDB();
                                    tquote.clear();
                                    Get.back();
                                  },
                                  icon: const Icon(Icons.check),
                                  iconSize: 30.sp,
                                  color: Colors.green,
                                )
                              ],
                            )
                          ],
                        ));
                  },
                  child: Container(
                    margin: EdgeInsets.only(bottom: 3.w),
                    height: 25.h,
                    width: 100.w,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.w),
                        image: DecorationImage(
                            image: AssetImage(
                                control.bgImgList[control.imgIndex.value]),
                            fit: BoxFit.cover),
                        border: Border.all(color: Colors.black12)),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 3.h,
                        ),
                        Text(
                          "${control.filterData[index]['quote']}",
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 13.sp,
                              color: Colors.white),
                          maxLines: 5,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                        const Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              what == "category"
                                  ? "- ${control.filterData[index]['author']}"
                                  : "- ${control.filterData[index]['category']}",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15.sp,
                                  color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(
                              width: 5.w,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 1.5.h,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.done_all_outlined,
                                  color: Colors.white),
                              onPressed: () {},
                            ),
                            IconButton(
                              icon: const Icon(Icons.copy_outlined,
                                  color: Colors.white),
                              onPressed: () {
                                if (control.imgIndex.value <
                                    control.bgImgList.length - 1) {
                                  tempImgIndex = control.imgIndex.value++;
                                } else {
                                  control.imgIndex.value = 0;
                                }
                                print(
                                    "img Index ==========${control.imgIndex.value}");
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.save_outlined,
                                  color: Colors.white),
                              onPressed: () {
                                Get.toNamed("/savedScreen");
                              },
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 1.h,
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          )),
    );
  }

  Widget QuoteListTile({quote, author, img}) {
    return Container(
      margin: EdgeInsets.only(bottom: 3.w),
      height: 25.h,
      width: 100.w,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.w),
          image: DecorationImage(image: AssetImage("$img"), fit: BoxFit.cover),
          border: Border.all(color: Colors.black12)),
      child: Column(
        children: [
          SizedBox(
            height: 3.h,
          ),
          Text(
            "$quote",
            style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 13.sp,
                color: Colors.white),
            maxLines: 5,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                "- $author",
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15.sp,
                    color: Colors.white),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                width: 5.w,
              ),
            ],
          ),
          SizedBox(
            height: 1.5.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.done_all_outlined, color: Colors.white),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.copy_outlined, color: Colors.white),
                onPressed: () {
                  if (control.imgIndex.value < control.bgImgList.length - 1) {
                    tempImgIndex = control.imgIndex.value++;
                  } else {
                    control.imgIndex.value = 0;
                  }
                  print("img Index ==========${control.imgIndex.value}");
                },
              ),
              IconButton(
                icon: const Icon(Icons.favorite_outline_rounded, color: Colors.white),
                onPressed: () {},
              ),
            ],
          ),
          SizedBox(
            height: 1.h,
          )
        ],
      ),
    );
  }
}