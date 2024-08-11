import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/cubit/cubit.dart';

/// bottom bar item
BottomBarItem bottomBarItem({
  required IconData icon,
  required String text,
}) =>
    BottomBarItem(
        inActiveItem: Icon(
          icon,
          color: Colors.white,
        ),
        activeItem: Icon(
          icon,
          color: Colors.blueAccent,
        ),
        itemLabelWidget: Text(
          text,
          style: const TextStyle(color: Colors.white),
        ));

Widget defaultFormField(
        {required TextEditingController controller,
        required String labelText,
        required IconData icon,
        required GestureTapCallback onTap}) =>
    TextFormField(
      controller: controller,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter tour task name';
        }
        return null;
      },
      onTap: onTap,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
        labelText: labelText,
        prefixIcon: Icon(icon),
      ),
    );

/// list item

Widget listItem(
  context, {
  required Map model,
  required VoidCallback archiveClick,
  required VoidCallback deleteClick,
  required VoidCallback doneClick,
}) {
  return ListTile(
    leading: IconButton(
      onPressed: doneClick,
      icon: Icon(
         model['status']=="done" ? Icons.check_box:Icons.check_box_outline_blank,
        color: Colors.white,
      ),
    ),
    title: Row(
      children: [
        Expanded(
          child: Text(
            model['title'],
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(
          width: 20,
        ),
             IconButton(
                onPressed: archiveClick,
                icon: Icon(
                  model['status']=="archive" ? Icons.archive:Icons.archive_outlined,
                  color: Colors.white,
                )),
        IconButton(
            onPressed: deleteClick,
            icon: const Icon(
              Icons.delete,
              color: Colors.white,
            )),
      ],
    ),
    subtitle: Padding(
      padding: const EdgeInsets.only(left: 20, right: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            model['time'],
            style:
                TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 17),
          ),
          Text(
            model['date'],
            style:
                TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 17),
          ),
        ],
      ),
    ),
  );
}

/// List view

Widget buildListUi(
  context, {
  required List<Map> tasks,
}) {
  var cubit = AppCubit.get(context);
  return SingleChildScrollView(
    child: Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.88,
          height: MediaQuery.of(context).size.height * 0.788,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.grey,
          ),
          child: ConditionalBuilder(
            condition: tasks.isNotEmpty,
            builder: (BuildContext context) => ListView.separated(
                itemBuilder: (context, index) =>
                    listItem(context, model: tasks[index], archiveClick: () {
                      if(tasks [index]['status']=='archive'){
                        cubit.updateDatabaseState(
                            'status', tasks[index]['id']);
                      }else{
                        cubit.updateDatabaseState(
                            'archive', tasks[index]['id']);
                      }

                    },
                        deleteClick: () {
                      cubit.deleteFromDatabase(tasks[index]['id']);
                    },
                        doneClick: () {
                          if(tasks [index]['status']=='done'){
                            cubit.updateDatabaseState(
                                'status', tasks[index]['id']);
                          }else{
                            cubit.updateDatabaseState(
                                'done', tasks[index]['id']);
                          }
                    }),
                separatorBuilder: (context, index) => const Divider(),
                itemCount: tasks.length),
            fallback: (BuildContext context) => const Center(
              child: Text('There is no tasks',style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),),
            ),
          ),
        )
      ],
    ),
  );
}
