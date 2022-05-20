import 'package:projectgraduate/models/cart_model.dart';

class OrderModel{

  dynamic totalPrice;
  List<dynamic>? orderProducts;
  List<CartModel>?lisCartModel;
  String?customerId;
  String?orderId;
  String ?customerName;
  String ?customerPhone;
  String ?customerTitle;
  String?customerNote;
  String ?date;
  String?time;
  String?orderState;


  OrderModel(
      {this.totalPrice,
      this.orderProducts,
        this.orderId,
      this.customerId,
      this.customerName,
      this.customerPhone,
      this.customerTitle,
      this.customerNote='',
      this.date,
      this.time,
      this.orderState='Pending'});

  OrderModel.fromJson(Map<String,dynamic>  json){
    totalPrice=json['totalPrice'];
    orderProducts=json['orderProducts'];
    orderState =json['orderState'];
    orderId =json['orderId'];
    customerId=json['customerId'];
    customerName=json['customerName'];
    customerPhone=json['customerPhone'];
    customerTitle=json['customerTitle'];
    customerNote=json['customerNote'];
    date=json['date'];
    time=json['time'];






  }
  Map<String,dynamic> toMap(){
    return {
      "totalPrice":totalPrice,
      "orderProducts":orderProducts,
      "orderId": orderId,
      "orderState":orderState,
      "customerId":customerId,
      "customerName":customerName,
      "customerPhone":customerPhone,
      "customerTitle":customerTitle,
      "customerNote":customerNote,
      "date":date,
      "time":time
    };

  }


}