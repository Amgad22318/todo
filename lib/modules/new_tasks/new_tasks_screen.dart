import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/layout/todo_app/cubit/cubit.dart';
import 'package:todo/layout/todo_app/cubit/states.dart';
import 'package:todo/shared/components/components.dart';


class NewTasksScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var tasks = AppCubit.get(context).newTasks;
        if (tasks.length > 0) {
          return ListView.separated(
              itemBuilder: (context, index) =>
                  buildTaskItem(tasks[index], context),
              separatorBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Container(
                      color: Colors.grey[300],
                      height: 1,
                      width: double.infinity,
                    ),
                  ),
              itemCount: tasks.length);
        } else {
          Animation<double> progress;
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                  child: Icon(
                Icons.list_rounded,
                color: Colors.grey,
                size: 120,
              )),
              Text(
                'No Tasks Yet, Please Add Some Tasks',
                style:
                    TextStyle(color: Colors.grey, fontWeight: FontWeight.bold,wordSpacing: 8),
              )
            ],
          );
        }
      },
    );
  }
}
