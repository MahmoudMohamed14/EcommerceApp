
import 'dart:io';


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:image_picker/image_picker.dart';
import 'package:projectgraduate/models/cart_model.dart';
import 'package:projectgraduate/models/category_model.dart';
import 'package:projectgraduate/models/product_model.dart';
import 'package:projectgraduate/models/user_model.dart';
import 'package:projectgraduate/moduls/cart/cart_screen.dart';

import 'package:projectgraduate/moduls/home/home_screen.dart';
import 'package:projectgraduate/moduls/layout_screen/layout_cubit/states_layout.dart';
import 'package:projectgraduate/shared/constant/data_shared.dart';


class CubitLayout extends Cubit<StateLayout> {

  CubitLayout() : super(InitLayoutState());
  static CubitLayout get(context) {
    return BlocProvider.of(context);
  }
  List<String>listTitle=['Category','Product','Card'];
  List<Widget>listWidget=[HomeScreen(),HomeScreen(),CartScreen()];

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
    getToCart();
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
  void getProducts(){
    listAllProduct=[];
    emit(GetProductLoadingState());
    FirebaseFirestore
        .instance.
    collection('Products')
        .get()
        .then((value) {
          value.docs.forEach((element) {
            print(element.data()['old_Price']);
            listAllProduct!.add(ProductModel.fromJson(element.data()));

          });
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
    UploadTask uploadTask =reference.putFile(categoryImage!);
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

    );

    FirebaseFirestore
        .instance.
    collection('Category')
        .add(productModel
        .toMap()).then((value) {
      emit(AddCategorySuccessState());
      getCategory();

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
      value.docs.forEach((element) {
        listAllCategory!.add(CategoryModel.fromJson(element.data()));

      });
      emit(GetCategorySuccessState());


    }).catchError((onError){
      emit(GetCategoryErrorState());
    });
  }
  UsersModel? myData;
  void getUserData(){
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId).get().then((value) {
          myData=UsersModel.fromJson(json: value.data()!);
          emit(GetUserDataSuccessState());

          print(value.data()!['name']);

    }).catchError((onError){
      emit(GetUserDataErrorState());
    });

  }

  List<ProductModel> getCategoryList({String ?categoryName}) {
    List<ProductModel> categoryList=[];
    listAllProduct!.forEach((element) {
      if(element.category==categoryName){
        categoryList.add(element);
      }
    });
    return categoryList;
  }
  List<CartModel> listCartModel=[];
  List<Map<String,dynamic>>list=[];
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
  void getToCart(){

   List listt=[];
   listCartModel=[];
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId!).collection('cart').doc('mycart').get().then((value) {
          if(value.data()==null){
            FirebaseFirestore.instance
                .collection('users')
                .doc(uId!).collection('cart').doc("mycart").set({'cart':[]});


          }else{
            listt=value.data()!['cart'];
            listt.forEach((element) {
              listCartModel.add(CartModel.fromJson(element));


            });
            print(listt);


            emit( GetCartSuccessState());

          }



    }).catchError((onError){
      print(onError.toString());

      emit( GetCartErrorState());

    });

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
    listCartModel.forEach((element) {
      list .add(element.toMap());

    });

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
  double calculateTotalChecke(){
    totalOfCart=0;
    if(listCartModel.length>0){
      listCartModel.forEach((element) {

        totalOfCart+=(element.price   * element.quantity);

      });
    }
    return totalOfCart ;

  }
  void emitFunction() {
    emit(EmitToRebuildState());
  }

}