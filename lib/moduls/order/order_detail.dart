


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projectgraduate/models/cart_model.dart';
import 'package:projectgraduate/models/order_model.dart';
import 'package:projectgraduate/moduls/layout_screen/layout_cubit/cubit_layout.dart';
import 'package:projectgraduate/moduls/layout_screen/layout_cubit/states_layout.dart';
import 'package:projectgraduate/shared/componant/componant.dart';
import 'package:projectgraduate/shared/constant/color_manager.dart';
import 'package:projectgraduate/shared/constant/fonst_manager.dart';
import 'package:projectgraduate/shared/constant/icon_broken.dart';
import 'package:projectgraduate/shared/constant/test_styles_manager.dart';
import 'package:projectgraduate/shared/constant/values_manager.dart';
import 'package:projectgraduate/shared/network/local/cache_helper.dart';

class OrderDetails extends StatelessWidget {
  OrderModel? orderModel;
  List<CartModel>listcat=[];

  OrderDetails({this.orderModel});


  @override
  Widget build(BuildContext context) {
    orderModel!.orderProducts!.forEach((element) {
      if(CacheHelper.getData(key: 'admin')){
        if(element['adminId']==CacheHelper.getData(key: 'uId')){
          listcat.add(CartModel.fromJson(element));
        }


      }else{
        listcat.add(CartModel.fromJson(element));
      }


    });
    return BlocConsumer<CubitLayout,StateLayout>(
        listener: (context,state){
          if(state is CancelOrderSuccessState ||state is DoneOrderSuccessState){
            Navigator.pop(context);
          }
        },
    builder:(context,state){
    var cubit=CubitLayout.get(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('OrderDetails'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //order id and date
              Row(
                children: [
                  Row(
                    children: [
                      Text('OrderId: ',style: Theme.of(context).textTheme.headline1,),
                      Text('${orderModel!.orderId}',style: Theme.of(context).textTheme.headline2,),
                    ],
                  ),
                  Spacer(),
                  Text('${orderModel!.date}',style: Theme.of(context).textTheme.headline2,),

                ],

              ),
              SizedBox(height: 20,),
              //product
              ListView.separated(
                shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context,index)=>productOrderBuildItem(context,listcat[index]),
                  separatorBuilder: (context,index)=>SizedBox(height: AppSize.s10,),
                  itemCount:listcat.length),
              SizedBox(height: 20,),
              //total price
              Row(
                children: [
                  Text('Total Price: ',style: Theme.of(context).textTheme.headline1,),
                  Text('${orderModel!.totalPrice}LE',style: Theme.of(context).textTheme.headline2,),
                ],
              ),
              SizedBox(height: 20,),
              //customer information
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Delivery To ',style: Theme.of(context).textTheme.headline2,),
                  Row(

                    children: [
                      Icon(IconBroken.Edit),
                      Text('${orderModel!.customerName } ',style:getSemiBoldStyle(color: ColorManager.darkGrey,fontSize: FontSize.s16),),
                    ],
                  ),
                  SizedBox(height: 10,),
                  Row(

                    children: [

                      Icon(IconBroken.Location),

                      Text('${orderModel!.customerTitle }',style:getSemiBoldStyle(color: ColorManager.darkGrey,fontSize: FontSize.s16),),

                    ],
                  ),
                  SizedBox(height: 10,),
                  Row(

                    children: [
                      Icon(Icons.phone),
                      Text('${orderModel!.customerPhone }',style:getSemiBoldStyle(color: ColorManager.darkGrey,fontSize: FontSize.s16),),
                      Spacer(),
                      Text('Status ',style: Theme.of(context).textTheme.headline1,),
                      Text('${orderModel!.orderState} ',style:getSemiBoldStyle(color: ColorManager.darkGrey,fontSize: FontSize.s16),),

                    ],
                  ),

                ],),

              orderModel!.customerNote!.isNotEmpty?  Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20,),
                  Text('Note: ',style: Theme.of(context).textTheme.headline1!.copyWith(color: Colors.red),),
                  Text(' ${orderModel!.customerNote} ',style:getSemiBoldStyle(color: ColorManager.darkGrey,fontSize: FontSize.s16),),

                ],): SizedBox(),
              SizedBox(height: 20,),
          if(orderModel!.orderState =='Pending') cubit.myData!.isAdmin!?defaultButton(onPress: (){
           cubit. cancelOrder(orderModel!.orderId!);
          }, name: 'cancel'): Row(

            children: [
                Expanded(child: defaultButton(onPress: (){
                  cubit.clickDoneOrder(orderModel!.orderId!);
                }, name: 'Done')),
                SizedBox(width: 20,),

                Expanded(child: defaultButton(onPress: (){
                  cubit. cancelOrder(orderModel!.orderId!);
                }, name: 'cancel')),

              ],)



            ],
          ),
        ),
      ),
    );
    });
  }

  Widget productOrderBuildItem(context,CartModel cartModel){
    return Container(
      padding: EdgeInsets.all(10),
      color: ColorManager.grey.withOpacity(.2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 90,
            width: 100,
            decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.fill,
                    image: NetworkImage('${cartModel.image!}'))

            ),
          ),
         const SizedBox(width: 20,),
          Expanded(

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${cartModel.name}',style: Theme.of(context).textTheme.headline2,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 20,),
                Row(
                  children: [
                    Text('${cartModel.quantity}',style: Theme.of(context).textTheme.headline2,),
                    Spacer(),
                    Text('${cartModel.price * cartModel.quantity} LE',style: Theme.of(context).textTheme.headline2,),
                  ],
                ),

              ],),
          ),


        ],
      ),
    );
  }

}