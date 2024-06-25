import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import '../../controller/quote_controller.dart';
import '../../utils/quote_db_helper.dart';

class Add_Category_Screen extends StatefulWidget {
  const Add_Category_Screen({super.key});

  @override
  State<Add_Category_Screen> createState() => _Add_Category_ScreenState();
}

class _Add_Category_ScreenState extends State<Add_Category_Screen> {

  TextEditingController tcategory = TextEditingController();

  QuoteController control = Get.put(QuoteController());


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 3.h,),
        CustomTextField(hint: "Category",controller: tcategory,kboard: TextInputType.text),
        SizedBox(height: 1.5.h,),
        GestureDetector(
          onTap: () {

            Quote_DB_Helper.quote_db_helper.insertCategory(tcategory.text);
            control.loadCategoryDB();
            tcategory.clear();
          },
          child: Container(height: 60,width: 150,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(30),color: const Color(0xff015B8A),),
            alignment: Alignment.center,
            child: Text("Add Category",style: TextStyle(fontSize: 15.sp,color: Colors.white,fontWeight: FontWeight.w400),),
          ),
        ),
        SizedBox(height: 3.h,),
        control.categoryList != null
            ? Expanded(
          child: Obx(
                () =>  ListView.builder(
              itemCount: control.categoryList.length,
              itemBuilder: (context, index) {

                return Padding(
                  padding:  const EdgeInsets.symmetric(horizontal: 5,vertical: 4),
                  child: GestureDetector(
                    onTap: () {
                      tcategory.text = control.categoryList[index]['category'];

                      Get.defaultDialog(title: "Update Category",content: Column(
                        children: [
                          SizedBox(height: 1.5.h,),
                          CustomTextField(hint: "Category",kboard: TextInputType.text,controller: tcategory),
                          SizedBox(height: 2.h,),
                          Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              IconButton(onPressed: () async {

                                Quote_DB_Helper.quote_db_helper.deleteInCategoryTABLE(control.categoryList[index]['id']);
                                control.loadCategoryDB();
                                Get.back();

                              }, icon: const Icon(Icons.delete_outline_rounded),iconSize: 30.sp,color: Colors.red,),


                              IconButton(onPressed: () async {



                                await Quote_DB_Helper.quote_db_helper.updateInCategoryTABLE(
                                  id: control.categoryList[index]['id'],
                                  category: tcategory.text,
                                  // list: control.quoteList
                                );

                                control.loadCategoryDB();
                                tcategory.clear();
                                Get.back();

                              }, icon: const Icon(Icons.check),iconSize: 30.sp,color: Colors.green,)
                            ],
                          )
                        ],
                      ));

                    },
                    child: Container(height: 60,width: 100.w,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(3.w),color: Color(0x99015B8A),),
                      child: Row(children: [
                        SizedBox(width: 10,),
                        Text("${index + 1}",style: TextStyle(fontSize: 16.sp,fontWeight: FontWeight.w600,color: Colors.white),),
                        const SizedBox(width: 15,),
                        Text("${control.categoryList[index]['category']}",style: TextStyle(fontSize: 16.sp,fontWeight: FontWeight.w600,color: Colors.white),),
                      ],),

                    ),
                  ),
                );

              },),
          ),
        )
            : Container(),



      ],
    );
  }



}

Padding CustomTextField({controller,hint,kboard}) {
  return Padding(
    padding:  const EdgeInsets.all(10),
    child: TextField(
      style: const TextStyle(color: Color(0xff015B8A),fontSize: 16),
      keyboardType: kboard,
      controller: controller,
      decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          label: Text("Enter $hint",style: const TextStyle(color: Color(0xff015B8A)),),
          focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: Color(0xff015B8A),width: 1.5),borderRadius: BorderRadius.circular(10)),
          enabledBorder: OutlineInputBorder(borderSide: const BorderSide(color: Color(0x550A1172),width: 1),borderRadius: BorderRadius.circular(10)),
          enabled: true

      ),
    ),
  );
}
