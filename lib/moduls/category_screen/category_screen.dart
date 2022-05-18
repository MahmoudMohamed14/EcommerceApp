import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projectgraduate/models/category_model.dart';
import 'package:projectgraduate/models/product_model.dart';
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
  String? title;


  CategoriesScreen({ this.title});

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
        appBar: AppBar(title: Text(title!,),
          actions: [
            if(  cubit.myData!.isAdmin!)  PopupMenuButton(

              onSelected: (value)async{

                if("delete"==value){

                  // CubitLayout.get(context).getAllStudent(code: model.code,formOut: true);

                  // showDialog(context: context,
                  //     builder: (context)=> AlertDialog(
                  //       title: Text('${getLang(context, "delete_class")}'),
                  //       content:Text('${getLang(context, "wantDelete_class")}'),
                  //
                  //       actions: [
                  //         TextButton(onPressed:(){
                  //           Navigator.pop(context);
                  //         }, child: Text('${getLang(context, "no")}')),
                  //         TextButton(onPressed: (){
                  //
                  //           CubitLayout.get(context).listStudent.forEach((element) {
                  //             CubitApp.get(context).deleteClassRoomFromStudent(code: model.code!,studentEmail: element.studentEmail);
                  //
                  //           });
                  //           CubitApp.get(context).deleteClass(code: model.code!);
                  //           DioHelper.postNotification(to: '/topics/${model.code!}',
                  //               title: model.className!,
                  //               body: 'you teacher has delete this class',
                  //               data: { 'payload': 'unsub${model.code!}',});
                  //           CubitApp.get(context).deleteClassRoomFromStudent(code: model.code!,studentEmail: model.teacherEmail,);
                  //
                  //           showToast(text: value.toString(), state: ToastState.SUCCESS);
                  //
                  //           Navigator.pop(context);
                  //         }, child: Text('${getLang(context, "yes")}')),
                  //
                  //       ],
                  //     ),
                  //     barrierDismissible: false
                  //
                  // );

                }
                if(value=='edit'){
                  final reslt=  await  Navigator.push(context,MaterialPageRoute(builder: (context)=> AddCategoryScreen()));
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
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: HomeScreen.buildGridProduct(cubit.getCategoryList(categoryName: title), context),
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