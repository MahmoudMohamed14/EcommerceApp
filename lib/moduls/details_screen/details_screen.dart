import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projectgraduate/models/cart_model.dart';
import 'package:projectgraduate/models/product_model.dart';
import 'package:projectgraduate/moduls/layout_screen/layout_cubit/cubit_layout.dart';
import 'package:projectgraduate/moduls/layout_screen/layout_cubit/states_layout.dart';
import 'package:projectgraduate/shared/componant/componant.dart';
import 'package:projectgraduate/shared/constant/color_manager.dart';
import 'package:projectgraduate/shared/constant/fonst_manager.dart';
import 'package:projectgraduate/shared/constant/icon_broken.dart';
import 'package:projectgraduate/shared/constant/test_styles_manager.dart';
import 'package:projectgraduate/shared/constant/values_manager.dart';

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
      },
      builder:(context,state){
        var cubit=CubitLayout.get(context);
        return Scaffold(
          //appBar: AppBar(title: Text('Details'),),
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
                          Padding(
                            padding: EdgeInsetsDirectional.only(start: AppPadding.p20,top: AppPadding.p50),
                            child: CircleAvatar(
                              backgroundColor: ColorManager.lightGrey.withOpacity(.4),

                              child: IconButton(
                                  icon: Icon(IconBroken.Arrow___Left,color: ColorManager.primary,),
                                onPressed: (){
                                    Navigator.pop(context);
                                },
                              ),
                            )),
                          Align(
                            alignment: AlignmentDirectional.bottomEnd,
                            child: Padding(
                                padding: EdgeInsetsDirectional.only(end: AppPadding.p20,top: AppPadding.p50),
                                child: CircleAvatar(
                                  backgroundColor: ColorManager.white,

                                  child: IconButton(
                                    icon: Icon(IconBroken.More_Circle,color: ColorManager.primary,),
                                    onPressed: (){
                                      Navigator.pop(context);
                                    },
                                  ),
                                )),
                          ),


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