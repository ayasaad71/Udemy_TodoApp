import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/modules/archived_tasks_screen.dart';
import 'package:todo_app/modules/done_tasks_screen.dart';
import 'package:todo_app/modules/new_tasks_screen.dart';
import 'package:todo_app/shared/cubit/states.dart';

class AppCubit extends Cubit<AppStates>{

  AppCubit() : super(InitState());

  static AppCubit get(context) => BlocProvider.of(context);


  int currentIndex = 0 ;

  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];

  List <String> titles = [
    'New Tasks',
    'Done Tasks',
    'Archived Tasks'
  ];

  List screens = [
    NewTasksScreen(),
    DoneTasksScreen(),
    ArchivedTasksScreen(),
  ];

  void changeIndex (int index) {
    currentIndex = index ;
    emit(AppChangeBotNavBarState());
  }

  late Database database ;

  void createDatabase()
  {
     openDatabase
      (
      'todo.db',
      version: 1,
      onCreate: (Database database,int version)
      {
        print('database created');
        database.execute('CREATE TABLE TASKS (id INTEGER PRIMARY KEY, title TEXT , time TEXT,data TEXT ,status TEXT)').then((value) {
          print('table created');
        }).catchError((error){
          print('error is ${error.toString()}');
        });
      },
      onOpen: (Database database){
        print('database opened');
        getDataFromDatabase(database);

      },
    ).then((value) {
      database = value ;
      emit(AppCreateDatabaseState());
     });
  }

  insertToDatabase ({
    required String title,
    required String time,
    required String data
  }) async
  {
    await database.transaction((txn) async{
      txn.rawInsert('INSERT INTO tasks(title,time,data,status) VALUES("$title","$time","$data","new")')
          .then((value) {
        print('$value inserted successfully');
        emit(AppInsertToDatabaseState());

        getDataFromDatabase(database).then((value) {
          newTasks = value;
          print(newTasks);
          emit(AppGetDatabaseState());
        });
      })
          .catchError((error){
        print('error is ${error.toString()}');
      });
      return null ;
    });
  }

  getDataFromDatabase(database) async
  {
    newTasks = [];
    doneTasks = [];
    archivedTasks = [];

    emit(AppLoadingState());

    database.rawQuery('SELECT * FROM TASKS').then((value) {

      value.forEach((element){
        if (element['status'] == 'new'){
          newTasks.add(element);
        }
        else if (element['status'] == 'done'){
          doneTasks.add(element);
        }
        else {
          archivedTasks.add(element);
        }
      });
      emit(AppGetDatabaseState());
    });
  }

  void updateData({
    required String status ,
    required int id
  }) async
  {
    database.rawUpdate(
        'UPDATE tasks SET status = ? WHERE id = ?',
        ['$status' , id]
    ).then((value){
      getDataFromDatabase(database);
      emit(AppUpdateDatabaseState());
    });
  }

  void deleteDate({required int id}){
    database.rawDelete('DELETE FROM tasks WHERE id = ?', [id]).then((value) {
      getDataFromDatabase(database);
      emit(AppDeleteDatabaseState());
    });
  }

  bool isButtonShown = false ;
  IconData fidIcon = Icons.edit;

  void changeButtonSheet({
  required bool isShow ,
  required IconData icon
})
  {
    isButtonShown = isShow ;
    fidIcon = icon ;

    emit(AppChangeButtonSheetState());
  }

}