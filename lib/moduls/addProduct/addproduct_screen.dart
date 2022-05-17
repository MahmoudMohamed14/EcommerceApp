import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projectgraduate/models/product_model.dart';


import 'package:projectgraduate/moduls/layout_screen/layout_cubit/states_layout.dart';
import 'package:projectgraduate/shared/componant/componant.dart';
import 'package:projectgraduate/shared/constant/icon_broken.dart';
import 'package:projectgraduate/shared/constant/values_manager.dart';
import 'package:projectgraduate/shared/language/applocale.dart';

import '../layout_screen/layout_cubit/cubit_layout.dart';

class AddProductScreen extends StatelessWidget {
  String ?categoryName;
  bool ?isEdit;
  ProductModel? productModel;
  //declaration for old price controlar



  AddProductScreen({this.categoryName,this.isEdit=false,this.productModel});

  var priceController=TextEditingController();
  var nameController=TextEditingController();
  var old_priceController=TextEditingController();
  var descriptionController=TextEditingController();
  var categoryController=TextEditingController();




  @override
  Widget build(BuildContext context) {

    if(isEdit!){
      priceController.text=productModel!.price.toString();
      nameController.text=productModel!.name!;
      categoryController.text=productModel!.category!;
      old_priceController.text=productModel!.old_Price!.toString();
      descriptionController.text=productModel!.description!;
      CubitLayout.get(context).productImageUrl=productModel!.image;

    }else{
      old_priceController.text='0.0';
    }
    return BlocConsumer<CubitLayout,StateLayout>(
      listener: (context ,state){
        if(state is EditProductSuccessState){
          Navigator.pop(context,ProductModel(
              description: descriptionController.text,
              category: categoryController.text,
              image: CubitLayout.get(context).productImageUrl,
              price: double.parse(priceController.text),
              id: productModel!.id,
              name: nameController.text,
              old_Price: double.parse(old_priceController.text)
          ));
          priceController.clear();
          nameController.clear();
          descriptionController.clear();
          old_priceController.clear();
          CubitLayout.get(context).productImage=null;
          CubitLayout.get(context).productImageUrl=null;

        }

        if(state is AddProductSuccessState){

          priceController.clear();
          nameController.clear();
          descriptionController.clear();
          old_priceController.clear();
          CubitLayout.get(context).productImage=null;
          CubitLayout.get(context).productImageUrl=null;
          Navigator.pop(context);




        }
      },
      builder: (context ,state){
        if(! isEdit!)
   categoryController.text=categoryName??'';

        var cubit =CubitLayout.get(context);
        return Scaffold(
          appBar: AppBar(
            title: Text('AddProduct'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  if(state is ProductImageUploadLoadingState)
                    Column(children:const [
                      LinearProgressIndicator(),
                      SizedBox(height: 20,),
                    ],),
                  defaultEditText(control: nameController, label: 'name', validat: (s){
                    if(s!.isEmpty){
                      return'${getLang(context, "name_empty")}';
                    }
                    return null;

                  },prefIcon: IconBroken.Edit),
                  SizedBox(height: 20,),
                  defaultEditText(control: categoryController, label: 'category', validat: (s){
                    if(s!.isEmpty){
                      return'${getLang(context, "name_empty")}';
                    }
                    return null;

                  },prefIcon: IconBroken.Category),
                  SizedBox(height: 20,),
                  defaultEditText(control: priceController, label: 'price', validat: (s){
                    if(s!.isEmpty){
                      return'${getLang(context, "name_empty")}';
                    }
                    return null;

                  },prefIcon: IconBroken.Wallet,textType: TextInputType.number),
                  SizedBox(height: 20,),
                  defaultEditText(control: old_priceController, label: 'old price', validat: (s){
                    if(s!.isEmpty){

                      return'${getLang(context, "name_empty")}';
                    }
                    return null;

                  },prefIcon: IconBroken.Wallet,textType: TextInputType.number),
                  SizedBox(height: 20,),
                  defaultEditText(control: descriptionController, label: 'description', validat: (s){
                    if(s!.isEmpty){
                      return'${getLang(context, "name_empty")}';
                    }
                    return null;

                  },maxLine: null,prefIcon: IconBroken.Document),
                  SizedBox(height: 20,),
                  InkWell(
                    onTap: (){
                      cubit.getProductImage().then((value) {
                        cubit.uploadProductImage();


                      }).catchError((onError){});
                    },
                    child: Container(
                      height: 200,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.all(Radius.circular(10)),

                      ),
                      child:isEdit!?(cubit.productImageUrl == null?Icon(IconBroken.Paper_Fail,size: AppSize.s18): Image(image: NetworkImage(cubit.productImageUrl!))):(cubit.productImage == null? Icon(Icons.image,size: 100,):cubit.productImageUrl == null?Icon(IconBroken.Paper_Fail,size: AppSize.s18): Image(image: NetworkImage(cubit.productImageUrl!))),

                    ),
                  ),
                  SizedBox(height: 20,),
                  defaultButton(onPress: (){
                    if(state is ProductImageUploadLoadingState||state is EditProductLoadingState){}else {
                    if(isEdit!){
                      cubit.editProduct(
                          description: descriptionController.text,
                          category: categoryController.text,
                          image: cubit.productImageUrl,
                          price: priceController.text,
                          name: nameController.text,
                          id: productModel!.id,
                          old_price: old_priceController.text

                      );

                    }else{  cubit.addProduct(
                          description: descriptionController.text,
                          category: categoryController.text,
                          image: cubit.productImageUrl,
                          price: priceController.text,
                          name: nameController.text,
                          old_price: old_priceController.text

                      );}
                    }
                  }, name:isEdit!? 'Edit':'Add')


                ],
              ),
            ),
          ),
        );
      },

    );
  }
}
