import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:projectgraduate/models/order_model.dart';
import 'package:projectgraduate/moduls/layout_screen/layout_cubit/cubit_layout.dart';
import 'package:projectgraduate/moduls/layout_screen/layout_cubit/states_layout.dart';
import 'package:projectgraduate/shared/componant/componant.dart';
import 'package:projectgraduate/shared/constant/icon_broken.dart';

class CheckOutScreen extends StatelessWidget {

  var titleController=TextEditingController();
  var notesController=TextEditingController();
  var keyForm=GlobalKey<FormState>();

  List<Map<String,dynamic>>? product=[];


  CheckOutScreen({ this.product});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CubitLayout,StateLayout>(
      listener: (context,state){},
      builder:(context,state){
        var cubit=CubitLayout.get(context);
        return  Scaffold(
          appBar: AppBar(title: Text('CheckOut'),),
          body: Padding(

            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: keyForm,
              child: Column(
                children: [
                  defaultEditText(control: titleController, label: 'Your Title ', validat: (s){
                    if(s!.isEmpty){

                      return'Title Empty';
                    }
                    return null;

                  },prefIcon: IconBroken.Location,textType: TextInputType.text),
                  SizedBox(height: 20,),
                  defaultEditText(control: notesController, label: 'Note ', validat: (s){
                    // if(s!.isEmpty){
                    //   return'Note Empty';
                    // }
                    // return null;

                  },maxLine: null,prefIcon: IconBroken.Document),
                  SizedBox(height: 20,),
                  defaultButton(onPress: (){
                   cubit.addOrder(
                     OrderModel(
                       time: TimeOfDay.now().format(context),
                       customerId: cubit.myData!.id,
                       customerName: cubit.myData!.name,
                       customerNote: notesController.text,
                       customerPhone: cubit.myData!.phone,
                       customerTitle: titleController.text,
                       date: DateFormat.yMMMd().format(DateTime.now()),
                       orderId: cubit.getRandomString(5).toLowerCase(),
                       orderProducts: cubit.listProductOfOrder,
                       totalPrice: cubit.calculateTotalChecke().toString()


                     )

                   );


                   // cubit.addOrder(OrderModel(time: TimeOfDay.now()))


                  }, name: 'Submit')


                ],
              ),
            ),
          ),
        );
      } ,

    );
  }
}
