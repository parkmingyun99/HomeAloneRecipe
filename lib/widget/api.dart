import 'dart:convert' as convert;

import 'package:home_alone_recipe/constants/ingredientCategory.dart' as ingr;
import 'dart:ffi' as ffi;
import 'package:flutter/services.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:home_alone_recipe/provider/userProvider.dart';
import 'package:home_alone_recipe/widget/ingredient_button.dart';
import 'package:xml/xml.dart';
import 'package:xml2json/xml2json.dart';
import 'package:http/http.dart' as http;
import 'package:home_alone_recipe/widget/getRecipe.dart';
import 'package:home_alone_recipe/models/recipe.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'category_dropdown.dart';
import 'package:home_alone_recipe/screen/recipeDetail_screen.dart';
import 'ingredient_filter.dart';
import 'package:provider/provider.dart';
import 'package:home_alone_recipe/config/palette.dart';

Map<String, dynamic> ingMap = {
  "소고기": ["쇠고기"],
  "닭고기": ["닭", "닭다리"],
};

class Api extends StatefulWidget {
  final apiResults;

  const Api(this.apiResults, {super.key});

  @override
  State<Api> createState() => _ApiState();
}

class _ApiState extends State<Api> {
  bool showWidget = false;
  List<String> ingredientArr = [];
  FirebaseFirestore db = FirebaseFirestore.instance;

  bool isScrapped = false;

  void addIng(String ing) {
    setState(() {
      if (!ingredientArr.contains(ing)) ingredientArr.add(ing);

      print(ingredientArr);
    });
  }

  void rmvIng(String ing) {
    print("rmvIng");
    print(ingMap[ing]);
    //var length = ingMap[ing].length;

    setState(() {
      ingredientArr.remove(ing);
      print("before for)");
      for (var i = 0; i < 1; i++) {
        //ingredientArr.remove(ingMap[ing][i]);
        //print(ingMap[ing][i]);
      }
      //ingredientArr.clear();
      print(ingredientArr);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: <Widget>[
          IngredientFilter(addIng, rmvIng),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              for (var i = 0; i < ingredientArr.length; i++)
                Container(
                    margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
                    decoration: BoxDecoration(
                        color: Palette.blue,
                        borderRadius: BorderRadius.circular(10)),
                    padding: EdgeInsets.fromLTRB(5, 1, 5, 1),
                    height: 30,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          ingredientArr[i],
                          style: TextStyle(color: Colors.white),
                        ),
                        IconButton(
                          constraints: BoxConstraints(),
                          padding: EdgeInsets.fromLTRB(10.0, 0, 0, 0),
                          onPressed: () {
                            rmvIng(ingredientArr[i]);
                          },
                          icon: Icon(
                            Icons.cancel,
                            size: 20.0,
                          ),
                          color: Colors.white,
                        )
                      ],
                    ))
            ]),
          ),
          Expanded(child: ListBuilder(ingredientArr)),
        ],
      ),
    );
  }
}

class ListBuilder extends StatefulWidget {
  final List<String> filterIngredient;

  const ListBuilder(this.filterIngredient, {super.key});

  @override
  State<ListBuilder> createState() => _ListBuilderState();
}

class _ListBuilderState extends State<ListBuilder> {
  late UserProvider _userProvider;
  Map<String, dynamic> ing = ingr.ing;

  FirebaseFirestore db = FirebaseFirestore.instance;

  Future<bool> hasData(int recipeCode) async {
    var data =
        await db.collection("recipeScrap").doc(recipeCode.toString()).get();
    return data.exists;
  }

  Future initRecipeScrap(int recipeCodeNum) async {
    var isEmpty = await hasData(recipeCodeNum);
    if (!isEmpty) {
      db
          .collection("recipeScrap")
          .doc(recipeCodeNum.toString())
          .set({"scrapNum": 0}, SetOptions(merge: true));
      print("init data");
    } else {
      print("already exist");
    }
  }

  Future<int> getScrapNum(int recipeCodeNum) async {
    var data =
        await db.collection("recipeScrap").doc(recipeCodeNum.toString()).get();
    print("Get Scrap Num in API");
    return data.data()!["scrapNum"];
  }

  Future<List<int>> _getIngAPIbyIngName(List<String> recipeName) async {
    List<int> ingResult = [];
    List<int> doubleIng = [];
    List<String> recipeAllName = [];
    for (var i = 0; i < recipeName.length; i++) {
      recipeAllName.add(recipeName[i]);
    }

    int duplicate = 0;
    for (var i = 0; i < recipeName.length; i++) {
      print(ing);
      print("recipeName");
      print(recipeName);
      if (ing[recipeName[i]] != null) {
        for (var j = 0; j < ing[recipeName[i]].length; j++) {
          recipeAllName.add(ing[recipeName[i]][j]);
          duplicate += 1;
          print("dup recipeName");
          print(recipeName);
        }
      }
    }
    print("recipeAllName");

    print(recipeAllName);
    for (var idx = 0; idx < recipeAllName.length; idx++) {
      final response = await http.get(Uri.parse(
          'http://211.237.50.150:7080/openapi/a0e05d197e3886ea191fa4f206b3b99dfc004411423b5e5187361ae7e6e651cd/xml/Grid_20150827000000000227_1/1/100?IRDNT_NM=${recipeAllName[idx]}'));

      if (response.statusCode == 200) {
        final body = convert.utf8.decode(response.bodyBytes);

        // xml => json으로 변환
        final xml = Xml2Json()..parse(body);
        final json = xml.toParker();

        Map<String, dynamic> jsonResult = convert.json.decode(json);

        //데이터를 1개가져올때 예외처리

        if (jsonResult['Grid_20150827000000000227_1']['row'].toString().length <
            150) {
          ingResult.add(int.parse(
              jsonResult['Grid_20150827000000000227_1']['row']['RECIPE_ID']));
        } else if (jsonResult['Grid_20150827000000000227_1']['row']
                .toString()
                .length >=
            150) {
          print(1);
          for (var i = 0;
              i < jsonResult['Grid_20150827000000000227_1']['row'].length;
              i++) {
            ingResult.add(int.parse(jsonResult['Grid_20150827000000000227_1']
                ['row'][i]['RECIPE_ID']));
          }
        }
      } else {
        throw Exception('오류');
      }
    }
    print("추가 되지 않은 배열");
    print(recipeName);
    ingResult.sort();
    print(ingResult);
    if (recipeName.length > 1) {
      int upFlag = 0;
      bool downFlag = false;
      for (var i = 0; i < ingResult.length - 1; i++) {
        if (ingResult[i] == ingResult[i + 1]) {
          upFlag += 1;
          if (upFlag == recipeName.length - 1) {
            doubleIng.add(ingResult[i]);
          }
        } else if (ingResult[i] != ingResult[i + 1]) {
          upFlag = 0;
        }
      }
      print(doubleIng);
      return doubleIng;
    } else {
      var setResult = ingResult.toSet();
      print("set");
      print(setResult);
      var toListResult = setResult.toList();
      return toListResult;
    }
  }

  Future<List<String>> _getIngAPI(String recipeCode) async {
    final response = await http.get(Uri.parse(
        'http://211.237.50.150:7080/openapi/a0e05d197e3886ea191fa4f206b3b99dfc004411423b5e5187361ae7e6e651cd/xml/Grid_20150827000000000227_1/1/100?RECIPE_ID=${recipeCode}'));
    List<String> ingResult = [];
    if (response.statusCode == 200) {
      final body = convert.utf8.decode(response.bodyBytes);

      // xml => json으로 변환
      final xml = Xml2Json()..parse(body);
      final json = xml.toParker();

      Map<String, dynamic> jsonResult = convert.json.decode(json);

      for (var i = 0;
          i < jsonResult['Grid_20150827000000000227_1']['row'].length;
          i++) {
        ingResult.add(
            jsonResult['Grid_20150827000000000227_1']['row'][i]['IRDNT_NM']);
      }
    } else {
      throw Exception('오류');
    }

    return ingResult;
  }

  Future<List<String>> _getRecipeAPI(String recipeCode) async {
    final response = await http.get(Uri.parse(
        'http://211.237.50.150:7080/openapi/a0e05d197e3886ea191fa4f206b3b99dfc004411423b5e5187361ae7e6e651cd/xml/Grid_20150827000000000228_1/1/10?RECIPE_ID=${recipeCode}'));
    List<String> ingResult = [];

    if (response.statusCode == 200) {
      final body = convert.utf8.decode(response.bodyBytes);

      // xml => json으로 변환
      final xml = Xml2Json()..parse(body);
      final json = xml.toParker();

      Map<String, dynamic> jsonResult = convert.json.decode(json);

      for (var i = 0;
          i < jsonResult['Grid_20150827000000000228_1']['row'].length;
          i++) {
        ingResult.add(
            jsonResult['Grid_20150827000000000228_1']['row'][i]['COOKING_DC']);
      }
    } else {
      throw Exception('오류');
    }

    return ingResult;
  }

  Future<List<dynamic>> readJson() async {
    List<dynamic> _items = [];
    final String response =
        await rootBundle.loadString('lib/assets/recipeInfo.json');

    final data = await convert.json.decode(response);

    _items = await data["recipe"];
    print("read json");

    return _items;
  }

  Future<List<Recipe>> _MakeRecipeArray(
      List<dynamic> recipeInfo, List<dynamic> recipeMake) async {
    List<Recipe> _recipe = [];

    for (var i = 0; i < recipeMake.length; i++) {
      //print("레시피설명 불러오는중");
      await initRecipeScrap(recipeInfo[i]);
      int scrapNum = await getScrapNum(recipeInfo[i]);
      List<String> _recipeIng = await _getIngAPI(recipeInfo[i].toString());
      List<String> _recipeMake = await _getRecipeAPI(recipeInfo[i].toString());

      _recipe.add(Recipe(
          recipeMake[i]['레시피 이름'],
          recipeMake[i]['대표이미지 URL'],
          recipeInfo[i],
          recipeMake[i]['간략(요약) 소개'],
          _recipeIng,
          _recipeMake,
          scrapNum));
    }

    return await _recipe;
  }

  Future<List<Recipe>> _getFiteredRecipe() async {
    print(widget.filterIngredient);
    if (widget.filterIngredient != "") {
      final List<int> filteredRecipecode =
          await _getIngAPIbyIngName(widget.filterIngredient);

      final List<dynamic> filteredRecipeArray = [];

      List<dynamic> allRecipes = await readJson();
      print(allRecipes);
      print(filteredRecipecode);
      for (var i = allRecipes.length - 1; i >= 0; i--) {
        for (var j = filteredRecipecode.length - 1; j >= 0; j--) {
          if (allRecipes[i]["레시피 코드"] == filteredRecipecode[j]) {
            filteredRecipeArray.add(allRecipes[i]);
            print("filtered");
          }
        }
      }
      print(filteredRecipeArray);
      print(filteredRecipecode);
      return await _MakeRecipeArray(filteredRecipecode, filteredRecipeArray);
    } else {
      List<Recipe> emptyArr = [];
      return emptyArr;
    }
  }

  bool isScrap = true;

  @override
  Widget build(BuildContext context) {
    _userProvider = Provider.of<UserProvider>(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return FutureBuilder(
        future: _getFiteredRecipe(),
        builder: ((BuildContext context, AsyncSnapshot<List<Recipe>> snapshot) {
          List<Recipe> snapRecipe = [];

          print(snapshot);
          if (snapshot.hasData) {
            snapshot.data!.forEach((element) {
              Recipe r = element as Recipe;
              snapRecipe.add(r);
              print("Recipe Snap For");
            });
          }

          if (snapshot.connectionState == ConnectionState.done) {
            return Column(
              children: [
                (snapRecipe.length >= 1)
                    ? Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Text('총${snapRecipe.length}개의 레시피가 나왔어요!'),
                      )
                    : Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Text('만족하는 레시피가 없습니다.'),
                      ),
                Padding(
                  padding: const EdgeInsets.only(
                      bottom: 15, top: 10),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(1),
                          spreadRadius: 0,
                          blurRadius: 2,
                          offset: Offset(0,
                              2), // changes position of shadow
                        ),
                      ],
                    ),
                    height: 1.0,
                    width: 500.0,
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                      itemCount: snapRecipe.length,
                      itemBuilder: (BuildContext context, int idx) {
                        return Container(
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left:10.0),
                                      child: Container(
                                        width: 110.0,
                                        height: 110.0,
                                        child: Image.network(
                                          snapRecipe[idx].imageURL,
                                          fit: BoxFit.cover,
                                          width:
                                              MediaQuery.of(context).size.width,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 20, top: 0),
                                      child: Container(
                                        height: 110,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Align(
                                              alignment: Alignment.bottomLeft,
                                              child: Container(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      '${snapRecipe[idx].recipeName}',
                                                      style: TextStyle(
                                                          fontSize: 18.0,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                      textAlign: TextAlign.left,
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .fromLTRB(0, 7, 0, 0),
                                                      child: Container(
                                                          width: screenWidth *
                                                              0.6,
                                                          child: Text(
                                                              snapRecipe[idx]
                                                                  .description,
                                                              maxLines: 2,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: TextStyle(
                                                                  fontSize: 16,
                                                                  color: Colors
                                                                      .black54),
                                                              textAlign:
                                                                  TextAlign
                                                                      .start)),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Container(
                                              width:screenWidth*0.55,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.only(top:15.0),
                                                child: Row(

                                                  children: [
                                                    Container(
                                                      width: 30,
                                                      child: IconButton(
                                                        padding:
                                                            EdgeInsets.zero,
                                                        constraints:
                                                            BoxConstraints(),
                                                        icon: _userProvider
                                                                .recipes
                                                                .contains(
                                                                    snapRecipe[
                                                                            idx]
                                                                        .recipeCode)
                                                            ? Icon(
                                                                Icons.favorite,
                                                                color: Colors
                                                                    .yellow,
                                                              )
                                                            : Icon(
                                                                Icons
                                                                    .favorite_border,
                                                                color: Colors
                                                                    .yellow),
                                                        focusColor:
                                                            Colors.amber,
                                                        isSelected: false,
                                                        selectedIcon: Icon(Icons
                                                            .favorite_border),
                                                        onPressed: () {},
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .fromLTRB(
                                                          0, 0, 10, 0),
                                                      child: Text(
                                                          '${snapRecipe[idx].scrapped}'),
                                                    ),
                                                    ConstrainedBox(
                                                      constraints:
                                                          BoxConstraints
                                                              .tightFor(
                                                                  height: 25),
                                                      child: Padding(
                                                        padding: const EdgeInsets.only(left:30.0),
                                                        child: ElevatedButton(
                                                          onPressed: () {
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder: (context) =>
                                                                        RecipeDetailPage(
                                                                            snapRecipe[
                                                                                idx])));
                                                          },
                                                          child: Text('자세히 보기 >'),
                                                          style: ElevatedButton.styleFrom(
                                                              padding: EdgeInsets
                                                                  .fromLTRB(
                                                                      3, 3, 3, 3),
                                                              backgroundColor:
                                                                  Colors
                                                                      .transparent,
                                                              shadowColor: Colors
                                                                  .transparent),
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 15, top: 15),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.grey,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(1),
                                          spreadRadius: 0,
                                          blurRadius: 2,
                                          offset: Offset(0,
                                              2), // changes position of shadow
                                        ),
                                      ],
                                    ),
                                    height: 1.0,
                                    width: 500.0,
                                  ),
                                ),
                              ],
                            ));
                      }),
                )
              ],
            );
          }
          return const Center(child: CircularProgressIndicator());
        }));
  }
}
