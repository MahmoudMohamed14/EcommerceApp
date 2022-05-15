class CartModel{

  dynamic? price;
  dynamic? quantity;

  String?id;
  String ?name;
  String ?image;



  CartModel(
      {
        this.price,
        this.quantity=1,

        this.id,
        this.name,
        this.image,
        });

  CartModel.fromJson(Map<String,dynamic>  json){
    id=json['id'];
    price=json['price'];
    quantity =json['quantity'];

    name=json['name'];
    image=json['image'];





  }
  Map<String,dynamic> toMap(){
    return {
      "name":name,
      "price":price,
      "quantity":quantity,

      "id":id,
      "image":image,

    };

  }


}