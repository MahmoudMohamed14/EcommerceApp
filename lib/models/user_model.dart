

class UsersModel{
  String? name;
  String? email;
  String?phone;

  String? id;
  String? password;

  bool ?isAdmin;

  UsersModel({this.name, this.email,this.id, this.password,this.isAdmin,this.phone});
  UsersModel.fromJson({required Map<String,dynamic> json}){
    name=json['name'];
    email=json['email'];
    password=json['password'];
    id=json['id'];
    isAdmin=json['isAdmin'];
    phone=json['phone'];


  }

  Map<String,dynamic> toMap(){
    return{
      'name':name,
      'email':email,
      'password':password,
      'id':id,
      'isAdmin':isAdmin,
      'phone':phone

    };
  }
}