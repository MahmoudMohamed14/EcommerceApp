class ProductModel{

  dynamic? price;
 dynamic? old_Price;

  String?id;
  String ?name;
  String ?image;
  String?category;
  String?description;
  String ?adminId;



  ProductModel(
      {
        this.price,
        this.old_Price=0.0,
        this.description,
        this.id='',
        this.name,
        this.image,
        this.adminId,
        this.category});

  ProductModel.fromJson(Map<String,dynamic>  json){
    id=json['id'];
    price=json['price'];
    old_Price =json['old_Price'];
description=json['description'];
    name=json['name'];
    image=json['image'];
    category=json['category'];
    adminId=json['adminId'];




  }
  Map<String,dynamic> toMap(){
    return {
      "name":name,
      "price":price,
      "old_Price":old_Price,
      "description":description,
      "id":id,
     "image":image,
      "category":category,
      "adminId":adminId,
    };

    }


}