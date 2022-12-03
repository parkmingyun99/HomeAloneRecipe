import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:home_alone_recipe/provider/userProvider.dart';
import 'package:home_alone_recipe/screen/myPost_screen.dart';
import 'package:home_alone_recipe/screen/myScrapRecipe_screen.dart';
import 'package:home_alone_recipe/screen/postGroupBuying_screen.dart';
import 'package:provider/provider.dart';
import 'myTown_screen.dart';

class UserPage extends StatefulWidget {
  const UserPage({Key? key}) : super(key: key);

  @override
  _UserPage createState() => _UserPage();
}

class _UserPage extends State<UserPage> {
  final List<Category> catego = [
    Category(
      imagUrl: "lib/assets/icons/가공유제품/계란.png",
      name: "계란",
    ),
    Category(
      imagUrl: "lib/assets/icons/가공유제품/버터.png",
      name: "버터",
    ),
    Category(
      imagUrl: "lib/assets/icons/가공유제품/어묵.png",
      name: "어묵",
    ),
    Category(
      imagUrl: "lib/assets/icons/육류/닭고기.png",
      name: "닭가슴살",
    ),
  ];
  late UserProvider _userProvider;
  @override
  Widget build(BuildContext context) {
    _userProvider = Provider.of<UserProvider>(context);
    String str = _userProvider.locations.toString();
    str = str.substring(1, str.length - 1);
    str = str.replaceAll(',', ' ');
    return Scaffold(
    //   appBar: AppBar(
    //     title: Text('나의 정보',
    //         style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
    //     centerTitle: true,
    //     elevation: 3.0,
    //     backgroundColor: Colors.white,
    //     automaticallyImplyLeading: false,
    //   ),
    //   body :
    //     Column(
    // children: [
    //   Expanded(
    //     child: Padding(
    //           padding: EdgeInsets.fromLTRB(5, 10, 5, 5),
    //           child: Container(
    //             // height: 120,
    //             // width: 500,
    //             // alignment: Alignment.center,
    //             decoration: BoxDecoration(
    //               color: Colors.black26,
    //               borderRadius: BorderRadius.circular(15),
    //             ),
    //             child: Row(
    //               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //               children: [
    //                 // Padding(padding: EdgeInsets.only(left: 10,)),
    //                 CircleAvatar(
    //                   radius: 35,
    //                   backgroundColor: Colors.white,
    //                   child: Icon(
    //                     Icons.person_outline,
    //                     size: 35,
    //                     color: Colors.black12,
    //                   ),
    //                 ),
    //                 Column(
    //                   mainAxisAlignment: MainAxisAlignment.center,
    //                   children: [
    //                     Text(_userProvider.nickname + ' 님',
    //                         style: TextStyle(
    //                             fontWeight: FontWeight.bold, fontSize: 18)),
    //                     Text(str),
    //                     SizedBox(height: 20),
    //                   ],
    //                 )
    //               ],
    //             ),
    //           ),
    //         ),
    //
    //
    //     flex: 1, //총 flex 합에서 1만큼의 비율을 가져간다.
    //   ),
    //
    //
    //   Expanded( //Expanded 안에 child로 다른걸 넣는다.
    //     child: Container(
    //       child: Padding(
    //         padding: EdgeInsets.fromLTRB(5, 0, 5, 5),
    //         child: Container(
    //           // alignment: Alignment.center,
    //           decoration: BoxDecoration(
    //             color: Colors.black26,
    //             borderRadius: BorderRadius.circular(15),
    //           ),
    //           child: Column(
    //             crossAxisAlignment: CrossAxisAlignment.start,
    //             children: [
    //               SizedBox(
    //                 height: 10,
    //               ),
    //               Text('  나의 활동',
    //                   style: TextStyle(
    //                       fontWeight: FontWeight.bold, fontSize: 20)),
    //               SizedBox(
    //                 height: 20,
    //               ),
    //               Row(
    //                 children: [
    //                   SizedBox(
    //                     width: 10,
    //                   ),
    //                   Icon(Icons.post_add),
    //                   TextButton(
    //                     onPressed: () {
    //                       Navigator.push(
    //                         context,
    //                         MaterialPageRoute(
    //                             builder: (context) => MyPostScreen()),
    //                       );
    //                     },
    //                     child: Text(' 내가 쓴 공동구매글 ',
    //                         style: TextStyle(color: Colors.black)),
    //                   ),
    //                 ],
    //               ),
    //               SizedBox(
    //                 height: 5,
    //               ),
    //               Row(
    //                 children: [
    //                   SizedBox(
    //                     width: 10,
    //                   ),
    //                   Icon(Icons.location_on),
    //                   TextButton(
    //                     onPressed: () {
    //                       Navigator.push(
    //                         context,
    //                         MaterialPageRoute(
    //                             builder: (context) => TownScreen()),
    //                       );
    //                     },
    //                     child: Text(' 내 동네 설정 ',
    //                         style: TextStyle(color: Colors.black)),
    //                   ),
    //                 ],
    //               ),
    //             ],
    //           ),
    //         ),
    //       ),
    //     ),
    //     flex: 2, //총 flex 합에서 2만큼의 비율을 가져간다
    //     ),
    //
    //
    //   Expanded(
    //     child:Container(
    //         child : Padding(
    //         padding: EdgeInsets.fromLTRB(5, 0, 5, 5),
    //         child: Container(
    //
    //           // alignment: Alignment.center,
    //           decoration: BoxDecoration(
    //             color: Colors.black26,
    //             borderRadius: BorderRadius.circular(15),
    //           ),
    //           child: Column(
    //             crossAxisAlignment: CrossAxisAlignment.start,
    //             children: [
    //               SizedBox(
    //                 height: 10,
    //               ),
    //               Text('  나의 레시피',
    //                   style: TextStyle(
    //                       fontWeight: FontWeight.bold, fontSize: 20)
    //               ),
    //               SizedBox(
    //                 height: 10,
    //               ),
    //               Row(
    //                 children: [
    //                   SizedBox(
    //                     width: 10,
    //                   ),
    //                   Icon(Icons.search_rounded),
    //                   TextButton(
    //                     onPressed: () {
    //                       Navigator.push(
    //                         context,
    //                         MaterialPageRoute(
    //                             builder: (context) => MyScrapRecipeScreen()),
    //                       );
    //                     },
    //                     child: Text(' 내가 스크랩한 레시피 보기 ',
    //                         style: TextStyle(color: Colors.black)),
    //                   ),
    //                 ],
    //               ),
    //             ],
    //           ),
    //         ),
    //       ),
    //     ),
    //     flex: 1, //총 flex 합에서 1만큼의 비율을 가져간다.
    //   ),
    //
    //   Expanded(
    //     child:Container(
    //       child : Padding(
    //         padding: EdgeInsets.fromLTRB(5, 0, 5, 5),
    //         child: Container(
    //
    //           // alignment: Alignment.center,
    //           decoration: BoxDecoration(
    //             color: Colors.black26,
    //             borderRadius: BorderRadius.circular(15),
    //           ),
    //           child: Column(
    //             crossAxisAlignment: CrossAxisAlignment.start,
    //             children: [
    //               SizedBox(
    //                 height: 10,
    //               ),
    //               Text('  오늘의 추천 레시피',
    //                   style: TextStyle(
    //                       fontWeight: FontWeight.bold, fontSize: 20)),
    //               SizedBox(
    //                 height: 20,
    //               ),
    //               Row(
    //                 children: [
    //                   Row(
    //                     children: [
    //                       SizedBox(
    //                         width: 10,
    //                       ),
    //                       Icon(Icons.headphones_outlined),
    //                       TextButton(
    //                         onPressed: () {
    //
    //                         },
    //                         child: Text(' 자주 묻는 질문 ',
    //                             style: TextStyle(color: Colors.black)),
    //                       ),
    //                     ],
    //                   ),
    //                   SizedBox(
    //                     height: 5,
    //                   ),
    //
    //
    //
    //                 ],
    //               ),
    //               Row(
    //                 children: [
    //                   Row(
    //                     children: [
    //                       SizedBox(
    //                         width: 10,
    //                       ),
    //                       Icon(Icons.mail_outline_rounded),
    //                       TextButton(
    //                         onPressed: () {
    //
    //                         },
    //                         child: Text(' 친구 초대 ',
    //                             style: TextStyle(color: Colors.black)),
    //                       ),
    //                     ],
    //                   ),
    //                   SizedBox(
    //                     height: 5,
    //                   ),
    //
    //
    //
    //                 ],
    //               ),
    //             ],
    //           ),
    //         ),
    //       ),
    //     ),
    //     flex: 2, //총 flex 합에서 1만큼의 비율을 가져간다.
    //   ),
    // ],
    // ),
    //

        appBar: AppBar(
            title: Text('나의 정보',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            centerTitle: true,
            elevation: 3.0,
            backgroundColor: Colors.white,
            automaticallyImplyLeading: false,
          ),

      body :
          Column(
      children: [

          Expanded(
            child: Padding(
                  padding: EdgeInsets.fromLTRB(5, 10, 5, 5),
                  child: Container(
                    // height: 120,
                    // width: 500,
                    // alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.black26,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Padding(padding: EdgeInsets.only(left: 10,)),
                        CircleAvatar(
                          radius: 35,
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.person_outline,
                            size: 35,
                            color: Colors.black12,
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(_userProvider.nickname + ' 님',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18)),
                            Text(str),
                            SizedBox(height: 20),
                          ],
                        )
                      ],
                    ),
                  ),
                ),


            flex: 1, //총 flex 합에서 1만큼의 비율을 가져간다.
          ),


          // 2번째 박스!
          SizedBox(
            height: 5.0,
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: EdgeInsets.fromLTRB(5, 0, 5, 5),
              child: Container(
                // alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Text('  나의 활동',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20)),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 10,
                        ),
                        Icon(Icons.post_add),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MyPostScreen()),
                            );
                          },
                          child: Text(' 내가 쓴 공동구매글 ',
                              style: TextStyle(color: Colors.black)),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 10,
                        ),
                        Icon(Icons.location_on),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => TownScreen()),
                            );
                          },
                          child: Text(' 내 동네 설정 ',
                              style: TextStyle(color: Colors.black)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          // 3번째 박스!!
          SizedBox(
            height: 5.0,
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: EdgeInsets.fromLTRB(5, 0, 5, 5),
              child: Container(
                height: 100,
                width: 500,
                // alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Text('  나의 레시피',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20)),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 10,
                        ),
                        Icon(Icons.search_rounded),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MyScrapRecipeScreen()),
                            );
                          },
                          child: Text(' 내가 스크랩한 레시피 보기 ',
                              style: TextStyle(color: Colors.black)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10.0,
          ),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('   오늘의 추천 재료',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              SizedBox(
                height: 10,
              ),
            ],
          ),
          //
          Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Container(
                  width: double.infinity,
                  height: 200,
                  child: ListView.builder(
                      itemCount: catego.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (BuildContext context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Column(
                            children: [
                              Container(
                                height: 172,
                                width: 132,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(catego[index].imagUrl),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                catego[index].name,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                ),
              )), //
        ],
      ),
    );
  }
}

class Category {
  final String imagUrl;
  final String name;

  Category({required this.imagUrl, required this.name});
}
