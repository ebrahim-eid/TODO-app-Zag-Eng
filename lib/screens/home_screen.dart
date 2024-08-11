import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/cubit/cubit.dart';
import 'package:todo_app/cubit/states.dart';
import 'package:todo_app/screens/tasks_screen.dart';

import '../widgets/reusable_widgets.dart';
import 'add_tasks_screen.dart';
import 'archive_screen.dart';
import 'done_screen.dart';

// ignore: must_be_immutable
class HomeScreen extends StatelessWidget{
   HomeScreen({super.key});
  final _pageController = PageController(initialPage: 0);
  final NotchBottomBarController _controller =
  NotchBottomBarController(index: 0);
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();
  var formKey = GlobalKey<FormState>();
   bool isBottomSheetShow = false;
   List<Widget>  screens = const [
     TasksScreen(),
     ArchiveScreen(),
     DoneScreen(),
   ];

  final ValueNotifier<int> _valueNotifier=ValueNotifier<int>(0);
   @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context)=>AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit,AppStates>(
        listener: (context,state){},
        builder:  (context,state){
        List <String>titles=[
          '${AppCubit.get(context).tasks.length} tasks',
          '${AppCubit.get(context).archiveTasks.length} archive',
          '${AppCubit.get(context).doneTasks.length} done',
        ];

          return Scaffold(
            key: _scaffoldKey,
            backgroundColor: const Color.fromRGBO(169, 186, 171, 1),
            appBar: AppBar(
              centerTitle: true,
              automaticallyImplyLeading: false,
              backgroundColor: const Color.fromRGBO(169, 186, 171, 1),
              title: ValueListenableBuilder<int>(
                valueListenable: _valueNotifier,
                builder: (BuildContext context, int index, Widget? child) {

                  return Text(titles[index],style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white
                  ),);
                }
                ,),

            ),
            body: PageView(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: screens,
              onPageChanged: (index){
                _valueNotifier.value = index;
              },
          ),
            floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
            floatingActionButton: FloatingActionButton(
              onPressed: () async {
                if (isBottomSheetShow) {
                  if (formKey.currentState!.validate()) {
                    AppCubit.get(context).insertToDatabase(
                        title: titleController.text,
                        time: timeController.text,
                        date: dateController.text,
                        status: 'status')
                        .then((value) {
                      Navigator.pop(context);
                      isBottomSheetShow = false;
                    });
                  }
                } else {
                  _scaffoldKey.currentState!
                      .showBottomSheet((context) => AddTasksScreen(
                      formKey: formKey,
                      titleController: titleController,
                      timeController: timeController,
                      dateController: dateController))
                      .closed
                      .then((value) {
                    isBottomSheetShow = false;
                  });
                  isBottomSheetShow = true;
                }
              },
              backgroundColor: Colors.black87,
              child: const Icon(
                Icons.add,
                color: Colors.white,
                size: 30,
              ),
            ),
            bottomNavigationBar: AnimatedNotchBottomBar(
              color: Colors.grey,
              notchBottomBarController: _controller,
              notchColor: Colors.black87,
              elevation: 1,
              showLabel: true,
              removeMargins: false,
              bottomBarWidth: 500,
              showShadow: false,
              durationInMilliSeconds: 300,
              bottomBarItems: [
                bottomBarItem(icon: Icons.home, text: 'Tasks'),
                bottomBarItem(icon: Icons.archive, text: 'Archive'),
                bottomBarItem(icon: Icons.check_box, text: 'Done'),
              ],
              onTap: (value) {
                _pageController.jumpToPage(value);
              },
              kIconSize: 24,
              kBottomRadius: 28,
            ),
          );
        },
      ),
    );
  }
}

