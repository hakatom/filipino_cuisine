import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group("filipinno Cooking app main page", () {
    final upperSwiperFinder = find.byValueKey("dish swiper");
    final dishPhotoFinder = find.byValueKey("dish Photo");
    final dishNameFinder = find.byValueKey("dish name");
    final dishSpecsFinder = find.byValueKey("dish specs");
    final dishDescriptionFinder = find.byValueKey("dish description");
    final cookButtonFinder = find.byValueKey("cook button");
    final favoriteButtonFinder = find.byValueKey("fav button");
    final favoriteIconFinder = find.byValueKey("favIcon");
    final shareButtonFinder = find.byValueKey("share button");
    final recipeDishNameFinder = find.byValueKey("recipe dish name");
    final ingredientListFinder=find.byValueKey("ingredients");
    final findSharePage = find.byValueKey("share page");

    List fd;
    FlutterDriver flutterDriver;
    int n = 0;

    setUpAll(() async {
      flutterDriver = await FlutterDriver.connect();
      http.Response r = await http
          .get('https://filipino-cuisine-app.firebaseio.com/data.json');
      fd = json.decode(r.body).values.toList();
    });

    tearDownAll(() async {
      if (flutterDriver != null) {
        flutterDriver.close();
      }
    });

    test(
        "correct dish parameters are displayed, and change according to the dish",
        () async {
      expect(await flutterDriver.getText(dishNameFinder), equals(fd[n]['fn']));
      expect(await flutterDriver.getText(dishSpecsFinder), equals(fd[n]['cn']));
      expect(await flutterDriver.getText(dishDescriptionFinder),
          equals(fd[n]['dc']));

      //// an attemot to test the bottom scroll list
      // final firstIngredientNameFinder=find.text(fd[n]['ig'][0]['n']);
      // final lastIngredientNameFinder=find.text(fd[n]['ig'].last['n']);
      //
      // await flutterDriver.scrollUntilVisible(ingredientListFinder, firstIngredientNameFinder);
      // expect(await flutterDriver.getText(firstIngredientNameFinder), fd[n]['ig'][0]['n']);
      // await flutterDriver.scrollUntilVisible(ingredientListFinder, lastIngredientNameFinder,dyScroll: -50);
      // expect(await flutterDriver.getText(firstIngredientNameFinder), fd[n]['ig'].last['n']);


      await sleep(Duration(seconds: 1));
      await flutterDriver.scroll(
          upperSwiperFinder, -300, 0, Duration(seconds: 2));
      await sleep(Duration(seconds: 1));
      n += 1;
      expect(await flutterDriver.getText(dishNameFinder), equals(fd[n]['fn']));
      expect(await flutterDriver.getText(dishSpecsFinder), equals(fd[n]['cn']));
      expect(await flutterDriver.getText(dishDescriptionFinder),
          equals(fd[n]['dc']));
    });


    test("cook menu functionality", () async {
      await flutterDriver.tap(cookButtonFinder);
      expect(await flutterDriver.getText(recipeDishNameFinder),
          equals(fd[n]["fn"]));
      await flutterDriver.tap(find.pageBack());
    });
  });
}

//tests i wanted to preform but couldn't because they required flutter_test.dart
//which causes a dependency error with flutter_driver.dart
//test "correct dish parameters are displayed, and change according to the dish":
// use matchesGoldenFile to check that the correct dish image is displayed as well as the correct inridients list
// favorite button:
//   test the favorite button icon matches the state fetched from the web
//   verity tapping the button changes the icon - couldn't fetch the icon type
// share button:
//    tap the share button and expect to find the share dialog/page

//tests which i could not implement due to the limitation of the flutter_driver:
//  1) launch the app, mark a dish as favorite
//  2) kill the app
//  3) relaunch the app, expect that the dish favorite state is persistent.

//test that i could not implement due to technical difficulty/time constraints -
// test items in list containers are correct -
// EG - ingredients list, recipe list

// integration test plan
// 1) test basic app functionality and fields:
//    the first page dashboard is displayed, the text and images of the correct dish are displayed
//    swiping to the next dish with the swipe changes the dish, the correct value for that dish are displayed
//
// 2) cook button:
//    tapping the coock button prompts the recipe for the dish
//    validate the correct dish value are displayed (dish name, recipe steps)
// 3) favorite button functionality-
//    the favorite button icon matches the dish state
//    tapping the favorite button changes the icon state,
//    after quitting the app and re launching it, the dish favorite state remains as set by user. - state not saved
// 4) share button - button does nothing
//    taping the share button launches the share dialog,
//    sharing to social media/copy paste works.
//5) boundaries check - swipe all scrollable until their end (there is a bug in the swiper)
//6) stress test - launch and exit the apo several times, the app should always start
//7) network failure test-expect a circularProcessIndicator when launching the app without network connectivity