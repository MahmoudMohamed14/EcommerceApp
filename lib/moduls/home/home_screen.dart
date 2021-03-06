

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projectgraduate/models/category_model.dart';
import 'package:projectgraduate/moduls/addProduct/addproduct_screen.dart';
import 'package:projectgraduate/moduls/add_category/add_category_screen.dart';
import 'package:projectgraduate/moduls/category_screen/category_screen.dart';
import 'package:projectgraduate/moduls/details_screen/details_screen.dart';
import 'package:projectgraduate/moduls/layout_screen/layout_cubit/cubit_layout.dart';
import 'package:projectgraduate/moduls/layout_screen/layout_cubit/states_layout.dart';
import 'package:projectgraduate/shared/componant/componant.dart';
import 'package:projectgraduate/shared/constant/data_shared.dart';

import 'package:projectgraduate/shared/constant/fonst_manager.dart';
import 'package:projectgraduate/shared/constant/icon_broken.dart';
import 'package:projectgraduate/shared/constant/test_styles_manager.dart';
import 'package:projectgraduate/shared/network/local/cache_helper.dart';


import '../../models/product_model.dart';
import '../../shared/constant/color_manager.dart';
import '../../shared/constant/values_manager.dart';

class HomeScreen extends StatelessWidget {

  var searchController=TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CubitLayout,StateLayout>(
      listener: (context,state){},
      builder:(context,state){
        var cubit=CubitLayout.get(context);
        return ConditionalBuilder(
          condition: cubit.listAllCategory!.isNotEmpty ,//&& cubit.listAllProduct!.isNotEmpty,
          builder: (context)=>SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  defaultEditText(control: searchController,
                      label: 'Search',prefIcon: IconBroken.Search,
                      validat: (s){},onchange: (value){
                        //  cubit.listProductSearch =  cubit.listAllProduct!.where((element) => element.name!.toLowerCase().contains(value.toLowerCase())).toList();

                        cubit.search(value);
                      }),
                  const  SizedBox(height: AppSize.s20,),
                  Text('Categories',style:getSemiBoldStyle(color: ColorManager.darkGrey,fontSize: FontSize.s20)),
                  const  SizedBox(height: AppSize.s20,),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        ConditionalBuilder(
                          condition: cubit.myData !=null&&cubit.myData!.isAdmin!,
                          builder: (context)=>InkWell(
                            onTap: (){
                              navigateTo(context, AddCategoryScreen());

                            },
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: ColorManager.lightPrimary),
                                borderRadius: BorderRadius.circular(20),

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
                          fallback: ((context)=>SizedBox()),


                        ),
                        // InkWell(
                        //   onTap: (){
                        //     navigateTo(context, AddCategoryScreen());
                        //
                        //   },
                        //   child: Container(
                        //     decoration: BoxDecoration(
                        //         border: Border.all(color: ColorManager.lightPrimary)
                        //     ),
                        //     height: AppSize.s100,
                        //     width: AppSize.s100,
                        //     child: Column(
                        //       mainAxisAlignment: MainAxisAlignment.center,
                        //       children: [
                        //         Icon(IconBroken.Plus,size: AppSize.s40,),
                        //         Text("Add Category")
                        //
                        //       ],
                        //     ),
                        //   ),
                        // ),

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
                  const  SizedBox(height: AppSize.s20,),
                  Text('Products',style:getSemiBoldStyle(color: ColorManager.darkGrey,fontSize: FontSize.s20)),
                  const  SizedBox(height: AppSize.s20,),

                  buildGridProduct(searchController.text.isNotEmpty?cubit.listProductSearch:cubit.listAllProduct!,context),
                ],
              ),
            ),
          ),
          fallback:(context)=> state is GetProductLoadingState ||state is GetCategoryLoadingState?const Center(child: CircularProgressIndicator()):CacheHelper.getData(key: 'admin')?
          ( requestAdmin? Center(child: Text('Wait until your request accepted',style: Theme.of(context).textTheme.headline2,)) :Center(child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
            Text('No Product add',style: Theme.of(context).textTheme.headline2,),
            SizedBox(height: 20,),
            TextButton(onPressed: (){
              navigateTo(context, AddCategoryScreen());
            }, child: Text('Add Category',style: Theme.of(context).textTheme.headline1,)),

            Text('Or',style: Theme.of(context).textTheme.headline2,),

            TextButton(onPressed: (){
              navigateTo(context, AddProductScreen());

            }, child: Text('Add Product',style: Theme.of(context).textTheme.headline1,)),

          ],))): Center(child: Text('No item product',style: Theme.of(context).textTheme.headline2,)),



        );
      } ,

    );


  }
  static Widget buildProductItem(ProductModel productsData,context){
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
            Expanded(
              child: Stack(
                alignment: AlignmentDirectional.bottomStart,
                children: [
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),

                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage('${productsData.image??''}'))
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
                      Text('${productsData.price}',maxLines: 2,overflow: TextOverflow.ellipsis,style: TextStyle(color: ColorManager.primary)),
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
 static Widget buildGridProduct(List list,context){
    return GridView.count(
      crossAxisCount:2,
      shrinkWrap: true,
      mainAxisSpacing: AppSize.s1,
      crossAxisSpacing:AppSize.s1 ,

      childAspectRatio: 1/1.50,
      physics: const NeverScrollableScrollPhysics(),
      children: List.generate(list.length, (index) {


        return buildProductItem(list[index], context);
      }));

    // ): GridView.count(
    //   crossAxisCount:4,
    //   shrinkWrap: true,
    //   mainAxisSpacing: AppSize.s1,
    //   crossAxisSpacing:AppSize.s1 ,
    //
    //   childAspectRatio: 1/1.3,
    //   physics: const NeverScrollableScrollPhysics(),
    //   children: List.generate(list.length, (index) {
    //
    //
    //     return buildProductItem(list[index], context);
    //   }),
    //
    // );

  }
  Widget buildCategoryItem(context,CategoryModel categoryModel){
    return InkWell(
      onTap: (){
        navigateTo(context, CategoriesScreen(categoryModel: categoryModel,));
      },
      child: Container(
        decoration:BoxDecoration(
            borderRadius: BorderRadius.circular(20),) ,
        child: Stack(
          alignment: AlignmentDirectional.bottomCenter,

          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: DecorationImage(image: NetworkImage(categoryModel.image??''),

                  fit: BoxFit.cover,
                )
              ),

            ),

            Container(
              decoration: BoxDecoration(
                  color: Colors.black.withOpacity(.5),
                  borderRadius: BorderRadius.vertical(bottom:Radius.circular(20) )
              ),


                width: 100,

                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Text(
                    '${categoryModel.category}',
                    textAlign: TextAlign.center,
                    maxLines: 1,

                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.white,),
                  ),
                )
            ),
          ],
        ),
      ),
    );
  }
}
