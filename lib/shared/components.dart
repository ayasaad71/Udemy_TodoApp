import 'package:flutter/material.dart';
import 'package:todo_app/shared/cubit/cubit.dart';

Widget buildItems (Map model , context) => Dismissible(
  key: Key(model['id'].toString()),
  child:   Padding(
    padding: const EdgeInsets.all(20),
    child: Row(
      children: [
        CircleAvatar(
          child: Text(
            '${model['time']}'
          ),
          radius: 40,
        ),
        SizedBox(width: 20,),
        Expanded(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('${model['title']}',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                Text('${model['data']}',style: TextStyle(fontSize: 15,color: Colors.grey),),
              ],
            ),
        ),
        SizedBox(width: 20,),
        IconButton(
          onPressed: (){
            AppCubit.get(context).updateData(status: 'done', id: model['id']);
          },
          icon:Icon (Icons.check_box),
          color: Colors.green,
        ),
        SizedBox(width: 20,),
        IconButton(
          onPressed: (){
          AppCubit.get(context).updateData(status: 'archived', id: model['id']);
          },
          icon:Icon (Icons.archive),
          color: Colors.black45,
        ),

      ],
    ),
  ),
  onDismissed:(direction){
    AppCubit.get(context).deleteDate(id: model['id']);
  },
);