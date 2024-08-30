import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/quote_controller.dart';
import 'add_Category_screen.dart';
import 'add_quote_screen.dart';

class Add_Screen extends StatefulWidget {
  const Add_Screen({super.key});

  @override
  State<Add_Screen> createState() => _Add_ScreenState();
}

class _Add_ScreenState extends State<Add_Screen> {


  @override
  void initState() {
    super.initState();
    control.loadCategoryDB();
  }

  QuoteController control = Get.put(QuoteController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: 2,
        initialIndex: 0,

        child: Scaffold(
          appBar: AppBar(
            backgroundColor: const Color(0xff015B8A),
            bottom: const TabBar(
              indicatorColor: Colors.white,
              tabs: [
                Tab(child: Text("Category"),),
                Tab(child: Text("Quote"),),
              ],
            ),
          ),


          body: const TabBarView(
            children: [
              Add_Category_Screen(),
              Add_Quote_Screen()
            ],
          ),

        ),
      ),
    );
  }
}