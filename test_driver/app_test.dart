import 'dart:developer';

import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main(){
  group("filipinno Cooking app main page",()  {
    //upper scroll bar
    final upperSwiperFinder = find.byType("Swiper");

    FlutterDriver flutterDriver;
    
    setUpAll(() async{
      flutterDriver=await FlutterDriver.connect();
    });

    tearDownAll(() async{
      if (flutterDriver!=null){
        flutterDriver.close();
      }

    });
    test("found top swiper", () {

      log(upperSwiperFinder.toString());
    });
    //lover scroll bar
    //fab
    //like button
    //share button
  });
}