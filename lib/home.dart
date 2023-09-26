import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:food_recipe_app/Search.dart';
import 'package:food_recipe_app/models.dart';
import 'package:food_recipe_app/RecipeView.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isLoading = true;
  List<RecipeModel> recipeList = <RecipeModel>[];
  TextEditingController searchController = new TextEditingController();
  List reciptCatList = [
    {
      "imgUrl": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ2s2Y5CJo8efJzKpwA1qoqD3fgIC18t_YrqA&usqp=CAU",
      "heading": "Sweets"
    },
    {
      "imgUrl": "https://images.unsplash.com/photo-1593560704563-f176a2eb61db",
      "heading": "Chilli Food"
    },
    {
      "imgUrl": "https://thumbs.dreamstime.com/b/breakfast-bacon-eggs-pancakes-toast-delicous-home-style-crispy-coffee-orange-juice-49174170.jpg",
      "heading": "Breakfast"
    },
    {
      "imgUrl": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSknCgFCqBlpSdAjPeUU1FMNKX_KZHW4dMMuaILHPjSWA&s",
      "heading": "Starter"
    }
  ];
  
  getRecipe(String query) async {
    String url =
        "https://api.edamam.com/search?q=$query&app_id=4126f6be&app_key=febd6fa8c57c6b93c11c4701b279c402";
    http.Response response = await http.get(Uri.parse(url));
    Map data = jsonDecode(response.body);
    log(data.toString());
    setState(() {
      data["hits"].forEach((element) {
        RecipeModel recipeModel = new RecipeModel();
        recipeModel = RecipeModel.fromMap(element["recipe"]);
        recipeList.add(recipeModel);
        setState(() {
          isLoading = false;
        });
        log(recipeList.toString());
      });
    });
    recipeList.forEach((Recipe) {
      print(Recipe.appLabel);
      print(Recipe.appcalories);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getRecipe("Paneer");
  }

  @override
  Widget build(BuildContext context) {
   return Scaffold(
      body: Stack(
        children: [
          // Container(
          //   width: MediaQuery.of(context).size.width,
          //   height: MediaQuery.of(context).size.height,
          //   decoration: BoxDecoration(
          //       gradient: LinearGradient(colors: [
          //     Color(0xff213A50),
          //     Color(0xff071938),
          //   ])),
          // ),
          SingleChildScrollView(
            child: Column(
              children: [
                SafeArea(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    margin: EdgeInsets.symmetric(horizontal: 24, vertical: 15),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24)),
                    child: Row(
                      children: [
                        Container(
                          child: Icon(
                            Icons.search,
                            color: Colors.blueAccent,
                          ),
                          margin: EdgeInsets.fromLTRB(3, 0, 7, 0),
                        ),
                        Expanded(
                          child: TextField(
                            textInputAction: TextInputAction.done,
                            onSubmitted: (value){
                              if ((searchController.text).replaceAll(" ", "") ==
                                  "") {
                                print("Blank search");
                              } else {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            Search(searchController.text)));
                              }
                            },
                            controller: searchController,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Let's Cook Something!"),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "WHAT DO YOU WANT TO COOK TODAY?",
                        style: TextStyle(fontSize: 33, color: Colors.black),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Let's Cook Something New!",
                        style: TextStyle(fontSize: 20.0, color: Colors.black),
                      ),
                    ],
                  ),
                ),
                Container(
                  child: isLoading
                      ? CircularProgressIndicator()
                      : ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: recipeList.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => RecipeView(
                                            recipeList[index].appurl)));
                              },
                              child: Card(
                                margin: EdgeInsets.all(20.0),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0)),
                                elevation: 0.0,
                                child: Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10.0),
                                      child: Image.network(
                                        recipeList[index].appImgUrl,
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                        height: 200.0,
                                      ),
                                    ),
                                    Positioned(
                                        left: 0,
                                        right: 0,
                                        bottom: 0,
                                        child: Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 5, horizontal: 10),
                                            decoration: BoxDecoration(
                                                color: Colors.black26),
                                            child: Text(
                                              recipeList[index].appLabel,
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ))),
                                    Positioned(
                                      right: 0,
                                      height: 40,
                                      width: 80,
                                      child: Container(
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.only(
                                                  topRight: Radius.circular(10),
                                                  bottomLeft:
                                                      Radius.circular(10))),
                                          child: Center(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.local_fire_department,
                                                  size: 15,
                                                ),
                                                Text(recipeList[index]
                                                    .appcalories
                                                    .toString()
                                                    .substring(0, 6)),
                                              ],
                                            ),
                                          )),
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
                Container(
                  height: 100,
                  child: ListView.builder(
                      itemCount: reciptCatList.length,
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return Container(
                            child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Search(
                                        reciptCatList[index]["heading"])));
                          },
                          child: Card(
                              margin: EdgeInsets.all(20),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                              elevation: 0.0,
                              child: Stack(
                                children: [
                                  ClipRRect(
                                      borderRadius: BorderRadius.circular(18.0),
                                      child: Image.network(
                                        reciptCatList[index]["imgUrl"],
                                        fit: BoxFit.cover,
                                        width: 200,
                                        height: 250,
                                      )),
                                  Positioned(
                                      left: 0,
                                      right: 0,
                                      bottom: 0,
                                      top: 0,
                                      child: Container(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 5, horizontal: 10),
                                          decoration: BoxDecoration(
                                              color: Colors.black26),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                reciptCatList[index]["heading"],
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 28),
                                              ),
                                            ],
                                          ))),
                                ],
                              )),
                        ));
                      }),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

