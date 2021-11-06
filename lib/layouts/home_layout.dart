import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/shared/cubit/cubit.dart';
import 'package:todo_app/shared/cubit/states.dart';


class HomeLayout extends StatelessWidget  {

  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dataController = TextEditingController();
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();


  // {Future - async - await}
  // Future => datatype for method
  // async => create thread in background
  // await => wait data returned from future method

  Future <String> getName() async
  {
    return 'Aya Saad';
  }


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDatabase(),
      child: BlocConsumer <AppCubit , AppStates>(
        listener: (BuildContext context , AppStates state) {
          if(state is AppInsertToDatabaseState){
            Navigator.pop(context);
          }
        },
        builder: (BuildContext context , AppStates state) {

          AppCubit cubit = AppCubit.get(context);
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title: Text(cubit.titles[cubit.currentIndex],style: TextStyle(fontSize: 25),),
            ),
            body: cubit.screens[cubit.currentIndex] , //tasks.length == 0 ? Center(child: CircularProgressIndicator()) :
            floatingActionButton: FloatingActionButton(
              onPressed: () // future method that placed in another method, this method must be future also
              {
                //first method for handling error.
                // use async in onpressed
                // try{
                //   var name = await getName(); لو الفانكشن دى بتاخد وقت طويل عشان تتنفذ الطريقة دى لا تضمن ان 1 تتنفذ قبل 2 وده ممكن يعملى مشكلة فى البرنامج
                //   print(name);  --1
                //   print('Alaa saad') --2
                //
                //   throw{print('I made an error by myself')};
                //
                // }catch(error){
                //   print('error is ${error.toString()}');
                // }

                //second method for handling an error.
                // no need to use async in onpressed function.
                // getName().then((value) {       // الطريقة دى بتضمن ان 1 يتنفذ قبل 2 عشان ميحصلش مشكلة فى البرنامج
                //   print(value);  //1
                //   print('Alaa Saad');  //2
                //   throw('I made error');
                // }).catchError((error){
                //   print('error is ${error.toString()}');
                // });
                if (cubit.isButtonShown){

                  if(formKey.currentState!.validate()) {
                    cubit.insertToDatabase(
                        title: titleController.text,
                        time: timeController.text,
                        data: dataController.text
                    );
                    // insertToDatabase(
                    //   title: titleController,
                    //   time: timeController,
                    //   data: dateController,
                    // ).then((value) {
                    //   Navigator.pop(context);
                    //   //   setState(() {
                    //   //     fidIcon = Icons.edit;
                    //   //   });
                    //   isButtonShown = false;
                    // },
                    // );
                  }
                }
                else{
                  scaffoldKey.currentState!.showBottomSheet((context) =>
                      Container(
                        padding:EdgeInsets.all(15),
                        color: Colors.grey[100],
                        child: Form(
                          key: formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextFormField(
                                controller: titleController,  // وظيفة الكنترولر انى امسك او احصل على القيمة اللى اتكتبت او ادى قيمة محددة ل textFormField
                                keyboardType: TextInputType.text,
                                onTap: (){
                                  print('tapped');
                                },
                                validator: (value){
                                  if(value!.isEmpty){
                                    return 'Title must not be empty';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.title),
                                    labelText: 'Title',
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))
                                ),
                              ),
                              SizedBox(height: 10,),
                              TextFormField(
                                controller: timeController,
                                keyboardType: TextInputType.datetime,
                                onTap: (){
                                  showTimePicker(context: context, initialTime:TimeOfDay.now()).then((value) {
                                    timeController.text = value!.format(context).toString();
                                    print(value.format(context));
                                  });
                                },
                                validator: (value){
                                  if(value!.isEmpty){
                                    return 'Time must not be empty';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.watch_later_outlined),
                                    labelText: 'Time',
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))
                                ),
                              ),

                              SizedBox(height: 10,),

                              TextFormField(
                                controller: dataController,
                                keyboardType: TextInputType.datetime,
                                onTap: (){
                                  showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime.parse('2022-10-05'),
                                  ).then((value) {
                                    dataController.text = DateFormat.yMMMd().format(value!);
                                  });
                                },
                                validator: (value){
                                  if(value!.isEmpty){
                                    return 'Date must not be empty';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.calendar_today),
                                    labelText: 'Date',
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))
                                ),
                              )

                            ],
                          ),
                        ),
                      ),
                  ).closed.then((value) {
                    cubit.changeButtonSheet(isShow: false, icon:Icons.edit );
                  });

                  cubit.changeButtonSheet(isShow: true, icon:Icons.add );
                }
              },
              child: Icon(cubit.fidIcon),
            ),

            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              elevation: 15,
              currentIndex: cubit.currentIndex,
              items: [
                BottomNavigationBarItem(icon:Icon( Icons.menu,size: 30,),label: 'Tasks'),
                BottomNavigationBarItem(icon:Icon( Icons.done,size: 30),label: 'Done'),
                BottomNavigationBarItem(icon:Icon( Icons.archive_outlined,size: 30),label: 'Archived')
              ],
              onTap: (index){
                cubit.changeIndex(index);
              },
            ),
          );
        },
      ),
    );
  }


}


