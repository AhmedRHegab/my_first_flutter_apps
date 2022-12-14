
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:untitled/shared/cubit_todo/states.dart';
import 'package:untitled/shared/network/local/cache_helper.dart';
import '../../modules/todo_app/archived_tasks/archived_tasks_screen.dart';
import '../../modules/todo_app/done_tasks/done_tasks_screen.dart';
import '../../modules/todo_app/new_tasks/new_tasks_screen.dart';

class AppCubit extends Cubit<AppStates>
{
  AppCubit() :  super(AppInitialState());
  static AppCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;
  List<Widget> screens = [
    const NewTasksScreen(),
    const DoneTasksScreen(),
    const ArchivedTasksScreen(),

  ];

  List<String> titles = [
    'New Tasks',
    'Done Tasks',
    'Archived Tasks',
  ];

  void changeIndex(int index)
  {
    currentIndex = index;
    emit(AppChangeBottomNavBarState());
  }


  late Database database;
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];

  void createDatabase()
  {
     openDatabase(
      'todo.db',
      version: 1,
      onCreate: (database, version)
      {
        // id integer
        // title string
        // date string
        // time string
        // status string

        print('database created');
        database.execute('CREATE TABLE tasks (id INTEGER PRIMARY KEY,title TEXT,date TEXT,time TEXT,status TEXT)').then((value) {
          print('table created ');
        }).catchError((error){
          print('Error When Creating Table ${error.toString()}');
        });



      },
      onOpen: (database)
      {
        getDataFromDatabase(database);

        print('database opened');
      },
    ).then((value) {
      database = value;
      emit(AppCreateDatabaseState());
     });
  }

   insertToDatabase({
    required String title,
    required String time,
    required String date,
  }) async
  {
    await database.transaction((txn) async {
      return txn.rawInsert(
          'INSERT INTO tasks(title, date, time, status) VALUES("$title", "$date", "$time", "new")'
      ).then((value)
      {
        print('$value inserted successfully');
        emit(AppInsertDatabaseState());

        getDataFromDatabase(database);

      }).catchError((error){
        print('Error When Inserting New Record ${error.toString()}');
      });

    });
  }

 void getDataFromDatabase(database)
  {
    // to make them empty before getting.
    newTasks = [];
    doneTasks = [];
    archivedTasks = [];
    emit(AppGetDatabaseLoadingState());

    database!.rawQuery('SELECT * FROM tasks').then((value) {


      value.forEach((element)
      {
        if (element['status'] == 'new')
        {
          newTasks.add(element);
        }
        else if (element['status'] == 'done')
        {
          doneTasks.add(element);
        }
        else if (element['status'] == 'archive')
        {
          archivedTasks.add(element);
        }

      });

      emit(AppGetDatabaseState());
    });

  }

  void updateData({
  required String status,
    required int id,
}) async
  {
    await database.rawUpdate(
      'UPDATE tasks SET status = ?  WHERE id = ?',
      [status, id],
    ).then((value)
     {
       getDataFromDatabase(database);
       emit(AppUpdateDatabaseState());

     });
  }

  void deleteData({
    required int id,
  }) async
  {
    await database.rawDelete(
      'DELETE FROM tasks WHERE  id = ?',
      [id],
    ).then((value)
    {
      getDataFromDatabase(database);
      emit(AppDeleteDatabaseState());

    });
  }

  bool isBottomSheetShown = false;
  IconData fabIcon = Icons.edit;

  void changeButtonSheetState({
  required bool isShow,
    required IconData icon,
})
  {
    isBottomSheetShown = isShow;
    fabIcon = icon;
    emit(AppChangeBottomSheetState());
  }

  bool isDark = false;


  void changeAppMode({bool? fromShared})
  {

    if(fromShared != null)
      {
        isDark = fromShared;
        emit(AppChangeModeState());
      }else
        {
          isDark = !isDark;
          CacheHelper.putBoolean(
            key: 'isDark',
            value: isDark,
          ).then((value) {
            emit(AppChangeModeState());
          });
        }

  }

}

