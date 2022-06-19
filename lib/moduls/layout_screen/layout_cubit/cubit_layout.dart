
import 'dart:io';
import 'dart:math';


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:image_picker/image_picker.dart';
import 'package:projectgraduate/models/cart_model.dart';
import 'package:projectgraduate/models/category_model.dart';
import 'package:projectgraduate/models/order_model.dart';
import 'package:projectgraduate/models/product_model.dart';
import 'package:projectgraduate/models/user_model.dart';
import 'package:projectgraduate/moduls/cart/cart_screen.dart';

import 'package:projectgraduate/moduls/home/home_screen.dart';
import 'package:projectgraduate/moduls/layout_screen/layout_cubit/states_layout.dart';

import 'package:projectgraduate/moduls/order/order_screen.dart';
import 'package:projectgraduate/moduls/profile/profile_screen.dart';
import 'package:projectgraduate/moduls/request_admin/requestAdmin_screen.dart';
import 'package:projectgraduate/shared/constant/color_manager.dart';

import 'package:projectgraduate/shared/constant/data_shared.dart';
import 'package:projectgraduate/shared/constant/icon_broken.dart';
import 'package:projectgraduate/shared/network/local/cache_helper.dart';


class CubitLayout extends Cubit<StateLayout> {

  CubitLayout() : super(InitLayoutState());
  static CubitLayout get(context) {
    return BlocProvider.of(context);
  }

  List<String>listTitleSuper=['Order','Home','AdminRequest'];
  List<Widget>listWidgetSuper=[OrderScreen(),HomeScreen(),RequestAdminScreen()];
  List<Widget>listIconSuper=[
    CircleAvatar(backgroundImage: AssetImage('assets/image/order.png'),radius: 22,),
    Icon(IconBroken.Home, size: 35,color: ColorManager.white,),

    Icon( IconBroken.Add_User, size: 35,color: ColorManager.white,),];
  List<Widget>listIconAdmin=[
    const CircleAvatar(backgroundImage: AssetImage('assets/image/order.png'),radius: 22,),
    Icon(IconBroken.Home, size: 35,color: ColorManager.white,),

    Icon( IconBroken.Profile, size: 35,color: ColorManager.white,),];
  List<Widget>listIconCustomer=[
    CircleAvatar(backgroundImage: AssetImage('assets/image/order.png'),radius: 22,),
    Icon(IconBroken.Home, size: 35,color: ColorManager.white,),

    Icon( IconBroken.Buy, size: 35,color: ColorManager.white,),];

  List<String>listTitleCustomer=['Order','Home','Cart'];
  List<Widget>listWidgetCustomer=[OrderScreen(),HomeScreen(),CartScreen()];
  List<String>listTitleAdmin=['Order','Home','Profile'];
  List<Widget>listWidgetAdmin=[OrderScreen(),HomeScreen(),ProfileScreen()];

  int index = 1;
  void  changeBottomNav({required int index})
  {

    this. index = index;

    emit( ChangeBottomNavState());
  }
  void init(){
    getUserData();
    getCategory();
    getProducts();
    changeBottomNav(index: 1);
    if(CacheHelper.getData(key: 'uId')!=null) getToCart();
    getAllOrder();
    getAllUser();
  }

  File? productImage;

  Future<void> getProductImage() async {

    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      productImage = File(pickedFile.path);
      emit(ProductImagePickerSuccessState());
    } else {
      print('No image selected.');
      emit(ProductImagePickerErrorState());
    }

  }
  String?productImageUrl;
   uploadProductImage()async{
     emit(ProductImageUploadLoadingState());
    Reference reference= FirebaseStorage.instance
        .ref()
        .child('users').child('/${Uri.file(productImage!.path).pathSegments.last}');
    UploadTask uploadTask =reference.putFile(productImage!);
    uploadTask.whenComplete(() {
      reference.getDownloadURL().then((value) {
        productImageUrl=value;
        emit(ProductImageUploadSuccessState());
      });
    });





  }
  void addProduct(
      {String? name,
        String? price,
        String? old_price,
        String?description,
        String ?image

        , String ?category}){
  emit(AddProductLoadingState());
     ProductModel  productModel=ProductModel(
         name: name,
         price: double.parse(price!)
         ,old_Price:double.parse(old_price!),
         image: image,
         category: category,
         description: description ,
         adminId: uId
     );

     FirebaseFirestore
         .instance.
     collection('Products')
         .add(productModel
         .toMap()).then((value) {

       FirebaseFirestore.instance.
       collection('Products').
       doc(value.id).
       update({'id':value.id}).
       then((value) {
         emit(AddProductSuccessState());
         getProducts();

       }).catchError((onError){

       });
     }).catchError((onError){
           emit(AddProductErrorState());
     });
  }

  void editProduct(
      {String? name,
        String? price,
        String? old_price,
        String?description,
        String ?image,
        String?id

        , String ?category}){
    emit(EditProductLoadingState());
    ProductModel  productModel=ProductModel(
      name: name,
      id: id,
      price: double.parse(price!)
      ,old_Price:double.parse(old_price!),
      image: image,
      category: category,
      description: description ,
        adminId: uId
    );

    FirebaseFirestore
        .instance.
    collection('Products')
        .doc(id).update(productModel.toMap()).then((value) {

      getProducts();
   //   DetailsScreen(productModel);
        emit(EditProductSuccessState());



    }).catchError((onError){
      emit(EditProductErrorState());
    });
  }
  List<ProductModel>?listAllProduct;
  List<ProductModel> listProductSearch=[];
  void search(String value){
   listProductSearch = listAllProduct!.where((element) => element.name!.toLowerCase().contains(value.toLowerCase())).toList();
 emit(SearchState());
  }
  void getProducts(){
    listAllProduct=[];

    emit(GetProductLoadingState());

    FirebaseFirestore
        .instance.
    collection('Products')
        .get()
        .then((value) {
          if(CacheHelper.getData(key: 'admin')){
            for (var element in value.docs) {
              print(element.data()['old_Price']);
              if(element.data()['adminId']==uId){
                listAllProduct!.add(ProductModel.fromJson(element.data()));
              }


            }
          }else{
            for (var element in value.docs) {
              print(element.data()['old_Price']);
              listAllProduct!.add(ProductModel.fromJson(element.data()));

            }
          }

          emit(GetProductSuccessState());

    }).catchError((onError){
      emit(GetProductErrorState());
    });
  }
  void deleteProduct({required String productId }){


    FirebaseFirestore
        .instance.
    collection('Products')
        .doc(productId)
       .delete()
        .then((value) {
          getProducts();

      emit(DeleteProductSuccessState());

    }).catchError((onError){
      emit(DeleteProductErrorState());
    });
  }
  File? categoryImage;

  Future<void> getCategoryImage() async {

    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      categoryImage = File(pickedFile.path);
      emit(CategoryImagePickerSuccessState());
    } else {
      print('No image selected.');
      emit(CategoryImagePickerErrorState());
    }

  }

  String?categoryImageUrl;
  uploadCategoryImage()async{
    emit(CategoryImageUploadLoadingState());
    Reference reference= FirebaseStorage.instance
        .ref()
        .child('users').child('/${Uri.file(categoryImage!.path).pathSegments.last}');
    UploadTask uploadTask =  reference.putFile(categoryImage!) ;
    uploadTask.whenComplete(() {
      reference.getDownloadURL().then((value) {
        categoryImageUrl=value;
        emit(CategoryImageUploadSuccessState());
      });
    });





  }
  void addCategory(
      {
        String ?image
        , String ?category}){
    emit(AddCategoryLoadingState());
    CategoryModel  productModel=CategoryModel(
      image: image,
      category: category,
      adminId: uId

    );

    FirebaseFirestore
        .instance.
    collection('Category')
        .add(productModel
        .toMap()).then((value) {
      FirebaseFirestore
          .instance.
      collection('Category').doc(value.id).update({'id':value.id}).then((value){
        getCategory();
        emit(AddCategorySuccessState());

      }).catchError((onError){
        emit(AddCategoryErrorState());
      });


    }).catchError((onError){
      emit(AddCategoryErrorState());
    });
  }
  void editCategory(
      {
        String ?image
        , String ?category,
        String ?id
      }){
    emit(AddCategoryLoadingState());
    CategoryModel  productModel=CategoryModel(
      image: image,
      category: category,
      id: id,
        adminId: uId

    );

    FirebaseFirestore
        .instance.
    collection('Category')
    .doc(id)
        .update(productModel
        .toMap()).then((value) {
      getCategory();
      emit(AddCategorySuccessState());


    }).catchError((onError){
      emit(AddCategoryErrorState());
    });
  }
  List<CategoryModel>?listAllCategory;

  void getCategory(){
    listAllCategory=[];
    emit(GetCategoryLoadingState());

    FirebaseFirestore
        .instance.
        collection('Category')
        .get()
        .then((value) {
      if(CacheHelper.getData(key: 'admin')){
        for (var element in value.docs) {
          print(element.data()['old_Price']);
          if(element.data()['adminId']==uId){
            listAllCategory!.add(CategoryModel.fromJson(element.data()));
          }

        }
      }else{
        for (var element in value.docs) {
          print('hajyg');
          print(element.data()['old_Price']);
          listAllCategory!.add(CategoryModel.fromJson(element.data()));

        }
      }


      emit(GetCategorySuccessState());


    }).catchError((onError){
      emit(GetCategoryErrorState());
    });
  }
  List<UsersModel>listAllUser=[];

  void deleteCategory({required String categoryId }){


    FirebaseFirestore
        .instance.
    collection('Category')
        .doc(categoryId)
        .delete()
        .then((value) {
      getCategory();

      emit(DeleteCategorySuccessState());

    }).catchError((onError){
      emit(DeleteCategoryErrorState());
    });
  }
  void getAllUser(){

    emit(GetAllUserLoadingState ());
    FirebaseFirestore.instance
        .collection('users').snapshots().listen((event) {
          listAllUser=[];
          for (var element in event.docs) {
            if(element.data()!=null){
              if(element.data()['requestAdmin'] !=null){
                if(element.data()['requestAdmin']){
                  listAllUser.add(UsersModel.fromJson(json: element.data()));
                }
              }
            }

          }
          emit( GetAllUserSuccessState ());
    });

  }
  List<CartModel>listproductOrderForVenderOrCuctomer=[];
  void getProductForEachVender(OrderModel orderModel){
    listproductOrderForVenderOrCuctomer=[];

    for (var element in orderModel.orderProducts!) {
      if(CacheHelper.getData(key: 'admin')){
        if(element['adminId']==CacheHelper.getData(key: 'uId')){
          listproductOrderForVenderOrCuctomer.add(CartModel.fromJson(element));
        }


      }else{
        listproductOrderForVenderOrCuctomer.add(CartModel.fromJson(element));
      }

    }

        }



  double calculateTotalPriceCartOrder(List<CartModel> listCart){
    double total=0;
     if(listCart.isNotEmpty) {
       for (var element in listCart) {
         total += (double.parse(element.price.toString()) *
             double.parse(element.quantity.toString()));
       }
     }

    return total;


  }
  void acceptRequestAdmin({required String id}){
    FirebaseFirestore.instance
        .collection('users')
        .doc(id).update({'requestAdmin':false}).then((value) {
      getAllUser();
      emit(AcceptAdminSuccessState());
    })
        .catchError((onError){
          emit(AcceptAdminErrorState());

    });
  }
  void cancelRequestAdmin({required String id}){
    FirebaseFirestore.instance
        .collection('users')
        .doc(id).update({'requestAdmin':false,'isAdmin':false}).then((value) {
      getAllUser();
      emit(CancelAdminSuccessState());
    })
        .catchError((onError){
      emit(CancelAdminErrorState());

    });
  }

  UsersModel? myData;
  void getUserData(){
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId).get().then((value) {
          myData=UsersModel.fromJson(json: value.data()!);
          if(CacheHelper.getData(key:'admin')==null){
            CacheHelper.putData(key: 'admin', value: value.data()!['isAdmin']);
          }
          if(value.data()!['requestAdmin']!=null) requestAdmin=value.data()!['requestAdmin'];

          if(value.data()!['superAdmin']!=null) superAdmin=value.data()!['superAdmin'];





          emit(GetUserDataSuccessState());

          print(value.data()!['name']);

    }).catchError((onError){
      emit(GetUserDataErrorState());
    });

  }
  void updateUser({name,phone}){
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId).update({'name':name,'phone':phone}).then((value) {
      getUserData();
      emit(UpdateUserSuccessState());
    })
        .catchError((onError){
      emit(UpdateUserErrorState());

    });
  }

  List<ProductModel> getCategoryList({String ?categoryName}) {
    List<ProductModel> categoryList=[];
    for (var element in listAllProduct!) {
      if(element.category==categoryName){
        categoryList.add(element);
      }
    }
    return categoryList;
  }
  List<CartModel> listCartModel=[];
  List<Map<String,dynamic>>list=[];
  List<Map<String,dynamic>>listProductOfOrder=[];

  String cartId='';
  int counteraddToCart=0;
  double totalOfCart=0;

  void addToCart(CartModel cartModel){

    FirebaseFirestore.instance
        .collection('users')
        .doc(uId!).collection('cart').doc("mycart").update(
      {'cart': FieldValue.arrayUnion([cartModel.toMap()])},).then((value) {

          getToCart();
         emit( AddCartSuccessState());


    }).catchError((onError){
      print(onError.toString());
      emit( AddCartErrorState());
    });

  }
  List<String>listAdmin=[];
  void getToCart(){
    emit(GetCartLoadingState ());
    if(uId !=null) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(uId!).collection('cart').doc('mycart').snapshots().listen((event) {
        List listCart = [];
        listCartModel = [];
        listAdmin = [];

        if (event.data() == null || event.data()!['cart'] == null) {
          FirebaseFirestore.instance
              .collection('users')
              .doc(uId!).collection('cart').doc("mycart").set({'cart': []});
        } else {
          listCart = event.data()!['cart'];

          for (var element in listCart) {
            listCartModel.add(CartModel.fromJson(element));
            if (element['adminId'] != null)
              listAdmin.add(element['adminId']);
          }
          print(listCart);

          print('list admin${listAdmin.toSet().toList()}');


          emit(GetCartSuccessState());
        }
      });
    }
      // .then((value) {
    //       if(value.data()==null||value.data()!['cart']==null){
    //         FirebaseFirestore.instance
    //             .collection('users')
    //             .doc(uId!).collection('cart').doc("mycart").set({'cart':[]});
    //
    //
    //       }else{
    //         listCart=value.data()!['cart'];
    //         listCart.forEach((element) {
    //           listCartModel.add(CartModel.fromJson(element));
    //
    //
    //         });
    //         print(listCart);
    //
    //
    //         emit( GetCartSuccessState());
    //
    //       }
    //
    //
    //
    // }).catchError((onError){
    //   print(onError.toString());
    //
    //   emit( GetCartErrorState());
    //
    // });

  }

  void deleteItemfromCart(CartModel cartModel){
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId!).collection('cart').doc("mycart").update(
        {'cart': FieldValue.arrayRemove([cartModel.toMap()])},).then((value) {
          getToCart();
     emit( DeleteItemCartSuccessState());

    }).catchError((onError){
      emit( DeleteItemCartErrorState());
    });
  }
  void updateToCart(CartModel cartModel,int index){
    listCartModel[index]=cartModel;
    for (var element in listCartModel) {
      list .add(element.toMap());

    }

    FirebaseFirestore.instance
        .collection('users')
        .doc(uId!).collection('cart').doc("mycart").update({'cart':list}).then((value) {
         list=[];
      getToCart();
      emit( UpdateItemCartSuccessState());


    }).catchError((onError){
      print(onError.toString());
      emit(  UpdateItemCartErrorState());
    });

  }
  double calculateTotalCheck(){
    totalOfCart=0;
    listProductOfOrder=[];
    if(listCartModel.length>0){
      for (var element in listCartModel) {

        totalOfCart+=(element.price   * element.quantity);
        listProductOfOrder.add(element.toMap());

      }
    }
    return totalOfCart ;

  }
  void emitFunction() {
    emit(EmitToRebuildState());
  }
  void deleteAllCart(){
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId!).collection('cart').doc("mycart").update(
      {'cart': FieldValue.delete()},).then((value) {
      getToCart();
      emit( DeleteAllCartSuccessState());

    }).catchError((onError){
      emit( DeleteAllCartErrorState());
    });
  }
  String getRandomString(int length) {
    const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    Random _rnd = Random();
    return String.fromCharCodes(Iterable.generate(
        length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
  }
  void addOrder(OrderModel orderModel){
    FirebaseFirestore.instance
        .collection('order')
        .doc(orderModel.orderId)
        .set(orderModel.toMap())
        .then((value) {
          deleteAllCart();
          getAllOrder();
          emit(AddOrderSuccessState ());
    })
        .catchError((onError){
          print('order error '+onError.toString());
      emit(AddOrderErrorState ());
    });


  }
  List<dynamic> admin=[];
  List<OrderModel>listPendingOrder=[];
  List<OrderModel>listCancelOrder=[];
  List<OrderModel>listDoneOrder=[];
  void getAllOrder(){
    listPendingOrder=[];
    listCancelOrder=[];
    listDoneOrder=[];
    admin=[];

    emit(GetOrderLoadingState());
    FirebaseFirestore.instance
        .collection('order')
        .get()
        .then((value) {
          for (var element in value.docs) {
            if(element.data()['orderState']=='Pending') {
              admin= element.data()['listAdminId']  ;
              print(" admin ${list}");

              if(CacheHelper.getData(key: 'admin')){

              for (var admin in admin) {
                if(admin==uId){
                  listPendingOrder.add(OrderModel.fromJson(element.data()));
                }

              }




              }else {
                if(element.data()['customerId']==uId){
                  listPendingOrder.add(OrderModel.fromJson(element.data()));
                }
              }



            }
           else if(element.data()['orderState']=='Cancel'){
              admin= element.data()['listAdminId']  ;
              if(CacheHelper.getData(key: 'admin')){

                for (var admin in admin) {
                  if(admin==uId){
                    listCancelOrder.add(OrderModel.fromJson(element.data()));
                  }

                }

              }else {
                if(element.data()['customerId']==uId){
                 listCancelOrder.add(OrderModel.fromJson(element.data()));
                }
              }
            }else{
              admin= element.data()['listAdminId']  ;

              if(CacheHelper.getData(key: 'admin')){
                for (var admin in admin) {
                  if(admin==uId){
                    listCancelOrder.add(OrderModel.fromJson(element.data()));
                  }

                }

              }else {
                if(element.data()['customerId']==uId){
                  listDoneOrder.add(OrderModel.fromJson(element.data()));
                }
              }
            }
            print( listCancelOrder);

          }

      emit(GetOrderSuccessState ());
    })
        .catchError((onError){
          print( 'order Error '+ onError.toString());
      emit(GetOrderErrorState ());
    });


  }
  void  cancelOrder(String id){
    FirebaseFirestore.instance
        .collection('order')
        .doc(id)
        .update({"orderState":'Cancel'})
        .then((value) {
          getAllOrder();
   emit( CancelOrderSuccessState());
    }).catchError((onError){
      emit( CancelOrderErrorState());

    });
  }

  void  clickDoneOrder(String id){
    FirebaseFirestore.instance
        .collection('order')
        .doc(id)
        .update({"orderState":'Done'})
        .then((value) {
      getAllOrder();
      emit( DoneOrderSuccessState());
    }).catchError((onError){
      emit( DoneOrderErrorState());

    });
  }
  void  deleteOrder(String id){
    FirebaseFirestore.instance
        .collection('order')
        .doc(id)
        .delete()
        .then((value) {
      getAllOrder();
      emit( DoneOrderSuccessState());
    }).catchError((onError){
      emit( DoneOrderErrorState());

    });
  }



}