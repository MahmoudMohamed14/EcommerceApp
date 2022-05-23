import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projectgraduate/models/cart_model.dart';
import 'package:projectgraduate/moduls/check_out/checkout_screen.dart';
import 'package:projectgraduate/moduls/layout_screen/layout_cubit/cubit_layout.dart';
import 'package:projectgraduate/moduls/layout_screen/layout_cubit/states_layout.dart';
import 'package:projectgraduate/shared/componant/componant.dart';
import 'package:projectgraduate/shared/constant/color_manager.dart';
import 'package:projectgraduate/shared/constant/fonst_manager.dart';
import 'package:projectgraduate/shared/constant/test_styles_manager.dart';
import 'package:projectgraduate/shared/constant/values_manager.dart';

class CartScreen extends StatelessWidget {





  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CubitLayout, StateLayout>(
      listener: (context, state) {
        if(state is DeleteItemCartSuccessState){
          showToast(text: 'Delete Successfully', state: ToastState.SUCCESS);
        }

      },
      builder: (context, state) {
        var cubit = CubitLayout.get(context);
        return Padding(
          padding: const EdgeInsets.all(AppPadding.p20),
          child:Column(
            children: [
              Expanded(
                child: ListView.separated(itemBuilder: (context,index){
                  return  buildCartItem(context, index,cubit.listCartModel[index]);
                }
                    , separatorBuilder: (context,index){return const SizedBox(height: 20,);},
                    itemCount: cubit.listCartModel.length),
              ),
            if(cubit.listCartModel.length >0)  Row(

                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Text("Total: ",style: Theme.of(context).textTheme.headline1,),
                        Text("${cubit.calculateTotalCheck()}",style: Theme.of(context).textTheme.headline2,)
                      ],
                    ),
                  ),
                  Expanded(child: defaultButton(onPress: (){

                   navigateTo(context, CheckOutScreen());
                  }, name: 'check out'))
                ],
              )
            ],
          ),
        );
      },


    );
  }
  Widget buildCartItem(context,int index,CartModel cartModel){
    return Dismissible(
      key: UniqueKey(),
      onDismissed: (dismissed){
        CubitLayout.get(context).deleteItemfromCart(cartModel);
      },
      child: Container(
        width: double.infinity,
        height: 120,
        decoration: BoxDecoration(
            color: ColorManager.grey.withOpacity(.2),
            borderRadius: BorderRadius.circular(20)
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
                height: 120,
                width: 120,


                decoration: BoxDecoration(
                    borderRadius: BorderRadius.horizontal(left: Radius.circular(20)),
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage('${cartModel.image}'))
                )
            ),
            const   SizedBox(width: 20,),

            Expanded(

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const   SizedBox(height: 10,),
                  Expanded(
                    child: Text('${cartModel.name}',style:getSemiBoldStyle(color: ColorManager.darkGrey,fontSize: FontSize.s20), maxLines: 1,
                      overflow:TextOverflow.ellipsis,
                    ),
                  ),

                  Expanded(
                    child: Text('${cartModel.price}',style:getSemiBoldStyle(color: ColorManager.primary,fontSize: FontSize.s18), maxLines: 1,
                      overflow:TextOverflow.ellipsis,
                    ),
                  ),

                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap:(){
                            if(cartModel.quantity > 1){
                            CubitLayout.get(context).updateToCart(
                                CartModel(
                                    id: cartModel.id
                                    ,name: cartModel.name,
                                    price: cartModel.price,
                                    image: cartModel.image,
                                    quantity: cartModel.quantity-1,
                                  adminId: cartModel.adminId

                                ), index);
                            }
                          } ,
                          child: CircleAvatar(

                            child:Text('-',style:getBoldStyle(color: ColorManager.white,fontSize: FontSize.s20)) ,
                            radius:17 ,
                          ),
                        ),
                        SizedBox(width: 10,),
                        Text('${cartModel.quantity}',style: getBoldStyle(color: ColorManager.darkGrey,fontSize: FontSize.s20),),
                        SizedBox(width: 20,),
                        GestureDetector(
                          onTap: (){


                          CubitLayout.get(context).updateToCart(
                              CartModel(
                                  id: cartModel.id
                              ,name: cartModel.name,
                                price: cartModel.price,
                                image: cartModel.image,
                                quantity: cartModel.quantity+1,
                                  adminId: cartModel.adminId
                          ), index);

                          },

                          child: CircleAvatar(

                            child:Text('+',style:getBoldStyle(color: ColorManager.white,fontSize: FontSize.s20)) ,
                            radius:17 ,
                          ),
                        ),

                      ],),
                  ),
                  const   SizedBox(height: 10,),


                ],
              ),
            ),
            const   SizedBox(width: 10,),


          ],
        ),


      ),
    );
  }
}