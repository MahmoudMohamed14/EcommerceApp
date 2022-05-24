

class UsersModel{
  String? name;
  String? email;
  String?phone;

  String? id;
  String? password;
  bool ?isAdmin;
  bool?requestAdmin;

  UsersModel({this.name, this.email,this.id, this.password,this.isAdmin,this.phone,this.requestAdmin});
  UsersModel.fromJson({required Map<String,dynamic> json}){
    name=json['name'];
    email=json['email'];
    password=json['password'];
    id=json['id'];
    isAdmin=json['isAdmin'];
    phone=json['phone'];
    requestAdmin=json['requestAdmin'];
  }

  Map<String,dynamic> toMap(){
    return{
      'name':name,
      'email':email,
      'password':password,
      'id':id,
      'isAdmin':isAdmin,
      'phone':phone,
      'requestAdmin':requestAdmin

    };
  }
}