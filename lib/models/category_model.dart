class CategoryModel{

  String ?image;
  String?category;
  String ?id;
  String ?adminId;



  CategoryModel(
      {

        this.image,
        this.category,this.id
        ,this.adminId
      });

  CategoryModel.fromJson(Map<String,dynamic>  json){

    image=json['image'];
    id=json['id'];
    category=json['category'];
    adminId=json['adminId'];

  }
  Map<String,dynamic> toMap(){
    return {

      "image":image,
      "category":category,
      "id":id,
      "adminId":adminId,
    };

  }


}