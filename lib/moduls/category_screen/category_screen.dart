import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projectgraduate/models/category_model.dart';
import 'package:projectgraduate/moduls/addProduct/addproduct_screen.dart';
import 'package:projectgraduate/moduls/add_category/add_category_screen.dart';
import 'package:projectgraduate/moduls/home/home_screen.dart';
import 'package:projectgraduate/moduls/layout_screen/layout_cubit/cubit_layout.dart';
import 'package:projectgraduate/moduls/layout_screen/layout_cubit/states_layout.dart';
import 'package:projectgraduate/shared/componant/componant.dart';
import 'package:projectgraduate/shared/constant/color_manager.dart';

import 'package:projectgraduate/shared/constant/icon_broken.dart';
import 'package:projectgraduate/shared/language/applocale.dart';

class CategoriesScreen extends StatelessWidget {
 // List<ProductModel>? listCategory;
  CategoryModel ?categoryModel;


  CategoriesScreen({ this.categoryModel,});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CubitLayout,StateLayout>(
      listener: (context,state){
        if(state is DeleteCategorySuccessState){
          Navigator.pop(context);
        }

      },
      builder:(context,state){
        var cubit=CubitLayout.get(context);
        return Scaffold(
          floatingActionButton: cubit.myData!.isAdmin!?FloatingActionButton(
            onPressed: (){
              navigateTo(context, AddProductScreen(categoryName:categoryModel!.category ,));
            },
            child:Icon(IconBroken.Plus) ,
          ):null,
        appBar: AppBar(title: Text(categoryModel!.category!,),
          actions: [
            if(  cubit.myData!.isAdmin!)  PopupMenuButton(

              onSelected: (value)async{

                if("delete"==value){



                  showDialog(context: context,
                      builder: (context)=> AlertDialog(
                        title: Text('Delete Category'),
                        content:Text('Do you want to delete this Category '),

                        actions: [
                          TextButton(onPressed:(){
                            Navigator.pop(context);
                          }, child: Text('${getLang(context, "no")}')),
                          TextButton(onPressed: (){
                            cubit.deleteCategory(categoryId: categoryModel!.id!);



                            showToast(text: value.toString(), state: ToastState.SUCCESS);
                            Navigator.pop(context);


                          }, child: Text('${getLang(context, "yes")}')),

                        ],
                      ),
                      barrierDismissible: false

                  );

                }
                if(value=='edit'){
                  final reslt=  await  Navigator.push(context,MaterialPageRoute(builder: (context)=> AddCategoryScreen(isEdit: true,categoryModel: categoryModel,)));
                  if(reslt!=null){
                    print(reslt.toMap());


                  }
                }


              },


              icon: Icon(Icons.more_vert,color: ColorManager.primary,),

              itemBuilder: (BuildContext context){
                return  [ PopupMenuItem<String>(


                    value: '${getLang(context, "delete")}',
                    child:Text('${getLang(context, "delete")}') ),
                  PopupMenuItem<String>(


                      value: 'edit',
                      child:Text('edit') )
                ];

              },

            ),

          ],
        ),
          body: ConditionalBuilder(
            condition:cubit.getCategoryList(categoryName: categoryModel!.category).isNotEmpty,

            builder: (context)=>Padding(
          padding: const EdgeInsets.all(20),
          child: HomeScreen.buildGridProduct(cubit.getCategoryList(categoryName: categoryModel!.category), context),
        ),
            fallback: (context)=> Center(child: Text('No Item Product',style: Theme.of(context).textTheme.headline2,)),
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