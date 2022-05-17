class CategoryModel{

  String ?image;
  String?category;
  String ?id;



  CategoryModel(
      {

        this.image,
        this.category,this.id});

  CategoryModel.fromJson(Map<String,dynamic>  json){

    image=json['image'];
    id=json['id'];
    category=json['category'];

  }
  Map<String,dynamic> toMap(){
    return {

      "image":image,
      "category":category,
      "id":id,
    };

  }


}