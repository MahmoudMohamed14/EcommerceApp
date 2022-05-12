class CategoryModel{

  String ?image;
  String?category;



  CategoryModel(
      {

        this.image,
        this.category});

  CategoryModel.fromJson(Map<String,dynamic>  json){

    image=json['image'];
    category=json['category'];

  }
  Map<String,dynamic> toMap(){
    return {

      "image":image,
      "category":category
    };

  }


}