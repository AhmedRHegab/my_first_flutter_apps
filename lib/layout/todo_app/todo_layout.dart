import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:untitled/shared/components/components.dart';
import 'package:untitled/shared/cubit_todo/cubit.dart';
import '../../modules/todo_app/archived_tasks/archived_tasks_screen.dart';
import '../../modules/todo_app/done_tasks/done_tasks_screen.dart';
import '../../modules/todo_app/new_tasks/new_tasks_screen.dart';
import '../../shared/cubit_todo/states.dart';

class HomeLayout extends StatelessWidget
{
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

  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();

  HomeLayout({super.key});




  @override
  Widget build(BuildContext context)
  {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (BuildContext context, AppStates state)
        {
          if(state is AppInsertDatabaseState)
            {
              Navigator.pop(context);
            }
        },
      builder: (BuildContext context, AppStates state)
      {
        AppCubit cubit = AppCubit.get(context);

        return Scaffold(
          key: scaffoldKey,
          appBar: AppBar(
            title:  Text(
              cubit.titles[cubit.currentIndex],
            ),
          ),
          body: state is! AppGetDatabaseLoadingState ? cubit.screens[cubit.currentIndex]  : const Center(child: CircularProgressIndicator()),
          floatingActionButton: FloatingActionButton(
            onPressed: ()
            {
              if(cubit.isBottomSheetShown)
                {
                  if(formKey.currentState!.validate())
                  {
                    cubit.insertToDatabase(
                      title: titleController.text,
                      time: timeController.text,
                      date: dateController.text,
                    );

                  }

                }else
                {
                  scaffoldKey.currentState!.showBottomSheet(
                        (context) => Container(
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Form(
                              key: formKey,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  defaultFormField(
                                    controller: titleController,
                                      type: TextInputType.text,
                                      validate: (dynamic value)
                                      {
                                        if(value.isEmpty)
                                          {
                                            return 'title must not be empty';
                                          }
                                        return null;
                                      },
                                      label: 'Task Title',
                                      prefix: Icons.title,
                                  ),
                                  const SizedBox(
                                    height: 15.0,
                                  ),
                                  defaultFormField(
                                    controller: timeController,
                                    type: TextInputType.datetime,
                                    onTap: ()
                                    {
                                      showTimePicker(
                                          context: context,
                                          initialTime: TimeOfDay.now(),
                                      ).then((dynamic value)
                                      {
                                        timeController.text = value!.format(context).toString();
                                        print(value.format(context));
                                      });
                                    },
                                    validate: (dynamic value)
                                    {
                                      if(value.isEmpty)
                                      {
                                        return 'time must not be empty';
                                      }
                                      return null;
                                    },
                                    label: 'Task Time',
                                    prefix: Icons.watch_later_outlined,
                                  ),

                                  const SizedBox(
                                    height: 15.0,
                                  ),
                                  defaultFormField(
                                    controller: dateController,
                                    type: TextInputType.datetime,
                                    onTap: ()
                                    {
                                      showDatePicker(
                                        context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime.now(),
                                          lastDate: DateTime.parse('2022-12-12'),
                                      ).then((dynamic value)
                                      {
                                        dateController.text = DateFormat.yMMMd().format(value);
                                      });
                                    },
                                    validate: (dynamic value)
                                    {
                                      if(value.isEmpty)
                                      {
                                        return 'date must not be empty';
                                      }
                                      return null;
                                    },
                                    label: 'Task date',
                                    prefix: Icons.calendar_today,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                    elevation: 20.0,
                  ).closed.then((value) {
                    cubit.changeButtonSheetState(
                      isShow: false,
                      icon: Icons.edit,
                    );
                  });
                  cubit.changeButtonSheetState(
                    isShow: true,
                    icon: Icons.add,
                  );
                }
            },
            child: Icon(
              cubit.fabIcon,
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: cubit.currentIndex,
            onTap: (index)
            {
              cubit.changeIndex(index);
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.menu,
                ),
                label: 'tasks',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.check_circle_outline,
                ),
                label: 'done',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.archive_outlined,
                ),
                label: 'Archived',
              ),
            ],
          ),
        );
      },
    ),
    );
  }


}

