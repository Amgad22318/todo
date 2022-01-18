import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo/layout/todo_app/cubit/states.dart';
import 'package:todo/modules/archived_tasks/archived_tasks_screen.dart';
import 'package:todo/modules/done_tasks/done_tasks_screen.dart';
import 'package:todo/modules/new_tasks/new_tasks_screen.dart';


class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;
  List<Widget> screens = [
    NewTasksScreen(),
    DoneTasksScreen(),
    ArchivedTasksScreen()
  ];
  List<String> titles = ['New Tasks', 'Done Tasks', 'Archived Tasks'];

  void indexChange(index) {

    currentIndex = index;

    emit(AppChangeBottomNavBarState());
  }

  // void indexChangeScroll(index) {
  //   pageController.jumpToPage(index)
  //   currentIndex = index;
  //   emit(AppChangeBottomNavBarState());
  // }

  late Database dataBase;
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];

  void createDatabase() {
    openDatabase(
      'todo.db',
      version: 1,
      onCreate: (database, version) {
        print('database created');
        database
            .execute(
                'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)')
            .then((value) {
          print('table created');
        }).catchError((error) {
          print('error while creating table ${error.toString()}');
        });
      },
      onOpen: (dataBase) {
        getTasksFromDatabase(dataBase);
        print('table opened');
      },
    ).then((value) {
      dataBase = value;
      emit(AppCreateDatabaseState());
    });
  }

  void getTasksFromDatabase(database) {
    newTasks = [];
    doneTasks = [];
    archivedTasks = [];
    database.rawQuery('SELECT * FROM tasks').then((value) {
      value.forEach((element) {
        if (element['status'] == 'new') {
          newTasks.add(element);
        } else if (element['status'] == 'done') {
          doneTasks.add(element);
        } else {
          archivedTasks.add(element);
        }
      });

      emit(AppGetDatabaseState());
    });
  }

  Future insertToDatabase({
    required String title,
    required String time,
    required String date,
  }) async {
    return await dataBase.transaction((txn) async {
      txn
          .rawInsert(
              'INSERT INTO tasks(title, date, time, status) VALUES("$title", "$date", "$time", "new")')
          .then((value) {
        print('$value inserted successfully');
        emit(AppInsertDatabaseState());

        getTasksFromDatabase(dataBase);
      }).catchError((error) {
        print(' error when inserting new record ${error.toString()}');
      });
    });
  }

  bool isBottomSheetShown = false;
  IconData fabIcon = Icons.edit;

  void changeBottomSheetState({required bool isShow, required IconData icon}) {
    isBottomSheetShown = isShow;
    fabIcon = icon;
    emit(AppChangeBottomSheetState());
  }

  void updateData({required String status, required int id}) {
    dataBase.rawUpdate('UPDATE tasks SET status = ? where id = ?',
        ['$status', id]).then((value) {
      getTasksFromDatabase(dataBase);
      emit(AppUpdateDatabaseState());
    });
  }

  void deleteData({ required int id}) {
    dataBase.rawDelete('DELETE FROM tasks where id = ?',
        [id]).then((value) {
      getTasksFromDatabase(dataBase);
      emit(AppDeleteDatabaseState());
    });
  }
}
