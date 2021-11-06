import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/shared/components.dart';
import 'package:todo_app/shared/cubit/cubit.dart';
import 'package:todo_app/shared/cubit/states.dart';

class ArchivedTasksScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit , AppStates>(
      listener: (context , state){},
      builder: (context , state){

        var tasks = AppCubit.get(context).archivedTasks;

        return ListView.separated(
            itemBuilder: (context,index) => buildItems(tasks[index],context),
            separatorBuilder:(context,index) => Container(
              width: double.infinity,
              height: 1,
              color: Colors.grey,
            ),
            itemCount:tasks.length
        );
      },
    );
  }
}
