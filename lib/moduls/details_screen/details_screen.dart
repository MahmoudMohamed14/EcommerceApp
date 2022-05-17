import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projectgraduate/models/cart_model.dart';
import 'package:projectgraduate/models/product_model.dart';
import 'package:projectgraduate/moduls/addProduct/addproduct_screen.dart';
import 'package:projectgraduate/moduls/layout_screen/layout_cubit/cubit_layout.dart';
import 'package:projectgraduate/moduls/layout_screen/layout_cubit/states_layout.dart';
import 'package:projectgraduate/shared/componant/componant.dart';
import 'package:projectgraduate/shared/constant/color_manager.dart';
import 'package:projectgraduate/shared/constant/fonst_manager.dart';

import 'package:projectgraduate/shared/constant/test_styles_manager.dart';
import 'package:projectgraduate/shared/constant/values_manager.dart';
import 'package:projectgraduate/shared/language/applocale.dart';

class DetailsScreen extends StatelessWidget {
  ProductModel ?productModel;

  DetailsScreen(this.productModel);

  @override
  Widget build(BuildContext context) {

    return BlocConsumer<CubitLayout,StateLayout>(
      listener: (context,state){
        if(state is AddCartSuccessState){
          showToast(text: 'Add To Cart Successfully', state: ToastState.SUCCESS);
        }
        if(state is DeleteProductSuccessState){
          showToast(text: 'Delete Successfully', state: ToastState.SUCCESS);
          Navigator.pop(context);
        }
        if(state is GetProductSuccessState)  CubitLayout.get(context).emitFunction();
      },
      builder:(context,state){
        var cubit=CubitLayout.get(context);


        return Scaffold(
          appBar: AppBar (
            title: Text('Details'),
            actions: [
            if(  cubit.myData!.isAdmin!)  PopupMenuButton(

                onSelected: (value)async{

                  if("delete"==value){
                    cubit.deleteProduct(productId: productModel!.id!);
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
             final reslt=  await  Navigator.push(context,MaterialPageRoute(builder: (context)=> AddProductScreen(isEdit: true,productModel: productModel,)));
             if(reslt!=null){
               print(reslt.toMap());
               productModel=reslt;


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
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Stack(
                       // alignment: AlignmentDirectional.topStart,
                        children: [
                          Container(
                            width: double.infinity,
                            height: 270,

                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(AppSize.s10),
                              image: DecorationImage(image: NetworkImage(productModel!.image!),
                                fit: BoxFit.fill
                              )
                            ),
                          ),
                          // Padding(
                          //   padding: EdgeInsetsDirectional.only(start: AppPadding.p20,top: AppPadding.p50),
                          //   child: CircleAvatar(
                          //     backgroundColor: ColorManager.lightGrey.withOpacity(.4),
                          //
                          //     child: IconButton(
                          //         icon: Icon(IconBroken.Arrow___Left,color: ColorManager.primary,),
                          //       onPressed: (){
                          //           Navigator.pop(context);
                          //       },
                          //     ),
                          //   )),
                          // Align(
                          //   alignment: AlignmentDirectional.bottomEnd,
                          //   child: Padding(
                          //       padding: EdgeInsetsDirectional.only(end: AppPadding.p20,top: AppPadding.p50),
                          //       child: CircleAvatar(
                          //         backgroundColor: ColorManager.white,
                          //
                          //         child: IconButton(
                          //           icon: Icon(IconBroken.More_Circle,color: ColorManager.primary,),
                          //           onPressed: (){
                          //             Navigator.pop(context);
                          //           },
                          //         ),
                          //       )),
                          // ),


                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(AppPadding.p20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${productModel!.name}',style: getBoldStyle(color: ColorManager.darkGrey,fontSize: 26),
                            ),
                           const SizedBox(height: AppSize.s20,),
                            Row(

                              children: [
                                Text('Price: ',style:getSemiBoldStyle(color: ColorManager.darkGrey,fontSize: FontSize.s20)),

                                Text('${productModel!.price}LE',style:getSemiBoldStyle(color: ColorManager.primary,fontSize: FontSize.s18)),
                                if(productModel!.old_Price > 0)
                                Padding(
                                  padding: const EdgeInsetsDirectional.only(top: 7,start: 5 ),
                                  child: Text('${productModel!.old_Price}LE',
                                    style: TextStyle(color: Colors.grey,
                                        decoration: TextDecoration.lineThrough),),
                                ),
                              ],
                            ),
                            const SizedBox(height: AppSize.s20,),
                            Text('Descriptions',style:getSemiBoldStyle(color: ColorManager.darkGrey,fontSize: FontSize.s20)),
                            const SizedBox(height: AppSize.s10,),
                            Text('${productModel!.description}',
                                style:Theme.of(context).textTheme.subtitle1),




                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(20),
                child: defaultButton(onPress: (){
                 cubit.counteraddToCart=0;
                  if(cubit.listCartModel.length>0){
                    CubitLayout.get(context).listCartModel.forEach ((element) {
                      if(element.id == productModel!.id){
                       cubit. counteraddToCart=1;

                      }

                    });


                    if(cubit.counteraddToCart==0){
                      cubit.addToCart(CartModel(image: productModel!.image,
                          name:  productModel!.name,
                          price:  productModel!.price,
                          id:  productModel!.id
                      ));
                    }

                  }else
                  {
                  cubit.addToCart(CartModel(image: productModel!.image,
                      name:  productModel!.name,
                    price:  productModel!.price,
                    id:  productModel!.id
                  ));}
                  // cubit.getToCart();

                }, name: 'Add To Cart'),
              )


            ],
          ),
        );},


    );
  }


}