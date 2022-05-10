import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projectgraduate/moduls/layout_screen/layout_cubit/states_layout.dart';
import 'package:projectgraduate/shared/componant/componant.dart';
import 'package:projectgraduate/shared/constant/icon_broken.dart';
import 'package:projectgraduate/shared/constant/values_manager.dart';
import 'package:projectgraduate/shared/language/applocale.dart';

import '../layout_screen/layout_cubit/cubit_layout.dart';

class AddProductScreen extends StatelessWidget {

  var priceController=TextEditingController();
  var nameController=TextEditingController();
  var old_priceController=TextEditingController();
  var descriptionController=TextEditingController();
  var categoryController=TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CubitLayout,StateLayout>(
      listener: (context ,state){

      },
      builder: (context ,state){

        old_priceController.text=0.0.toString();
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
                      child:cubit.productImage == null? Icon(Icons.image,size: 100,):cubit.productImageUrl == null?Icon(IconBroken.Paper_Fail,size: AppSize.s18): Image(image: NetworkImage(cubit.productImageUrl!)),

                    ),
                  ),
                  SizedBox(height: 20,),
                  defaultButton(onPress: (){
                    cubit.addProduct(
                        description: descriptionController.text,
                        category: categoryController.text,
                        image: cubit.productImageUrl,
                        price: priceController.text,
                        name: nameController.text,
                        old_price: old_priceController.text

                    );
                  }, name: 'upload')


                ],
              ),
            ),
          ),
        );
      },

    );
  }
}
