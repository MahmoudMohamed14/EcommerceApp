import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projectgraduate/models/category_model.dart';
import 'package:projectgraduate/moduls/add_category/add_category_screen.dart';
import 'package:projectgraduate/moduls/details_screen/details_screen.dart';
import 'package:projectgraduate/moduls/layout_screen/layout_cubit/cubit_layout.dart';
import 'package:projectgraduate/moduls/layout_screen/layout_cubit/states_layout.dart';
import 'package:projectgraduate/shared/componant/componant.dart';
import 'package:projectgraduate/shared/constant/fonst_manager.dart';
import 'package:projectgraduate/shared/constant/icon_broken.dart';
import 'package:projectgraduate/shared/constant/test_styles_manager.dart';


import '../../models/product_model.dart';
import '../../shared/constant/color_manager.dart';
import '../../shared/constant/values_manager.dart';

class HomeScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CubitLayout,StateLayout>(
      listener: (context,stare){},
      builder:(context,stare){
        return Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Categories',style:getSemiBoldStyle(color: ColorManager.darkGrey,fontSize: FontSize.s20)),
                SizedBox(height: AppSize.s20,),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      InkWell(
                        onTap: (){
                          navigateTo(context, AddCategoryScreen());

                        },
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: ColorManager.lightPrimary)
                          ),
                          height: AppSize.s100,
                          width: AppSize.s100,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(IconBroken.Plus,size: AppSize.s40,),
                              Text("Add Category")

                            ],
                          ),
                        ),
                      ),

                      SizedBox(width: AppSize.s10,),

                      Container(
                        height: 100,
                        child: ListView.separated(
                            scrollDirection:Axis.horizontal ,
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (context,index)=>buildCategoryItem(context,CubitLayout.get(context).listAllCategory![index]),
                            separatorBuilder:(context,index)=>SizedBox(width: 10,),
                            itemCount: CubitLayout.get(context).listAllCategory!.length),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20,),
                Container(

                  child: GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    mainAxisSpacing: AppSize.s1,
                    crossAxisSpacing:AppSize.s1 ,
                    childAspectRatio: 1/1.50,
                    physics: NeverScrollableScrollPhysics(),
                    children: List.generate(CubitLayout.get(context).listAllProduct!.length, (index) {


                      return buildGridProduct(CubitLayout.get(context).listAllProduct![index], context);
                    }),

                  ),
                ),
              ],
            ),
          ),
        );
      } ,

    );


  }
   Widget buildGridProduct(ProductModel productsData,context){
    return InkWell(
      onTap: (){
        navigateTo(context, DetailsScreen (productsData));
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),


        ),

        child: Column(

          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              alignment: AlignmentDirectional.bottomStart,
              children: [
                Container(
                  height: 150,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),

                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage('${productsData.image!}'))
                  ),
                ),
                if(productsData.old_Price! > 0)
                  Container(

                      padding: EdgeInsets.symmetric(horizontal: 5),
                      color: Colors.red,
                      child: Text('DISCOUNT',style: TextStyle(fontSize: 10,color: Colors.white))
                  )
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${productsData.name}',maxLines: 2,overflow: TextOverflow.ellipsis,),
                  SizedBox(height: 5,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('${productsData.price}',maxLines: 2,overflow: TextOverflow.ellipsis,style: TextStyle(color: Colors.blue)),
                      SizedBox(width: 20,),
                      if(productsData.old_Price!>0)
                        Text('${productsData.old_Price}',
                          style: TextStyle(color: Colors.grey,
                              decoration: TextDecoration.lineThrough),),
                      Spacer(),
                      // IconButton(
                      //     padding: EdgeInsets.zero,
                      //
                      //     onPressed: (){
                      //       print(productsData.id);
                      //       ShopCubit.get(context).changeFavoriteShop(id: productsData.id!);
                      //
                      //     }
                      //     , icon:CircleAvatar(
                      //     backgroundColor: ShopCubit.get(context).favorite[productsData.id]!?Colors.blue:Colors.grey,
                      //     radius: 15,
                      //     child: Icon(Icons.favorite_border,color: Colors.white,)))
                    ],

                  )
                ],),
            )



          ],

        ),
      ),
    );
  }
  Widget buildCategoryItem(context,CategoryModel categoryModel){
    return Stack(
      alignment: AlignmentDirectional.bottomCenter,

      children: [
        Image(
            width: 100,
            height: 100,
            fit: BoxFit.fill,
            image: NetworkImage('${categoryModel.image}')
        ),
        Container(

            color: Colors.black.withOpacity(.7),
            width: 100,


            child: Text(
              '${categoryModel.category}',
              textAlign: TextAlign.center,
              maxLines: 1,

              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.white,),
            )
        ),
      ],
    );
  }
}
