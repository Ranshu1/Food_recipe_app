class RecipeModel {
  late String appLabel;
  late String appImgUrl;
  late double appcalories;
  late String appurl;

  RecipeModel(
      {this.appLabel = "Label",
      this.appImgUrl = "IMAGE",
      this.appcalories = 0.000,
      this.appurl = "URL",
      });
      factory RecipeModel.fromMap(Map recipe){
        return RecipeModel(
          appLabel: recipe["label"],
          appcalories: recipe["calories"],
          appImgUrl: recipe["image"],
          appurl: recipe["url"],
        );
      }
}
