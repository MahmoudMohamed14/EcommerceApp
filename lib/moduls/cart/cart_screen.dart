import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projectgraduate/moduls/layout_screen/layout_cubit/cubit_layout.dart';
import 'package:projectgraduate/moduls/layout_screen/layout_cubit/states_layout.dart';
import 'package:projectgraduate/shared/constant/color_manager.dart';
import 'package:projectgraduate/shared/constant/fonst_manager.dart';
import 'package:projectgraduate/shared/constant/icon_broken.dart';
import 'package:projectgraduate/shared/constant/test_styles_manager.dart';
import 'package:projectgraduate/shared/constant/values_manager.dart';

class CartScreen extends StatelessWidget {





  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CubitLayout, StateLayout>(
      listener: (context, state) {

      },
      builder: (context, state) {
        var cubit = CubitLayout.get(context);
        return Padding(
          padding: const EdgeInsets.all(AppPadding.p20),
          child:buildCartItem(context),
        );
      },


    );
  }
  Widget buildCartItem(context){
    return Container(
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
                      image: NetworkImage('${CubitLayout.get(context).listAllProduct![1].image}'))
              )
          ),
          const   SizedBox(width: 20,),

          Expanded(

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Price: ',style:getSemiBoldStyle(color: ColorManager.darkGrey,fontSize: FontSize.s20), maxLines: 1,
                  overflow:TextOverflow.ellipsis,
                ),
                const   SizedBox(height: 10,),
                Text('247 LE',style:getSemiBoldStyle(color: ColorManager.primary,fontSize: FontSize.s18), maxLines: 1,
                  overflow:TextOverflow.ellipsis,
                ),
                SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap:(){
                        print('print');
                      } ,
                      child: CircleAvatar(

                        child:Text('-',style:getBoldStyle(color: ColorManager.white,fontSize: FontSize.s20)) ,
                        radius:17 ,
                      ),
                    ),
                    SizedBox(width: 10,),
                    Text('1',style: getBoldStyle(color: ColorManager.darkGrey,fontSize: FontSize.s20),),
                    SizedBox(width: 20,),
                    GestureDetector(
                      onTap: (){},

                      child: CircleAvatar(

                        child:Text('+',style:getBoldStyle(color: ColorManager.white,fontSize: FontSize.s20)) ,
                        radius:17 ,
                      ),
                    ),

                  ],)

              ],
            ),
          )


        ],
      ),


    );
  }
}