import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todo/layout/todo_app/cubit/states.dart';
import 'package:todo/shared/components/components.dart';

import 'cubit/cubit.dart';


class HomeLayout extends StatelessWidget {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();

  var titleFormFieldController = TextEditingController();
  var timeFormFieldController = TextEditingController();
  var dateFormFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (BuildContext context, state) {
          if (state is AppInsertDatabaseState) {
            Navigator.pop(context);
          }
        },
        builder: (BuildContext context, state) {
          AppCubit cubit = AppCubit.get(context);
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              leading: cubit.isBottomSheetShown
                  ? IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.arrow_back))
                  : null,
              title: Text(cubit.titles[cubit.currentIndex]),
            ),
            body:cubit.screens[cubit.currentIndex] ,
            floatingActionButton: FloatingActionButton(
              child: Icon(cubit.fabIcon),
              onPressed: () {
                if (cubit.isBottomSheetShown) {
                  if (formKey.currentState!.validate()) {
                    cubit
                        .insertToDatabase(
                      title: titleFormFieldController.text,
                      date: dateFormFieldController.text,
                      time: timeFormFieldController.text,
                    )
                        .then((value) {
                      titleFormFieldController.clear();
                      timeFormFieldController.clear();
                      dateFormFieldController.clear();
                    });
                  }
                } else {
                  scaffoldKey.currentState!
                      .showBottomSheet(
                        (context) => SingleChildScrollView(
                          child: Container(
                            color: Colors.white,
                            padding: EdgeInsetsDirectional.all(20),
                            child: Form(
                              key: formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  defaultFormField(
                                    controller: titleFormFieldController,
                                    labelText: 'Task Title',
                                    keyboardType: TextInputType.text,
                                    prefixIcon: Icons.title,
                                    validator: (value) {
                                      if (value.toString().isEmpty) {
                                        return 'Title must not be empty';
                                      }

                                      return null;
                                    },
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  defaultFormField(
                                    controller: timeFormFieldController,
                                    labelText: 'Task Time',
                                    keyboardType: TextInputType.datetime,
                                    prefixIcon: Icons.access_time,
                                    validator: (value) {
                                      if (value.toString().isEmpty) {
                                        return 'Time must not be empty';
                                      }

                                      return null;
                                    },
                                    onTap: () {
                                      showTimePicker(
                                              context: context,
                                              initialTime: TimeOfDay.now())
                                          .then((value) {
                                        timeFormFieldController.text =
                                            value!.format(context);
                                      });
                                      FocusScope.of(context)
                                          .requestFocus(FocusNode());
                                    },
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  defaultFormField(
                                    controller: dateFormFieldController,
                                    labelText: 'Task Date',
                                    keyboardType: TextInputType.datetime,
                                    prefixIcon: Icons.calendar_today_rounded,
                                    validator: (value) {
                                      if (value.toString().isEmpty) {
                                        return 'Date must not be empty';
                                      }

                                      return null;
                                    },
                                    onTap: () {
                                      showDatePicker(
                                              context: context,
                                              initialDate: DateTime.now(),
                                              firstDate: DateTime.now(),
                                              lastDate:
                                                  DateTime.parse('2022-05-03'))
                                          .then((value) {
                                        dateFormFieldController.text =
                                            DateFormat.yMMMd().format(value!);
                                      });

                                      FocusScope.of(context)
                                          .requestFocus(FocusNode());
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        elevation: 20.0,
                      )
                      .closed
                      .then((value) {
                    cubit.changeBottomSheetState(
                        isShow: false, icon: Icons.edit);
                  });
                  cubit.changeBottomSheetState(isShow: true, icon: Icons.add);
                }
              },
            ),
            bottomNavigationBar: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                currentIndex: cubit.currentIndex,
                onTap: (index) {
                  cubit.indexChange(index);

                },
                items: [
                  BottomNavigationBarItem(
                      icon: Icon(Icons.list_rounded), label: 'Tasks'),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.check_circle_outline_rounded),
                      label: 'Done'),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.archive_outlined), label: 'Archived'),
                ]),
          );
        },
      ),
    );
  }
}
