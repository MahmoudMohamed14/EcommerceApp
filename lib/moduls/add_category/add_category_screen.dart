import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projectgraduate/models/category_model.dart';
import 'package:projectgraduate/moduls/layout_screen/layout_cubit/cubit_layout.dart';
import 'package:projectgraduate/moduls/layout_screen/layout_cubit/states_layout.dart';
import 'package:projectgraduate/shared/componant/componant.dart';
import 'package:projectgraduate/shared/constant/icon_broken.dart';
import 'package:projectgraduate/shared/constant/values_manager.dart';
import 'package:projectgraduate/shared/language/applocale.dart';

class AddCategoryScreen extends StatelessWidget {


  var categoryNameController=TextEditingController();
  var keyForm=GlobalKey<FormState>();
  CategoryModel? categoryModel;
   bool isEdit;


  AddCategoryScreen({this.categoryModel, this.isEdit=false});

  @override
  Widget build(BuildContext context) {
    if(isEdit){
      categoryNameController.text=categoryModel!.category!;
      CubitLayout.get(context).categoryImageUrl=categoryModel!.image;
    }
    return BlocConsumer<CubitLayout,StateLayout>(
      listener: (context ,state){
        if(state is AddCategorySuccessState){
          categoryNameController.clear();
          CubitLayout.get(context).categoryImage=null;
          CubitLayout.get(context).categoryImageUrl=null;
          Navigator.pop(context);


        }


      },
      builder: (context ,state){
        var cubit =CubitLayout.get(context);
        return Scaffold(


          appBar: AppBar(
            title: Text(isEdit?'EditProduct':'AddProduct'),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(AppSize.s20),
              child: Form(
                key: keyForm,
                child: Column(
                  children: [
                    if(state is CategoryImageUploadLoadingState)
                    Column(children:const [
                      LinearProgressIndicator(),
                      SizedBox(height: 20,),
                    ],),
                    defaultEditText(control: categoryNameController, label: 'name', validat: (s){
                      if(s!.isEmpty){
                        return'${getLang(context, "name_empty")}';
                      }
                      return null;

                    },prefIcon: IconBroken.Edit),
                    SizedBox(height: 20,),

                    InkWell(
                      onTap: (){
                        cubit.getCategoryImage().then((value) {
                          cubit.uploadCategoryImage();


                        }).catchError((onError){});
                      },
                      child: Container(
                        height: 200,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.all(Radius.circular(10)),

                        ),
                        child:isEdit?(cubit.categoryImageUrl == null?Icon(IconBroken.Paper_Fail,size: AppSize.s18): Image(image: NetworkImage(cubit.categoryImageUrl!))):(cubit.categoryImage == null? Icon(Icons.image,size: 100,):cubit.categoryImageUrl == null?Icon(IconBroken.Paper_Fail,size: AppSize.s18): Image(image: NetworkImage(cubit.categoryImageUrl!))),

                      ),
                    ),
                    SizedBox(height: 20,),
                    defaultButton(onPress: (){
                      if(keyForm.currentState!.validate()&&cubit.categoryImageUrl !=null) {
                        if (state is CategoryImageUploadLoadingState) {} else {
                          if(isEdit) {

                            cubit.editCategory(image: cubit.categoryImageUrl,
                                category: categoryNameController.text,id: categoryModel!.id);
                          }else{
                            cubit.addCategory(image: cubit.categoryImageUrl,
                                category: categoryNameController.text);

                          }
                        }
                      }
                    }, name:isEdit?'Edit': 'Add')


                  ],
                ),
              ),

            ),
          ),
        );
      },

    );
  }
}