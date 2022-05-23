class CartModel{

  dynamic price;
  dynamic quantity;
  String?id;
  String ?name;
  String ?image;
  String ?adminId;



  CartModel(
      {
        this.price,
        this.quantity=1,
        this.adminId,
        this.id,
        this.name,
        this.image,
        });

  CartModel.fromJson(Map<String,dynamic>  json){
    id=json['id'];
    price=json['price'];
    quantity =json['quantity'];
    adminId=json['adminId'];
    name=json['name'];
    image=json['image'];
  }
  Map<String,dynamic> toMap(){
    return {
      "name":name,
      "price":price,
      "quantity":quantity,
      "adminId":adminId,
      "id":id,
      "image":image,

    };

  }

}