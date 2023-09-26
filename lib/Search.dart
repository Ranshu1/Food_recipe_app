import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:food_recipe_app/RecipeView.dart';
import 'package:food_recipe_app/models.dart';
import 'package:http/http.dart' as http;

class Search extends StatefulWidget {
  String query;
  Search(this.query);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  bool isLoading = true;
  List<RecipeModel> recipeList = <RecipeModel>[];
  TextEditingController searchController = new TextEditingController();

  getRecipes(String query) async {
    String url =
        "https://api.edamam.com/search?q=$query&app_id=ebb6041c&app_key=3c33ad913ab23b8554082bfb5fdd78b5";
    http.Response response = await http.get(Uri.parse(url));
    Map data = jsonDecode(response.body);

    setState(() {
      data["hits"].forEach((element) {
        RecipeModel recipeModel = RecipeModel.fromMap(element["recipe"]);
        recipeList.add(recipeModel);
        isLoading = false;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getRecipes(widget.query);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Search Results"),
        backgroundColor: Color(0xFF071938),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              textInputAction: TextInputAction.done,
              onSubmitted: (value){
                setState(() {
                      isLoading = true;
                      recipeList.clear();
                    });
                    getRecipes(searchController.text);
              },
              controller: searchController,
              decoration: InputDecoration(
                hintText: "Search for recipes...",
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                  },
                ),
              ),
            ),
          ),
          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: recipeList.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  RecipeView(recipeList[index].appurl),
                            ),
                          );
                        },
                        child: Card(
                          margin: EdgeInsets.all(20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 0.0,
                          child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10.0),
                                child: Image.network(
                                  recipeList[index].appImgUrl,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: 200,
                                ),
                              ),
                              Positioned(
                                left: 0,
                                right: 0,
                                bottom: 0,
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    vertical: 5,
                                    horizontal: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.black26,
                                  ),
                                  child: Text(
                                    recipeList[index].appLabel,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                right: 0,
                                height: 40,
                                width: 80,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(10),
                                      bottomLeft: Radius.circular(10),
                                    ),
                                  ),
                                  child: Center(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.local_fire_department,
                                          size: 15,
                                        ),
                                        Text(
                                          recipeList[index]
                                                      .appcalories !=
                                                  null
                                              ? recipeList[index]
                                                  .appcalories
                                                  .toString()
                                                  .substring(0, 6)
                                              : "",
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
