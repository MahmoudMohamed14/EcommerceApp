
import 'dart:io';
import 'dart:math';



import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:image_picker/image_picker.dart';
import 'package:projectgraduate/models/category_model.dart';
import 'package:projectgraduate/models/product_model.dart';
import 'package:projectgraduate/models/user_model.dart';
import 'package:projectgraduate/moduls/add_category/add_category_screen.dart';
import 'package:projectgraduate/moduls/category_screen/category_screen.dart';
import 'package:projectgraduate/moduls/home/home_screen.dart';
import 'package:projectgraduate/moduls/layout_screen/layout_cubit/states_layout.dart';
import 'package:projectgraduate/shared/constant/data_shared.dart';


class CubitLayout extends Cubit<StateLayout> {

  CubitLayout() : super(InitLayoutState());
  static CubitLayout get(context) {
    return BlocProvider.of(context);
  }
  List<String>listTitle=['Category','Product','Card'];
  List<Widget>listWidget=[CategoriesScreen (),HomeScreen(),HomeScreen()];

  int index = 1;
  void  changeBottomNav({required int index})
  {

    this. index = index;

    emit( ChangeBottomNavState());
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

       }).catchError((onError){

       });
     }).catchError((onError){
           emit(AddProductErrorState());
     });
  }
  List<ProductModel>?listAllProduct;
  void getProducts(){
    listAllProduct=[];
    emit(GetProductSuccessState());
    FirebaseFirestore
        .instance.
    collection('Products')
        .get()
        .then((value) {
          value.docs.forEach((element) {
            print(element.data()['old_Price']);
            listAllProduct!.add(ProductModel.fromJson(element.data()));
            emit(GetProductSuccessState());
          });

    }).catchError((onError){
      emit(GetProductErrorState());
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
  void getUserData(){
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId).get().then((value) {
          myData=UsersModel.fromJson(json: value.data()!);
          print(value.data()!['name']);

    }).catchError((onError){

    });

  }

}