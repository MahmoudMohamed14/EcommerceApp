import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projectgraduate/models/order_model.dart';
import 'package:projectgraduate/moduls/layout_screen/layout_cubit/cubit_layout.dart';
import 'package:projectgraduate/moduls/layout_screen/layout_cubit/states_layout.dart';
import 'package:projectgraduate/moduls/order/order_detail.dart';
import 'package:projectgraduate/shared/componant/componant.dart';
import 'package:projectgraduate/shared/constant/color_manager.dart';
import 'package:projectgraduate/shared/constant/values_manager.dart';

class OrderScreen extends StatelessWidget {




  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CubitLayout,StateLayout>(
        listener: (context,state){},
        builder:(context,state){
          var cubit=CubitLayout.get(context);
          return Padding(
            padding: const EdgeInsets.all(20),
            child:TabBarView(
              children: [
                ListView.separated(
                    itemBuilder: (context,index)=>orderBuildItem(context,cubit.listPendingOrder[index]),
                    separatorBuilder:(context,index)=>SizedBox(height: 20),
                    itemCount: cubit.listPendingOrder.length),
                ListView.separated(
                    itemBuilder: (context,index)=>orderBuildItem(context,cubit.listDoneOrder[index]),
                    separatorBuilder:(context,index)=>SizedBox(height: 20),
                    itemCount: cubit.listDoneOrder.length),
                ListView.separated(
                    itemBuilder: (context,index)=>orderBuildItem(context,cubit.listCancelOrder[index]),
                    separatorBuilder:(context,index)=>SizedBox(height: 20),
                    itemCount: cubit.listCancelOrder.length),
              ],
            ) ,
          );
        });
  }



Widget orderBuildItem(context,OrderModel orderModel){
    return  GestureDetector(
      onTap: (){

        navigateTo(context, OrderDetails(orderModel: orderModel,));
      },
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: ColorManager.grey.withOpacity(.2)

        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //order id and date
            Row(
              children: [
                Row(
                  children: [
                    Text('OrderId: ',style: Theme.of(context).textTheme.headline1,),
                    Text('${orderModel.orderId}',style: Theme.of(context).textTheme.headline2,),
                  ],
                ),
                Spacer(),
                Text('${orderModel.date}',style: Theme.of(context).textTheme.headline2,),

              ],

            ),
            const SizedBox(height: AppSize.s20,),
            Row(
              children: [
                Text('Total',style: Theme.of(context).textTheme.headline1,),
                Spacer(),
                Text('${orderModel.totalPrice}',style: Theme.of(context).textTheme.headline2,),

              ],

            ),
           if(CubitLayout.get(context).myData!.isAdmin!) Column(
              children: [
                const SizedBox(height: AppSize.s20,),
                Row(
                  children: [
                    Text('Delivery to',style: Theme.of(context).textTheme.headline1,),
                    Spacer(),

                    Text('${orderModel.customerName} ',
                      style: Theme.of(context).textTheme.headline2,

                      overflow: TextOverflow.ellipsis,
                    ),

                  ],

                ),
              ],
            ),
            const SizedBox(height: AppSize.s20,),
            Row(
              children: [
                Text('Status',style: Theme.of(context).textTheme.headline1,),
                Spacer(),
                Text('${orderModel.orderState}',style: Theme.of(context).textTheme.headline2,),

              ],

            ),





          ],
        ),
      ),
    );
}

}