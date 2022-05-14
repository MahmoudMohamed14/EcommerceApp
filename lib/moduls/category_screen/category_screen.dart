import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projectgraduate/models/category_model.dart';
import 'package:projectgraduate/models/product_model.dart';
import 'package:projectgraduate/moduls/addProduct/addproduct_screen.dart';
import 'package:projectgraduate/moduls/home/home_screen.dart';
import 'package:projectgraduate/moduls/layout_screen/layout_cubit/cubit_layout.dart';
import 'package:projectgraduate/moduls/layout_screen/layout_cubit/states_layout.dart';
import 'package:projectgraduate/shared/componant/componant.dart';

import 'package:projectgraduate/shared/constant/icon_broken.dart';

class CategoriesScreen extends StatelessWidget {
  List<ProductModel>? listCategory;
  String? title;


  CategoriesScreen({this.listCategory, this.title});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CubitLayout,StateLayout>(
      listener: (context,state){

      },
      builder:(context,state){
        var cubit=CubitLayout.get(context);
        return Scaffold(
          floatingActionButton: cubit.myData!.isAdmin!?FloatingActionButton(
            onPressed: (){
              navigateTo(context, AddProductScreen(categoryName:title ,));
            },
            child:Icon(IconBroken.Plus) ,
          ):null,
        appBar: AppBar(title: Text(title!,),),
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: HomeScreen.buildGridProduct(listCategory!, context),
          ),
        );},


    );
  }
  Widget buildCategory(context,CategoryModel categoryModel){
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(


        children: [
          Image(
              width: 150,
              height: 150,
              image: NetworkImage('${categoryModel.image}')
          ),
          SizedBox(width: 10,),
          Text(
            '${categoryModel.category}',
            maxLines: 1,

            style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),
          ),
          Spacer(),
          Icon(Icons.arrow_forward_ios)
        ],
      ),
    );
  }
}