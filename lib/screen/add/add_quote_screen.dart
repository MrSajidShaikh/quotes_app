import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:sizer/sizer.dart';

import '../../controller/quote_controller.dart';
import '../../model/quote_model.dart';
import '../../utils/quote_db_helper.dart';

class Add_Quote_Screen extends StatefulWidget {
  const Add_Quote_Screen({super.key});

  @override
  State<Add_Quote_Screen> createState() => _Add_Quote_ScreenState();
}

class _Add_Quote_ScreenState extends State<Add_Quote_Screen> {
  TextEditingController tquote = TextEditingController();
  TextEditingController tauthor = TextEditingController();

  QuoteController control = Get.put(QuoteController());

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 3.h,
          ),
          CustomTextField(
              hint: "Quote", controller: tquote, kboard: TextInputType.text),
          Obx(
                () => Container(
              height: 8.h,
              width: 100.w,
              alignment: Alignment.center,
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.only(left: 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xff015B8A))),
              child: DropdownButton(
                borderRadius: BorderRadius.circular(10),
                hint: const Text(
                  "Select Category",
                  style: TextStyle(color: Color(0xff015B8A), fontSize: 16),
                ),

                // dropdownColor: Colors.amber,
                isExpanded: true,
                icon: const Icon(Icons.expand_more_rounded),
                underline: Container(),

                value: control.selCategory.value.isEmpty
                    ? null
                    : control.selCategory.value,
                items: control.categoryList
                    .asMap()
                    .entries
                    .map((e) => DropdownMenuItem(
                    value: control.categoryList[e.key]['category'],
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "${control.categoryList[e.key]['category']}",
                      style:
                      const TextStyle(color: Color(0xff015B8A), fontSize: 16),
                    )))
                    .toList(),
                onChanged: (value) {
                  control.selCategory.value = value as String;
                },
              ),
            ),
          ),
          CustomTextField(
              hint: "Author", controller: tauthor, kboard: TextInputType.text),

          GestureDetector(
            onTap: () {
              QuoteModel model = QuoteModel(
                  quote: tquote.text,
                  category: control.selCategory.value,
                  author: tauthor.text,
                  fav: 'No');
              Quote_DB_Helper.quote_db_helper.insertQuote(model);
              control.loadCategoryDB();
              control.selCategory.value="";
              tquote.clear();

              tauthor.clear();
              print("quote list length ==>> ${control.quoteList.length}");
            },
            child: Container(
              height: 60,
              width: 150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: const Color(0xff015B8A),),
              alignment: Alignment.center,
              child: Text(
                "Add Quote",
                style: TextStyle(
                    fontSize: 15.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w400),
              ),
            ),
          ),
          SizedBox(
            height: 3.h,
          ),
        ],
      ),
    );
  }

  Padding CustomTextField({controller, hint, kboard}) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: TextField(
        style: const TextStyle(color: Color(0xff0A1172), fontSize: 16),
        keyboardType: kboard,
        controller: controller,
        decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            label: Text(
              "Enter $hint",
              style: const TextStyle(color: Color(0xff015B8A)),
            ),
            focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Color(0xff015B8A), width: 1.5),
                borderRadius: BorderRadius.circular(10)),
            enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Color(0x55015B8A), width: 1),
                borderRadius: BorderRadius.circular(10)),
            enabled: true),
      ),
    );
  }
}